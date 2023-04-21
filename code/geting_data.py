import requests
import pandas as pd
#import csv
from tenacity import retry
import json



def geting_data():
    """
    This function make the request to take the data from de API. The API corresponds to the national government's open data system. 
    It is a data provision mechanism based on CKAN available at https://datos.gob.ar/acerca/ckan.
    """
    url = "http://datos.energia.gob.ar/api/3/action/datastore_search?resource_id=517a3213-e3fd-447c-899b-6ba54fe511d7"
    args = {'offset' : 0, 'limit' : 19573 }
    
    try:
        
        response = requests.get(url, params = args)

        if response.status_code == 200:
            response_json = response.json()
            records = response_json["result"]["records"]
            df = pd.json_normalize(records)
            
            return df

        else:
            return 404
        
    except requests.exceptions.ConnectionError:
        stop_after_10intents()
    
def transform_df(df):
    cordoba_ciudad = df[(df["provincia"] == "CORDOBA") & (df["localidad"] == "CORDOBA")]
    return cordoba_ciudad
    
@retry(Exception, total_tries = 10, initial_wait = 0.5)
def stop_after_10intents ():
    print ("Stopping after 10 attempts, and connection is failed")
    

    
if __name__ == "__main__":
    df = geting_data()
    df.to_csv("data/eess_gral.csv")
    df_cba = transform_df(df)
    df_cba.to_csv("data/estaciones_cba.csv")
    