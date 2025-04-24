#%%
import pandas as pd
import pyodbc
import json

# 1. Ler credenciais do JSON
with open(r'C:\Users\Michael\Desktop\UDD\Desafio SQL\Desafio Funcionarios\credencial_banco_st.json') as f:
    creds = json.load(f)

# 2. Ler CSV com tratamento de encoding
try:
    df = pd.read_csv('clftv.csv', encoding='utf-8')
except UnicodeDecodeError:
    df = pd.read_csv('clftv.csv', encoding='latin1')

# 3. Configurar conexão com trusted connection
conn = pyodbc.connect(
    driver='{ODBC Driver 17 for SQL Server}',
    server=creds['server'],
    database=creds['database'],
    trusted_connection='yes'
)

# 4. Criar tabela automaticamente e importar dados
with conn.cursor() as cursor:
    # Criar tabela se não existir
    cursor.execute(f"""
        IF NOT EXISTS (
            SELECT * FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'clientes' 
        )
        BEGIN
            CREATE TABLE STAGE_STUDY.clientes (
                {', '.join([f'[{col}] NVARCHAR(MAX)' for col in df.columns])}
            )
        END
    """)
    
    # Fazer upload dos dados
    for index, row in df.iterrows():
        values = tuple(row.astype(str))
        placeholders = ', '.join(['?'] * len(values))
        cursor.execute(f"""
            INSERT INTO STAGE_STUDY.clientes 
            VALUES ({placeholders})
        """, values)
    
    conn.commit()
#%%
print("Dados importados com sucesso!")
conn.close()