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

# Query Read
countYes = 0
countNO = 0
bestdistance = 100
nameofbestdistance = ""
Reallatitudereq = ""
Reallongitudereq =""
real_rank = ""
suggestedRank = ""
a = []
DPSS = 0
# Given values
Y_true_Rank = []
Y_pred_Rank = []
DistanzaInPiùPercorsa = []
# Calculated values

#docs = db.collection("request").where('Privacy','==','GPS perturbation').stream()
#docs = db.collection("request").where('Privacy','==','GPS perturbation').where('`Privacy Details`', '==','1').stream()
docs = db.collection("request").where('Privacy','==','Dummy update').where('`Privacy Details`', '==','10').stream()
# .where('`Privacy Details`', '==','2')
# .where('`Privacy Details`', '==','20')
#docs = db.collection("request").where('Privacy','==','No privacy').stream()
#docs = db.collection("request").stream()


for doc in docs:
    query = "SELECT name, latitude,longitude,rank FROM "
    dict = doc.to_dict()
    print("************")
    print(dict)
    query += dict.get("Poi Category")
    RealLocReq = dict.get("Real Location Request")
    Reallatitudereq = RealLocReq.split(":")[0]
    Reallongitudereq = RealLocReq.split(":")[1]
    suggestedRank = dict.get("Response")
    print("Rank Suggerito dal sistema: "+ str(suggestedRank.split(",")[6].lstrip().replace("]","")))
    Y_pred_Rank.append(float(suggestedRank.split(",")[6].lstrip().replace("]","")))
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
            real_rank = i[3]

    tempdist = bestdistance
    bestdistance = 100
    print(nameofbestdistance)
    print("Rank eff. più vicino: "+ str(real_rank))
    Y_true_Rank.append(float(real_rank))
    print("Distanza POI effettivamente più vicino: "+str(tempdist))

    risposta = dict.get("Response")
    DPSS = gpsDistance(str(risposta.split(",")[0].lstrip().replace("[","")),
    str(risposta.split(",")[1].lstrip()), Reallatitudereq, Reallongitudereq)
    print("Distanza POI Suggerita dal sistema: " + str(DPSS))

    if risposta:
        risposta =risposta.split(",")[5].lstrip()
    if nameofbestdistance == risposta:
        countYes += 1
        tempdist = 0
        print("Risposta corretta")
        DistanzaInPiùPercorsa.append(0)
    else:
        print("Risposta NON corretta")
        if risp:
            countNO += 1
            print("Sto camminando in più: "+str(DPSS-tempdist)+" Km")
            DistanzaInPiùPercorsa.append(DPSS-tempdist)

    print("************")
    a.append(tempdist)

a = list(filter(lambda x: x != 100, a))
print("Numero di richieste: "+str(countYes+countNO))
print("Accuratezza del sistema: "+str((countYes)/(countYes+countNO)))

# La distanza in più che fai tra il POI reale e quello suggerito
import statsmodels.stats.api as sms
print(a)
print(sms.DescrStatsW(a).tconfint_mean())
Dummy5 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Dummy10 = DistanzaInPiùPercorsa
Dummy15 = DistanzaInPiùPercorsa
Dummy20 = DistanzaInPiùPercorsa
Dummy25 = DistanzaInPiùPercorsa
plt.xticks([1, 2, 3, 4, 5], ['Dummy 5', 'Dummy 10', 'Dummy 15', 'Dummy 20', 'Dummy 25'])
plt.title('Dummy Update - Extra Distance - Confidence Interval 95%')
plot_confidence_interval(1, Dummy5)
plot_confidence_interval(2, Dummy10)
plot_confidence_interval(3, Dummy15)
plot_confidence_interval(4, Dummy20)
plot_confidence_interval(5, Dummy25)

plt.show()

import numpy as np


print(DistanzaInPiùPercorsa)
print(Y_true_Rank)
print(Y_pred_Rank)
# Mean Squared Error
MSE = np.square(np.subtract(Y_true_Rank, Y_pred_Rank)).mean()
print("MSE: "+ str(MSE))

