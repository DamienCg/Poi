import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore



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

doc_ref = db.collection("request")
docs = doc_ref.stream()

for doc in docs:
    print('{} => {}'.format(doc.id,doc.to_dict()))
