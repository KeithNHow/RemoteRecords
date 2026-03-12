/// <summary>
/// This codeunit demonstrates how to write Json data and make Http requests. It includes a method that reads Json data and places it in a table. 
/// The OnRun trigger creates a Json file based on the first record of the Customer table. 
/// The HttpTest method makes a get request to an API endpoint and returns the response. 
/// The JsonRead method makes a get request to an API endpoint, reads the Json response, and places the data in the KNHDemo table.
/// </summary>
codeunit 51910 KNHJsonFunctions
{
    procedure JsonExport()
    var
        Cust: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        Arr: JsonArray;
        SecondArr: JsonArray;
        Object: JsonObject;
        SecondObject: JsonObject;
        ThirdObject: JsonObject;
        OutStr: OutStream;
        FileName: Text;
        Result: Text;
    begin
        FileName := 'Customer.Json'; //name file
        Cust.Get('10000'); //get cust rec
        //first section
        Object.Add('No.', Cust."No.");
        Object.Add('Name', Cust.Name);

        //second section
        SecondObject.Add('Address', Cust.Address);
        SecondObject.Add('City', Cust.City);
        SecondObject.Add('Country', Cust."Country/Region Code");
        Arr.Add(SecondObject);
        Object.Add('Correspondance', Arr);

        //third section
        ThirdObject.Add('GBPG', Cust."Gen. Bus. Posting Group");
        ThirdObject.Add('CPG', Cust."Customer Posting Group");
        SecondArr.Add(ThirdObject);
        Object.Add('Posing Group', SecondArr);

        //Download the json file
        TempBlob.CreateInStream(InStr);
        TempBlob.CreateOutStream(OutStr);
        Object.WriteTo(OutStr); //Write from Json object to outstream variable
        OutStr.WriteText(Result); //Write from outstream object to text varaible
        InStr.ReadText(Result); //Read from instream variable to text varaible
        DownloadFromStream(InStr, 'Download Json Data', 'C:\Temp\', '', FileName); //Sends instream to file and downloads it from server to client
    end;

    procedure HttpTest()
    var
        Client: HttpClient;
        Content: HttpContent;
        //Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        NegResponseMsg: Label 'Response was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        PosResponseMsg: Label 'Response was positive %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        //Output: Text;
        Result: Text;
    begin
        //Method 1
        Client.Get('https://api.restful-api.dev/objects', Response);
        if Response.IsSuccessStatusCode then begin
            Message(PosResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);
            Content := Response.Content;
            Content.ReadAs(Result);
            //Message(Result);
        end else
            Message(NegResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);

        //Method 2
        /*
        Request.SetRequestUri('https://needlecraftworld.co.uk');
        Request.Method('Get');
        Client.Send(Request, Response);
        if Response.IsSuccessStatusCode then begin
            Content := Response.Content;
            Content.ReadAs(Output);
            Message(Output);
        end else
            Message(NegResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);
        */
    end;

    procedure JsonRead()
    var
        KNHDemo: Record KNHDemoAsset;
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        InputArray: JsonArray;
        InputObject: JsonObject;
        InputToken: JsonToken;
        NegResponseMsg: Label 'Response was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        Input: Text;
        Result: Text;
    begin
        Client.Get('https://api.restful-api.dev/objects', Response);
        if Response.IsSuccessStatusCode then begin //Check for response
            Content := Response.Content; //Get content from response
            Content.ReadAs(Result); //Place content in text variable
            InputArray.ReadFrom(Result);
            //JObject.ReadFrom(Result); //Place result in Json object
            foreach InputToken in InputArray do begin
                InputObject.Get('id', InputToken); //Get id from json object and place in json token.
                KNHDemo.Id := CopyStr(InputToken.AsValue().AsCode(), 1, 20); //Place json token value in id field of demo table.

                InputObject.Get('name', InputToken);
                KNHDemo.Name := CopyStr(InputToken.AsValue().AsText(), 1, 50);

                InputObject.Get('data', InputToken);
                if InputToken.IsObject then begin //Check if data token is a json object
                    InputToken.WriteTo(Input); //Write from json token to text variable. This is needed to read the nested json object in the next step.
                    InputObject.ReadFrom(Input); //Place nested json in json object variable to read values from it.

                    InputObject.Get('year', InputToken); //Get year from json object and place in json token
                    KNHDemo.Year := InputToken.AsValue().AsInteger(); //Place in demo table

                    InputObject.Get('price', InputToken);
                    KNHDemo.Price := InputToken.AsValue().AsDecimal();

                    InputObject.Get('CPU model', InputToken);
                    KNHDemo."CPU Model" := CopyStr(InputToken.AsValue().AsText(), 1, 30);

                    InputObject.Get('Hard disk size', InputToken);
                    KNHDemo."Hard Disk Size" := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('color', InputToken);
                    KNHDemo.Colour := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('Strap Color', InputToken);
                    KNHDemo.Colour := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('Capacity', InputToken);
                    KNHDemo.Capacity := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('Capacity GB', InputToken);
                    KNHDemo.Capacity := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('generation', InputToken);
                    KNHDemo.Generation := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('Generation', InputToken);
                    KNHDemo.Generation := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('Case Size', InputToken);
                    KNHDemo."Case Size" := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    InputObject.Get('Description', InputToken);
                    KNHDemo.Description := CopyStr(InputToken.AsValue().AsText(), 1, 20);

                    KNHDemo.Insert();
                end else
                    Error('Json data is missing');
            end;
        end else
            Message(NegResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);
    end;

    //Not in use but demonstrates how to handle a json array response from an API endpoint
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
