import math

def calculate_new_position(lat1, lon1, distance, bearing):
    # Convert distance and bearing to radians
    distance = distance / 6371.0 # Divide distance by Earth's radius to convert to radians
    bearing = math.radians(bearing) # Convert bearing to radians

    lat1 = math.radians(lat1)
    lon1 = math.radians(lon1)

    lat2 = math.asin(math.sin(lat1) * math.cos(distance) + math.cos(lat1) * math.sin(distance) * math.cos(bearing))
    lon2 = lon1 + math.atan2(math.sin(bearing) * math.sin(distance) * math.cos(lat1), math.cos(distance) - math.sin(lat1) * math.sin(lat2))

    # Convert back to degrees
    lat2 = math.degrees(lat2)
    lon2 = math.degrees(lon2)

    return (lat2, lon2)

# Example usage
lat1 = 44.494426044
lon1 = 11.347550472
distance = 1 # Mean distance in kilometers
bearing = 45 # Random bearing in degrees

new_position = calculate_new_position(lat1, lon1, distance, bearing)
print(new_position)
