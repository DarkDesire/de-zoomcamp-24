import pandas as pd
import re

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


def camel_to_snake(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


@transformer
def transform(data, *args, **kwargs):
    
    #1. Remove rows where the passenger count is equal to 0 or the trip distance is equal to zero.
    data = data[data["passenger_count"] > 0]
    data = data[data["trip_distance"] > 0]

    #2. Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date.
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

    #3. Rename columns in Camel Case to Snake Case, e.g. VendorID to vendor_id

    # Dictionary for renaming columns
    rename_dict = {col: camel_to_snake(col) for col in data.columns if col != camel_to_snake(col)}

    # Rename the columns
    data.rename(columns=rename_dict, inplace=True)

    
    #4: Delete rows where 'vendor_id' is NA
    data.dropna(subset=['vendor_id'], inplace=True)
    
    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
    
    assert output['passenger_count'].isin([0]).sum() == 0, 'There are rides with zerp passenger_count'
    assert output['trip_distance'].isin([0]).sum() == 0, 'There are rides with zerp passenger_count'
    assert output['vendor_id'].isin([1, 2]).all(), 'There are vendors_id out of 1 or 2'