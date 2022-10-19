#Importing required modules
from sklearn.datasets import load_digits
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import numpy as np

# Load Data
data = load_digits().data
pca = PCA(2)

# Transform the data
df = pca.fit_transform(data)

# Import KMeans module
from sklearn.cluster import KMeans

# Initialize the class object
kmeans = KMeans(n_clusters=10)

# predict the labels of clusters.
label = kmeans.fit_predict(df)

# Getting unique labels
u_labels = np.unique(label)

centroids = kmeans.cluster_centers_

# plotting the results:

for i in u_labels:
    plt.scatter(df[label == i , 0] , df[label == i , 1] , label = i)

plt.scatter(centroids[:,0] , centroids[:,1] , s = 80, color = 'k')
plt.legend()
plt.show()