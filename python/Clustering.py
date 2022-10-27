
import matplotlib.pyplot as plt
import numpy as np
import geopy.distance

# Load Data
df = np.array([[44.515605647982426,11.336205105716656], [44.51476333265623,11.353609374101715],
               [44.52717247094629,11.331005172656683],  [44.52420349640807,11.341550677340212],
               [44.52578308957609,11.32506359966609],[44.520935057687296,11.352540964505081],
               [44.52666961080558,11.336777584780307],[44.530023703377296,11.352358656329805],
               [44.51517421370734,11.33990912999693],[44.51509859997074,11.350581515878151],
[44.529395344515066,11.350357724695176],[44.50187606929695,11.346618169065621],
[44.53001807803357,11.331934647533986],[44.520275164899026,11.34994458241604],[44.50412041690384,11.33776536392805]
,[44.52206268056505,11.327177448194613],[44.519429374757415,11.353469647740681],[44.50196317382587,11.32810303111951],
[44.52442087106821,11.354599193202066]])
RealLat = 44.51517421370734
RealLong = 11.33990912999693

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