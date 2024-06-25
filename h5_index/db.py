from sqlalchemy import create_engine, inspect, text

# Replace the following connection string with your database's connection string.
# Example connection string for SQLite:
connection_string = 'sqlite:///h5.db'

# Create an engine
engine = create_engine(connection_string)

# Create an inspector object
inspector = inspect(engine)

# Get table names
table_names = inspector.get_table_names()

# Function to get the number of rows in a table
def get_row_count(engine, table_name):
    with engine.connect() as connection:
        result = connection.execute(text(f'SELECT COUNT(*) FROM {table_name}'))
        row_count = result.scalar()
        return row_count

# Dictionary to store the number of rows for each table
table_row_counts = {}

print("Number of rows in each table:")
for table in table_names:
    row_count = get_row_count(engine, table)
    table_row_counts[table] = row_count
    print(f"{table}: {row_count}")