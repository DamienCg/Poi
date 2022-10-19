import geopy.distance
import statistics
from math import sqrt
import geopy.distance
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import geopy.distance
import matplotlib.pyplot as plt

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

def gpsDistance(lat1, long1, lat2, long2):
    pointOne = (lat1, long1)
    pointTwo = (lat2, long2)
    return geopy.distance.geodesic(pointOne, pointTwo).km


# Fetch the service account key JSON file contents
cred = credentials.Certificate('secret_key.json')
# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred)

db = firestore.client()

# Query Read

#docs = db.collection("request").where('Privacy','==','GPS perturbation').stream()
docs = db.collection("request").where('Privacy','==','GPS perturbation').where('`Privacy Details`', '==','2').stream()
#docs = db.collection("request").where('Privacy','==','Dummy update').where('`Privacy Details`', '==','25').stream()
# .where('`Privacy Details`', '==','2')
# .where('`Privacy Details`', '==','20')
#docs = db.collection("request").where('Privacy','==','No privacy').stream()
#docs = db.collection("request").stream()





Locations_Request_After_Privacy = []
Real_Locations_Request = []
count = 0

for doc in docs:
    dict = doc.to_dict()
    Real_Locations_Request.append(dict.get("Real Location Request"))
    Locations_Request_After_Privacy.append(dict.get("Location Request After Privacy"))
    count +=1


ArrayDistance = []

for i in range(count):
    ArrayDistance.append(gpsDistance(Locations_Request_After_Privacy[i].split(":")[0],
                                     Locations_Request_After_Privacy[i].split(":")[1],
                                     Real_Locations_Request[i].split(":")[0],
                                     Real_Locations_Request[i].split(":")[1]))




meandistance = list(map(float, ArrayDistance))
print(meandistance)
Digit0 = [54.7262665934051, 13.663173650026756, 13.660990761409538, 13.670459880679068, 41.030726246746106, 33.3375473012539, 26.31036040142188, 27.348470813353465, 41.03492671561173, 13.669859083201779, 50.488800798157484, 32.579903997978455, 22.224738408229985, 31.818576197956947, 47.19352577525141]
Digit1 = [3.9752243793626025, 9.740035637794906, 3.2614424479120925, 7.081988926134283, 5.190388755078336, 3.3336758996430373, 6.854699773502888, 3.87930689443684, 7.819092376810396, 6.401544591398622, 5.8236914915499876, 10.09162682950494]
Digit2 = [0.44448698373672973, 0.7387292145198312, 0.4099395950697031, 0.7185361884730893, 0.36939927188726585, 0.4720860268986104, 0.4900367707102543, 0.11112223333580216, 0.13666767830821724, 0.5820643265791973, 0.33336520344531134]
print(statistics.mean(Digit0))
print(statistics.mean(Digit1))
print(statistics.mean(Digit2))

plt.xticks([1, 2, 3], ['Digit 0', 'Digit 1', 'Digit 2'])
plt.title('Dummy Update - Confidence Interval 95%')
plot_confidence_interval(1, Digit0)
plot_confidence_interval(2, Digit1)
plot_confidence_interval(3, Digit2)
plt.show()

