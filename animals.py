from bs4 import BeautifulSoup
from PIL import Image
from io import BytesIO
import os, requests, time, random

# --- Configuration ---
keywords = [
    "Lion",
    "Tiger",
    "Elephant",
    "Giraffe",
    "Zebra",
    "Bear",
    "Deer",
    "Wolf",
    "Fox",
    "Monkey"
]
save_dir = "wild_animals_dataset"
target_per_class = 300

os.makedirs(save_dir, exist_ok=True)

# --- Count images ---
def count_images(folder):
    return len([f for f in os.listdir(folder) if f.lower().endswith((".jpg", ".jpeg", ".png"))])

# --- Simple Google Images scraper ---
def download_from_google(keyword, folder, num=100):
    print(f"[Google] Scraping {keyword} images...")
    headers = {"User-Agent": "Mozilla/5.0"}
    search_url = f"https://www.google.com/search?q={keyword}+animal+wildlife+photo&tbm=isch"
    try:
        html = requests.get(search_url, headers=headers, timeout=15)
        soup = BeautifulSoup(html.text, "html.parser")
        images = soup.find_all("img")[1:num+1]

        for i, img_tag in enumerate(images):
            try:
                img_url = img_tag["src"]
                response = requests.get(img_url, timeout=10)
                img = Image.open(BytesIO(response.content)).convert("RGB")
                img = img.resize((224, 224))
                path = os.path.join(folder, f"{keyword.replace(' ','_')}_{int(time.time())}_{i}.jpg")
                img.save(path)
            except Exception:
                continue
    except Exception as e:
        print(f"[Error] {e}")
        time.sleep(5)  # Changed from 10 to 5

# --- Main loop ---
for animal in keywords:
    folder = os.path.join(save_dir, animal.replace(" ", "_"))
    os.makedirs(folder, exist_ok=True)

    while True:
        current = count_images(folder)
        if current >= target_per_class:
            print(f"[DONE] {animal} reached {current} images.")
            break

        remaining = target_per_class - current
        print(f"{animal}: {current}/{target_per_class} images")
        download_from_google(animal, folder, num=min(100, remaining))

        print("Sleeping 5 seconds...")
        time.sleep(5)  # Changed from random 10–20 to fixed 5
