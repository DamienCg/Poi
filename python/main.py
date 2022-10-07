import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import psycopg2
import geopy.distance
import matplotlib.pyplot as plt
import statistics
from math import sqrt

def gpsDistance(lat1, long1, lat2, long2):
    pointOne = (lat1, long1)
    pointTwo = (lat2, long2)
    return geopy.distance.geodesic(pointOne, pointTwo).km

def plot_confidence_interval(x, values, z=1.96, color='#2187bb', horizontal_line_width=0.25):
    mean = statistics.mean(values)
    stdev = statistics.stdev(values)
    confidence_interval = z * stdev / sqrt(len(values))

    left = x - horizontal_line_width / 2
    top = mean - confidence_interval
    right = x + horizontal_line_width / 2
    bottom = mean + confidence_interval
    plt.plot([x, x], [top, bottom], color=color)
    plt.plot([left, right], [top, top], color=color)
    plt.plot([left, right], [bottom, bottom], color=color)
    plt.plot(x, mean, 'o', color='#f44336')

    return mean, confidence_interval

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
a = []
#docs = db.collection("request").where('Privacy','==','GPS perturbation').stream()
#docs = db.collection("request").where('Privacy','==','GPS perturbation').where('`Privacy Details`', '==','2').stream()
docs = db.collection("request").where('Privacy','==','Dummy update').where('`Privacy Details`', '==','25').stream()
# .where('`Privacy Details`', '==','2')
# .where('`Privacy Details`', '==','20')
#docs = db.collection("request").where('Privacy','==','No privacy').stream()
#docs = db.collection("request").stream()


for doc in docs:
    query = "SELECT name, latitude,longitude FROM "
    dict = doc.to_dict()
    print("************")
    print(dict)
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

    tempdist = bestdistance
    bestdistance = 100
    print(nameofbestdistance)
    print("************")
    risposta = dict.get("Response")
    if risposta:
        risposta =risposta.split(",")[5].lstrip()
    if nameofbestdistance == risposta:
        countYes += 1
        tempdist = 0
    else:
        if risp:
            countNO += 1


    a.append(tempdist)

a = list(filter(lambda x: x != 100, a))
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

import statsmodels.stats.api as sms
print(a)
print(sms.DescrStatsW(a).tconfint_mean())
Dummy5 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.369781484674313, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Dummy10 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Dummy15 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7.085164409777618, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Dummy20 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
plt.xticks([1, 2, 3,4,5], ['Dummy 5', 'Dummy 10', 'Dummy 15','Dummy 20', 'Dummy 25',])
plt.title('Dummy Update - Confidence Interval 95%')
plot_confidence_interval(1, Dummy5)
plot_confidence_interval(2, Dummy10)
plot_confidence_interval(3, Dummy15)
plot_confidence_interval(4, Dummy20)
plot_confidence_interval(5, a)
plt.show()




