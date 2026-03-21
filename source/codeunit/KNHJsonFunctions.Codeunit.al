/// <summary>
/// This codeunit demonstrates how to write Json data and make Http requests. It includes a method that reads Json data and places it in a table. 
/// The OnRun trigger creates a Json file based on the first record of the Customer table. 
/// The HttpTest method makes a get request to an API endpoint and returns the HttpResponseMessage. 
/// The JsonRead method makes a get request to an API endpoint, reads the Json HttpResponseMessage, and places the data in the KNHDemo table.
/// </summary>
namespace KNHRemoteRecords;
Using Microsoft.Sales.Customer;
using System.Utilities;

codeunit 51910 KNHJsonFunctions
{
    procedure JsonExport()
    var
        Customer: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        Arr: JsonArray;
        SecondArr: JsonArray;
        Object: JsonObject;
        SecondObject: JsonObject;
        ThirdObject: JsonObject;
        OutStream: OutStream;
        FileName: Text;
        Result: Text;
    begin
        FileName := 'Customer.Json'; //name file
        Customer.Get('10000'); //get cust rec
        //first section
        Object.Add('No.', Customer."No.");
        Object.Add('Name', Customer.Name);

        //second section
        SecondObject.Add('Address', Customer.Address);
        SecondObject.Add('City', Customer.City);
        SecondObject.Add('Country', Customer."Country/Region Code");
        Arr.Add(SecondObject);
        Object.Add('Correspondance', Arr);

        //third section
        ThirdObject.Add('GBPG', Customer."Gen. Bus. Posting Group");
        ThirdObject.Add('CPG', Customer."Customer Posting Group");
        SecondArr.Add(ThirdObject);
        Object.Add('Posing Group', SecondArr);

        //Download the json file
        TempBlob.CreateInStream(InStream);
        TempBlob.CreateOutStream(OutStream);
        Object.WriteTo(OutStream); //Write from Json object to outstream variable
        OutStream.WriteText(Result); //Write from outstream object to text varaible
        InStream.ReadText(Result); //Read from instream variable to text varaible
        DownloadFromStream(InStream, 'Download Json Data', 'C:\Temp\', '', FileName); //Sends instream to file and downloads it from server to client
    end;

    procedure HttpTest()
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        NegHttpResponseMessageMsg: Label 'HttpResponseMessage was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        PosHttpResponseMessageMsg: Label 'HttpResponseMessage was positive %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        Result: Text;
    begin
        //Method 1
        HttpClient.Get('https://api.restful-api.dev/objects', HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode then begin
            Message(PosHttpResponseMessageMsg, HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
            HttpContent := HttpResponseMessage.Content;
            HttpContent.ReadAs(Result);
        end else
            Message(NegHttpResponseMessageMsg, HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);

        //Method 2
        /*
        Request.SetRequestUri('https://needlecraftworld.co.uk');
        Request.Method('Get');
        Client.Send(Request, HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode then begin
            Content := HttpResponseMessage.Content;
            Content.ReadAs(Output);
            Message(Output);
        end else
            Message(NegHttpResponseMessageMsg, HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
        */
    end;

    procedure JsonRead()
    var
        KNHDemoAsset: Record KNHDemoAsset;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        ArrayCounter: Integer;
        InputArray: JsonArray;
        InputObject: JsonObject;
        InputToken: JsonToken;
        NegHttpResponseMessageMsg: Label 'HttpResponseMessage was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        Input: Text;
        Result: Text;
    begin
        HttpClient.Get('https://api.restful-api.dev/objects', HttpResponseMessage);
        if HttpResponseMessage.IsSuccessStatusCode then begin //Check for HttpResponseMessage
            HttpContent := HttpResponseMessage.Content; //Get content from HttpResponseMessage
            HttpContent.ReadAs(Result); //Place content in text variable
            InputArray.ReadFrom(Result); //Place text variable content in json array variable to read values from it.
            ArrayCounter := InputArray.Count(); //Count number of items in json array.
            foreach InputToken in InputArray do begin
                if InputToken.IsObject then
                    InputObject := InputToken.AsObject(); //Place json token in json object variable to read values from it.
                InputObject.Get('id', InputToken); //Get id from json object and place in json token
                KNHDemoAsset.Id := CopyStr(InputToken.AsValue().AsCode(), 1, 20); //Place json token value in id field of demo table.

                if InputObject.Get('name', InputToken) then
                    KNHDemoAsset.Name := CopyStr(InputToken.AsValue().AsText(), 1, 50);

                InputObject.Get('data', InputToken); //Get data from json object and place in json token. This is a nested json object that requires the next steps to read values from it.
                if InputToken.IsObject then begin //Check if data token is a json object
                    InputToken.WriteTo(Input); //Write from json token to text variable. This is needed to read the nested json object in the next step.
                    InputObject.ReadFrom(Input); //Place nested json in json object variable to read values from it.

                    if InputObject.Get('year', InputToken) then //Get year from json object and place in json token
                        KNHDemoAsset.Year := InputToken.AsValue().AsInteger(); //Place in demo table

                    if InputObject.Get('price', InputToken) then
                        KNHDemoAsset.Price := InputToken.AsValue().AsDecimal();

                    if InputObject.Get('CPU model', InputToken) then
                        KNHDemoAsset."CPU Model" := CopyStr(InputToken.AsValue().AsText(), 1, 30);

                    if InputObject.Get('Hard disk size', InputToken) then
                        KNHDemoAsset."Hard Disk Size" := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('color', InputToken) then
                        KNHDemoAsset.Colour := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('Strap Color', InputToken) then
                        KNHDemoAsset.Colour := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('Capacity', InputToken) then
                        KNHDemoAsset.Capacity := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('Capacity GB', InputToken) then
                        KNHDemoAsset.Capacity := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('generation', InputToken) then
                        KNHDemoAsset.Generation := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('Generation', InputToken) then
                        KNHDemoAsset.Generation := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('Case Size', InputToken) then
                        KNHDemoAsset."Case Size" := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    if InputObject.Get('Description', InputToken) then
                        KNHDemoAsset.Description := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    KNHDemoAsset.Insert();
                end else
                    if ArrayCounter = 0 then
                        Error('Json data is missing');
            end;
        end else
            Message(NegHttpResponseMessageMsg, HttpResponseMessage.HttpStatusCode, HttpResponseMessage.ReasonPhrase);
    end;

    //Not in use but demonstrates how to handle a json array HttpResponseMessage from an API endpoint
    procedure HandleJsonArray(JsonArray: JsonArray)
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
    begin
        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then
                JsonObject := JsonToken.AsObject();
            JsonObject.Get('name', JsonToken); //Get name from json object and place in json token
            Message('Name: %1', JsonToken.AsValue().AsText()); //Display name value from json token
        end;
    end;
}
