import matplotlib.pyplot as plt
from sklearn.preprocessing import normalize


# create data
x = [30.85/6,6.12/6,0.44/6]
#x = normalize([x], norm="l1")

y = [4.68/6,3.42/6,0]
#y = normalize([y], norm="l1")

plt.xticks([0, 1, 2], ['Digit 0', 'Digit 1', 'Digit 2'])
plt.title("Trade Off Trade Off - ( Privacy Preservation, Quality of Service)")
plt.plot(x, 'o-', color='blue', label="PP - Km")
plt.plot(y, 'o-', color='green', label= "QoS - MSE")
plt.legend()
plt.show()