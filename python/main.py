import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import psycopg2
import geopy.distance

def gpsDistance(lat1, long1, lat2, long2):
    pointOne = (lat1, long1)
    pointTwo = (lat2, long2)
    return geopy.distance.geodesic(pointOne, pointTwo).km

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
countYes = 0
countNO = 0
bestdistance = 100
nameofbestdistance = ""
Reallatitudereq = ""
Reallongitudereq =""
docs = db.collection("request").where('Privacy','==','GPS perturbation').where('`Privacy Details`', '==','2').stream()

docs = db.collection("request").where('Privacy','==','Dummy update').where('`Privacy Details`', '==','25').stream()


for doc in docs:
    query = "SELECT name, latitude,longitude FROM "
    dict = doc.to_dict()
    query += dict.get("Poi Category")
    RealLocReq = dict.get("Real Location Request")
    Reallatitudereq = RealLocReq.split(":")[0]
    Reallongitudereq = RealLocReq.split(":")[1]
    query += " p where p.rank >= "+str(dict.get("Rank"))

    """ Query to DB """
    cursor = connPostgress.cursor()
    cursor.execute(query)
    risp = cursor.fetchall()# is a list of tuple
    for i in risp:
        lattemp = i[1]
        longtemp = i[2]
        # Quali di quest temp è il più vicino a realLat and realLong?
        distancetemp = gpsDistance(lattemp, longtemp, Reallatitudereq, Reallongitudereq)
        if distancetemp <= bestdistance:
            bestdistance = distancetemp
            nameofbestdistance =i[0]

    bestdistance = 100
    risposta = dict.get("Response").split(",")[5].lstrip()
    if nameofbestdistance == risposta:
        countYes += 1
    else:
        countNO += 1


print("Numero di richieste: "+str(countYes+countNO))
print("Accuratezza del sistema: "+str((countYes)/(countYes+countNO)))


"""
250 Totali con accuratezza del 76%
153 perturbation con accuratezza 64%
97 Dummy update con accuratezza  96%


"""




