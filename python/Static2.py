from datetime import datetime
import matplotlib.pyplot as plt
import random
import geopy.distance
from meteostat import Point, Daily


NUM_OF_DUMMIES = 20
LAT_ORIG = 44.49204774300842
LONG_ORIG = 11.346995267936455
START_TIME = datetime(2022, 4, 6)
END_TIME = datetime(2022, 4, 6)

privacyMetric = [0, 0, 0]
qosMetric = [0, 0, 0]


def getTempValue(lat, long):
    location = Point(lat, long)
    data = Daily(location, START_TIME, END_TIME)
    data = data.fetch()
    tempValue = data["tavg"].tolist()
    if (len(tempValue) > 0):
        return tempValue[0]
    else:
        return None


def gpsDistance(lat1, long1, lat2, long2):
    pointOne = (lat1, long1)
    pointTwo = (lat2, long2)
    return geopy.distance.geodesic(pointOne, pointTwo).km


def Dummies(lat,long):
    randomLat = random.uniform(lat - 0.015,lat + 0.01)
    randomLong = random.uniform(long - 0.01,long + 0.015)
    print(randomLat," ",randomLong)
    return randomLat, randomLong



numReplies = 0
tempOrig = getTempValue(LAT_ORIG, LONG_ORIG)

distances = []
for run in range(0, NUM_OF_DUMMIES):
        latNew, longNew = Dummies(LAT_ORIG,LONG_ORIG)
        tempNew = getTempValue(float(latNew), float(longNew))
        if (tempNew != None):
            tempDiff = (tempOrig - tempNew)
            distances.append(gpsDistance(LAT_ORIG, LONG_ORIG, float(latNew), float(longNew)))
            numReplies += 1

import statistics

print(statistics.mean(distances))
