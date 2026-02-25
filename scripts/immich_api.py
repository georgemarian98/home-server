#!/usr/bin/python3

import requests
import re
from datetime import datetime


API_KEY = 'i1DciJlouW7jfxfoCllUiHPoZQLqwt1JhrPrBSE'

def update_asset(asset, new_date):

    print(f'  update "{asset["originalFileName"]}" to {new_date};')

    new_date_obj = datetime.strptime(new_date, '%Y%m%d').isoformat()
    response = requests.put(f'https://immich.rlgland.site/api/assets/{asset["id"]}', headers={'x-api-key': API_KEY}, json={
        'ids': [asset["id"]],
        'dateTimeOriginal': new_date_obj,
        'timeZone': 'Europe/Bucharest',
    })

    if response.status_code // 100 != 2:
        print('Error:', response.text)
        return 
    
def update_assets_from_album(album_id):
    response = requests.get(f'https://immich.rlgland.site/api/albums/{album_id}', headers={'x-api-key': API_KEY})

    if response.status_code // 100 != 2:
        print('Error:', response.text)
        return
    
    assets = response.json()['assets']
    pattern = re.compile(r'^(?:IMG|VID)[-_](\d{8})')

    for asset in assets:
        print(f'asset id: {asset["originalFileName"]} - {asset["exifInfo"]["dateTimeOriginal"]} - {asset["exifInfo"]["timeZone"]}')

        m = pattern.search(asset["originalFileName"])
        if m:
            date_str = m.group(1)
            asset_date = asset["exifInfo"]["dateTimeOriginal"].split('T')[0].replace('-', '')
            
            if date_str != asset_date:
                update_asset(asset, date_str)


def main():
    update_assets_from_album('137b1298-9b34-4a77-a3d0-a932f5e40fe8')

if __name__ == "__main__":
    main()
