import pandas as pd
import sqlite3

print("1. Reading Excel dataset (Sheet: Year 2010-2011)...")
file_path = 'online_retail_II.xlsx'
df = pd.read_excel(file_path, sheet_name='Year 2010-2011')

print("2. Cleaning raw data for SQL database ingestion...")
# Drop missing customer IDs & invalid transactions
df = df.dropna(subset=['Customer ID'])
df = df[(df['Quantity'] > 0) & (df['Price'] > 0)]
df['Invoice'] = df['Invoice'].astype(str)
df = df[~df['Invoice'].str.startswith('C')]

# Rename columns to standard SQL snake_case format
df.columns = [
    'invoice_no', 'stock_code', 'description', 
    'quantity', 'invoice_date', 'unit_price', 
    'customer_id', 'country'
]

print("3. Connecting to SQLite Database and creating 'transactions' table...")
# Creates 'ecommerce.db' automatically if it doesn't exist
conn = sqlite3.connect('ecommerce.db')
df.to_sql('transactions', conn, if_exists='replace', index=False)
conn.close()

print("\n🎉 SUCCESS! SQL Database 'ecommerce.db' successfully created.")