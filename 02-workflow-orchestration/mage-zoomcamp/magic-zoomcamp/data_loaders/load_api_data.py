import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


def load_dataframe(date):
    file_name = f'green_tripdata_{date}.csv.gz'
    url = f'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/{file_name}'
    print("Loading: ", url)

    response = requests.get(url)
    #You can use the same datatypes and date parsing methods shown in the course.
    taxi_dtypes = {
        'VendorID': pd.Int64Dtype(),
        'passenger_count': pd.Int64Dtype(),
        'trip_distance': float,
        'RatecodeID': pd.Int64Dtype(),
        'store_and_fwd_flag': str,
        'PULocationID': pd.Int64Dtype(),
        'DOLocationID': pd.Int64Dtype(),
        'payment_type': pd.Int64Dtype(),
        'fare_amount': float,
        'extra': float,
        'mta_tax': float,
        'tip_amount': float,
        'tolls_amount': float,
        'improvement_surcharge': float,
        'total_amount': float,
        'congestion_surcharge': float 
    }

    parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

    df = pd.read_csv(url, sep=",", compression="gzip", dtype=taxi_dtypes, parse_dates=parse_dates) 
    print(file_name, "has been downloaded and parsed")
    return df

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """

    # BONUS: load the final three months using a for loop and pd.concat
    df = pd.DataFrame()
    for date in ["2020-10", "2020-11", "2020-12"]:
        month_df = load_dataframe(date)
        df = pd.concat([month_df, df], ignore_index=True)
    
    return(df)

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
