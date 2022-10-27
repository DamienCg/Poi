
import matplotlib.pyplot as plt
import numpy as np
import geopy.distance


# Load Data
df = np.array([ [44.49882025933643,11.331561550745327],
[44.49696193961376,11.318401523130738],
[44.50996466592943,11.324189903977095],
[44.50258727125087,11.306745854792497],
[44.49196059171772,11.327432357958221 ],
[44.49738906710898,11.315335155058722],
[44.48973530958908,11.320383469352224],
[44.50375789163736,11.315066712827296],
[44.49218977756084,11.320316516344677],
[44.50632532134778,11.320551547573503 ],
[44.507804030599125,11.308122298824657],
[44.49095279546594,11.315831108445407 ],
[44.487040914378284,11.326445424623763],
[44.50120516186032,11.30800048029512],
[44.495119253466044,11.312612655839065],
[44.49530277963258,11.316057688048177],
[44.49131474553889,11.324436307452865],
[44.481136621794896,11.308005923135905],
[44.488068565802024,11.320109843434729],
[44.48644377329158,11.31987681136544],
[44.48259006106223,11.319012385434286],
[44.50526155469939,11.327941726779297],
[44.49511225195951,11.31869718238256],
[44.49173205140102,11.310946203506893],
[44.51005321954967,11.316017518388497]])
RealLat = 44.49511225195951
RealLong = 11.31869718238256

# Transform the data
def gpsDistance(lat1, long1, lat2, long2):
    pointOne = (lat1, long1)
    pointTwo = (lat2, long2)
    return geopy.distance.geodesic(pointOne, pointTwo).km

# Import KMeans module
from sklearn.cluster import KMeans

# Initialize the class object
kmeans = KMeans(n_clusters=1)

# predict the labels of clusters.
label = kmeans.fit_predict(df)

# Getting unique labels
u_labels = np.unique(label)

centroids = kmeans.cluster_centers_
print(centroids)
# plotting the results:

for i in u_labels:
    plt.scatter(df[label == i , 0] , df[label == i , 1], label='Fake (Dummy Update)' )

plt.scatter(centroids[:,0] , centroids[:,1] , s = 80, color = 'k',label='Centroid')
#scatter real position
distance = gpsDistance(RealLat, RealLong, centroids[:,0][0], centroids[:,1][0])
plt.scatter(RealLat, RealLong , s = 80, color = 'red', label='Real position')
plt.legend()
plt.title('Distance Centroid-Real position: '+str(distance)+' Km')
plt.show()