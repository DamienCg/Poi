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
#docs = db.collection("request").where('Privacy','==','GPS perturbation').where('`Privacy Details`', '==','2').stream()
docs = db.collection("request").where('Privacy','==','Dummy update').where('`Privacy Details`', '==','25').stream()
# .where('`Privacy Details`', '==','2')
# .where('`Privacy Details`', '==','20')
#docs = db.collection("request").where('Privacy','==','No privacy').stream()
#docs = db.collection("request").stream()




Reallatitudereq = ""
Reallongitudereq =""
a = []

for doc in docs:
    dict = doc.to_dict()
    RealLocReq = dict.get("Real Location Request")
    Reallatitudereq = RealLocReq.split(":")[0]
    Reallongitudereq = RealLocReq.split(":")[1]
    risposta = dict.get("Location Request After Privacy")
    a.append(risposta)


meandistance = []
for i in a:
    meandistance.append(gpsDistance(i.split(":")[0], i.split(":")[1], Reallatitudereq, Reallongitudereq))


meandistance = list(map(float, meandistance))
print(meandistance)
Dummy5 = [1.3576064439064328, 0.0, 1.0230464634965228, 1.6596890204889259, 1.072340613701723]
Dummy10 = [1.1845836642806904, 1.1345860130731695, 1.2325545055475922, 0.8811276276202008, 1.0693752342127412, 0.9631571968074373, 0.7013984643989232, 1.214774083552487, 0.0, 0.8026882540198855]
Dummy15 = [1.4651568138916171, 0.879370402658601, 1.5248162469112139, 1.756336126683785, 1.5331288728791064, 1.47206169002301, 0.8171028819840245, 1.1709674963071488, 0.0, 0.5841765035637297, 1.3019231203396227, 0.1643377448553536, 1.4443381345904478, 1.1372178375517628, 1.297524296115346]
Dummy20 = [1.366549727751475, 1.3364014898476053, 0.8167146469884395, 0.6055378146794494, 0.0, 0.9915979849918781, 0.1593216493025096, 1.1980139370098135, 1.468091197025295, 0.8886464794041321, 1.064949874963047, 1.1595936393086754, 1.4584000385906952, 1.5374126690569365, 1.4300080354230904, 1.011804428829572, 0.7610699284544472, 1.7167553313146018, 1.007462441624033, 1.2363477859262044]
Dummy25 = meandistance
plt.xticks([1, 2, 3, 4, 5], ['Dummy 5', 'Dummy 10', 'Dummy 15','Dummy 20', 'Dummy 25',])
plt.title('Dummy Update - Confidence Interval 95%')
plot_confidence_interval(1, Dummy5)
plot_confidence_interval(2, Dummy10)
plot_confidence_interval(3, Dummy15)
plot_confidence_interval(4, Dummy20)
plot_confidence_interval(5, Dummy25)
plt.show()

