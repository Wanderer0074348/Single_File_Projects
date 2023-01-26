import requests

city = input("enter city name: ")
print(city)

print(f"The weather for : {city} ")

url = f"https://wttr.in/{city}"
out = requests.get(url)

print(out.text)