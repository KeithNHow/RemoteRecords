# Remote Records Extension
This extension consists of 1 codeunit, 1 page and 1 table. It is used to demonstrate 

# Demo table
New table for demo asset, which will be used for API test. The OnValidate trigger of Id field is used to call JsonRead method in KNH Json Write codeunit, which will read the record and write to a json file in the server.

# Demo Card page
This card page is used to test API connection and to create a Json file, based on the KNHDemo table. The page has two actions, one for creating a Json file and another for testing the Http connection.

# Json Write codeunit
This codeunit demonstrates how to write Json data and make Http requests. It includes a method that reads Json data and places it in a table. 

The OnRun trigger creates a Json file based on the first record of the Customer table. 

The HttpTest method makes a get request to an API endpoint and returns the response. 

The JsonRead method makes a get request to an API endpoint, reads the Json response, and places the data in the KNHDemo table.