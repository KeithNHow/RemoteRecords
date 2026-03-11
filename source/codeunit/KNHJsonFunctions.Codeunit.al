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
        //Output: Text;
        Result: Text;
    begin
        //Method 1
        Client.Get('https://needlecraftworld.co.uk', Response);
        if Response.IsSuccessStatusCode then begin
            Content := Response.Content;
            Content.ReadAs(Result);
            Message(Result);
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

    procedure JsonRead(var KNHDemo: Record KNHDemo)
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        JObject: JsonObject;
        InputObject: JsonObject;
        JToken: JsonToken;
        InputToken: JsonToken;
        NegResponseMsg: Label 'Response was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
        Input: Text;
        Result: Text;
    begin
        Client.Get('https://needlecraftworld.co.uk' + Format(KNHDemo.Id), Response);
        if Response.IsSuccessStatusCode then begin //Check for response

            Content := Response.Content; //Store content
            Content.ReadAs(Result); //Place content in text variable
            JObject.ReadFrom(Result); //Place result in Json object

            JObject.Get('name', JToken); //Place name in json token
            KNHDemo.Name := CopyStr(JToken.AsValue().AsText(), 1, 50); //Place json token value in email

            JObject.Get('username', JToken); //place username in json token
            KNHDemo."User Name" := CopyStr(JToken.AsValue().AsText(), 1, 50); //Place json token value in email

            JObject.Get('email', JToken); //Place email address in json token
            KNHDemo.Email := CopyStr(JToken.AsValue().AsText(), 1, 50); //Place json token value in email

            JObject.Get('addressdetails', JToken); //Get address details from json object and place address in json token
            if JToken.IsObject then begin
                JToken.WriteTo(Input); //Write from Json token to text variable
                InputObject.ReadFrom(Input); //Read from text variable to Json object

                InputObject.Get('address', InputToken); //Get street from json object and place in json token 
                KNHDemo.Address := CopyStr(InputToken.AsValue().AsText(), 1, 50); //Place in demo table

                InputObject.Get('address2', InputToken); //Get address2 from json object and place in json token
                KNHDemo."Address 2" := CopyStr(InputToken.AsValue().AsText(), 1, 50); //Place in demo table

                InputObject.Get('city', InputToken); //Get city from json object and place in json token
                KNHDemo.City := CopyStr(InputToken.AsValue().AsText(), 1, 30); //Place in demo table

                InputObject.Get('postcode', InputToken); //Get postcode from json object and place in json token
                KNHDemo."Post Code" := CopyStr(InputToken.AsValue().AsText(), 1, 20); //Place in demo table
            end else
                Error('Json data is missing');
        end else
            Message(NegResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);
    end;
}
