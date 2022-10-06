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

#docs = db.collection("request").where('Privacy','==','GPS perturbation').stream()
#docs = db.collection("request").where('Privacy','==','Dummy update').stream()
# .where('`Privacy Details`', '==','2')
# .where('`Privacy Details`', '==','20')
#docs = db.collection("request").where('Privacy','!=','No privacy').stream()
docs = db.collection("request").stream()


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
Accuratezza totale sistema (350 richieste): 0.81%

Accuratezza No privacy (20 richieste): 100%

330 Totali del sistema con meccanismi privacy dummy or pertubation 
con accuratezza del 80%

160 perturbation tutali con accuratezza 63%
- Digit 0 -> 50 richieste -> accuratezza 36%
- Digit 1 -> 60 richieste -> accuratezza 57%
- Digit 2 -> 50 richieste -> accuratezza 98%


170 Dummy update totali con accuratezza  96%
- Dummy 5 -> 30 richieste -> con accuratezza 96%
- Dummy 10 -> 30 richieste -> con accuratezza 97%
- Dummy 15 -> 40 richieste -> con accuratezza 97.5%
- Dummy 20 -> 20 richieste -> con accuratezza 100%
- Dummy 25 -> 50  richieste -> con accuratezza 94%


"""




