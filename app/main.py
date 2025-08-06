from fastapi import FastAPI
import httpx
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response

app = FastAPI()

CHARACTER_URL = "https://rickandmortyapi.com/api/character"
fetch_counter = Counter("characters_fetched_total", "Total characters fetched")


@app.get("/characters")
async def get_characters():
    results = []
    url = CHARACTER_URL
    async with httpx.AsyncClient() as client:
        while url:
            resp = await client.get(url)
            data = resp.json()
            for char in data["results"]:
                if (char["species"] == "Human" and
                   char["status"] == "Alive" and
                   "Earth" in char["origin"]["name"]):

                    results.append({
                        "id": char["id"],
                        "name": char["name"],
                        "origin": char["origin"]["name"]
                    })
            url = data["info"]["next"]
    fetch_counter.inc(len(results))
    return results


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.get("/healthz")
def health():
    return {"status": "ok"}
