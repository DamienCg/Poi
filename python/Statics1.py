from datetime import datetime
import matplotlib.pyplot as plt
import random
import geopy.distance
from meteostat import Point, Daily


NUM_RUNS = 500
NUM_DIGITS = 3
LAT_ORIG = 44.99396098265174
LONG_ORIG = 11.342755232742132
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


def perturbate(digit):
    print(digit)
    print("Lat origin: ",LAT_ORIG)
    latStr = str(LAT_ORIG)
    longStr = str(LONG_ORIG)
    digitRandom = random.randint(0, 9)
    latNew = latStr[:3 + digit] + str(digitRandom) + latStr[3 + digit + 1:]
    digitRandom = random.randint(0, 9)
    longNew = longStr[:3 + digit] + str(digitRandom) + longStr[3 + digit + 1:]
    print("New Lat:    ",latNew)
    print("---------------")
    return latNew, longNew



numReplies = 0
tempOrig = getTempValue(LAT_ORIG, LONG_ORIG)


for run in range(0, NUM_RUNS):
    for digit in range(0, NUM_DIGITS):
        latNew, longNew = perturbate(digit)
        tempNew = getTempValue(float(latNew), float(longNew))
        if (tempNew != None):
            tempDiff = (tempOrig - tempNew)
            distance = gpsDistance(LAT_ORIG, LONG_ORIG, float(latNew), float(longNew))
            privacyMetric[digit] += distance
            qosMetric[digit] += (tempDiff * tempDiff)
            numReplies += 1

kmperdigit = []

for digit in range(0, NUM_DIGITS):
    privacyMetric[digit] = privacyMetric[digit] / numReplies
    qosMetric[digit] = qosMetric[digit] * 1.0 / numReplies
    kmperdigit.append(privacyMetric[digit])
    print(" Perturbation digit: %d Privacy (km): %f QoS (d^2): %f" % (digit, privacyMetric[digit], qosMetric[digit]))



MDigit = ['P.Digit 0', 'P.Digit 1', 'P.Digit 2']
Km_Per_Digit = [kmperdigit[0], kmperdigit[1], kmperdigit[2]]
plt.bar(MDigit, Km_Per_Digit)
plt.title('Difference in KM Original-Pertubation - 500 runs')
plt.xlabel('Number of Digit')
plt.ylabel('km difference')
plt.show()