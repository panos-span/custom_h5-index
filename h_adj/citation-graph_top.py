import networkx as nx
import sqlite3
import matplotlib.pyplot as plt

GRAPH_DATABASE_PATH = "h5.db"
ROLAP_DATABASE_PATH = "rolap.db"


def doi_workid(cursor, doi):
    """Return the work-id for the specified DOI"""
    cursor.execute("SELECT id FROM works WHERE doi = ?", (doi,))
    res = cursor.fetchone()
    if res:
        (id,) = res
        return id
    return None


def workid_doi(cursor, id):
    """Return the DOI for the specified work-id"""
    cursor.execute("SELECT doi FROM works WHERE id = ?", (id,))
    (doi,) = cursor.fetchone()
    return doi


def add_citation_edges(connection, graph, start, depth):
    if depth == -1:
        return
    cursor = connection.cursor()

    # Outgoing references
    print("START", start, depth, flush=True)
    cursor.execute(
        """SELECT id FROM work_references
        INNER JOIN works ON work_references.doi = works.doi
        WHERE work_references.work_id = ?""",
        (start,),
    )
    for (id,) in cursor:
        graph.add_edge(start, id)
        add_citation_edges(connection, graph, id, depth - 1)

    # Incoming references
    work_doi = workid_doi(cursor, start)
    cursor.execute("SELECT work_id FROM work_references WHERE doi = ?", (work_doi,))
    for (id,) in cursor:
        graph.add_edge(start, id)
        add_citation_edges(connection, graph, id, depth - 1)

    cursor.close()


def citation_graph(connection, start):
    """Return a graph induced by incoming and outgoing citations of
    distance 2 for the specified work-id"""
    graph = nx.DiGraph()  # Use directed graph to get in_degree and out_degree
    add_citation_edges(connection, graph, start, 1)
    return graph


def graph_properties(rolap_connection, graph_connection, selection, file_name):
    """Write to the specified file name the graph properties of the work-ids
    obtained from rolap through the specified selection statement"""
    cursor = rolap_connection.cursor()
    cursor.execute(selection)
    with open(file_name, "w") as fh:
        for (id,) in cursor:
            graph = citation_graph(graph_connection, id)
            print(id, graph)
            properties = analyze_graph_properties(graph)
            fh.write(f"ID: {id}\n")
            for prop, value in properties.items():
                fh.write(f"{prop}: {value}\n")
            fh.write("\n")
    cursor.close()

def analyze_graph_properties(graph):
    properties = {}
    properties['avg_clustering'] = nx.average_clustering(graph.to_undirected())
    if nx.is_connected(graph.to_undirected()):
        properties['avg_path_length'] = nx.average_shortest_path_length(graph.to_undirected())
    else:
        properties['avg_path_length'] = None
    properties['in_degree'] = dict(graph.in_degree())
    properties['out_degree'] = dict(graph.out_degree())
    properties['degree_centrality'] = nx.degree_centrality(graph)
    properties['betweenness_centrality'] = nx.betweenness_centrality(graph)
    properties['eigenvector_centrality'] = nx.eigenvector_centrality(graph)
    return properties

def visualize_graph(graph, file_name):
    pos = nx.spring_layout(graph)
    plt.figure(figsize=(10, 10))
    nx.draw(graph, pos, with_labels=True, node_size=50, font_size=8)
    plt.savefig(file_name, format="svg")
    plt.close()

graph_connection = sqlite3.connect(GRAPH_DATABASE_PATH)
rolap_connection = sqlite3.connect(ROLAP_DATABASE_PATH)

graph_properties(
    rolap_connection,
    graph_connection,
    "SELECT id FROM random_top_works ",
    "reports/graph-top.txt",
)

graph_properties(
    rolap_connection,
    graph_connection,
    "SELECT id FROM random_top_other_works ",
    "reports/graph-other.txt",
)

# Example of visualizing a graph for a specific work-id
example_graph = citation_graph(graph_connection, 337084982)  # Replace with an actual work-id
visualize_graph(example_graph, "reports/example_graph.svg")