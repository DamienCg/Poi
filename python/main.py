import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import psycopg2

connPostgress = psycopg2.connect(database="postgres",
                        host="localhost",
                        user="postgres",
                        password="9964",
                        port="5432")

# Fetch the service account key JSON file contents
cred = credentials.Certificate('secret_key.json')
# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred)

db = firestore.client()

### Write ###
"""

doc_ref = db.collection("db").document("doc")
doc_ref.set({
    'name':'ciro'
})

"""
#

### Read ###
"""

doc_ref = db.collection("request")
docs = doc_ref.stream()

for doc in docs:
    print('{} => {}'.format(doc.id,doc.to_dict()))

"""

# Query Read
query = "SELECT name FROM "
docs = db.collection("request").where('Privacy', '!=','No privacy').stream()
for doc in docs:
    print('{} => {}'.format(doc.id,doc.to_dict()))
    dict = doc.to_dict()
    query += dict.get("Poi Category")
    print(query)
    break


cursor = connPostgress.cursor()
cursor.execute(query)
print(cursor.fetchall())





