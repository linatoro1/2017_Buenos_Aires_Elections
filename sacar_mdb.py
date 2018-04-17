import csv, pyodbc

# set up some constants
MDB = "~/.wine/drive_c/Program Files (x86)/Buenos Aires 2017/DATOS/BUENOSAIRES2017.mdb"; DRV = '{Microsoft Access Driver (*.mdb)}'; PWD = 'pw'

# connect to db
con = pyodbc.connect('DRIVER={};DBQ={};PWD={}'.format(DRV,MDB,PWD))
cur = con.cursor()

# run a query and get the results
SQL = 'SELECT MSysObjects.Name AS table_name FROM MSysObjects' # your query goes here
rows = cur.execute(SQL).fetchall()
cur.close()
con.close()

print "AAa"