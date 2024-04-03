/// <summary>
/// Codeunit "KNH_JsonWrite" (ID 50100).
/// </summary>
codeunit 51910 KNHJsonWrite
{
    trigger OnRun()
    var
        Cust: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        Object: JsonObject;
        SecondObject: JsonObject;
        ThirdObject: JsonObject;
        Arr: JsonArray;
        SecondArr: JsonArray;
        InStr: Instream;
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
        arr.Add(SecondObject);
        Object.Add('Correspondance', Arr);

        //third section
        ThirdObject.Add('GBPG', Cust."Gen. Bus. Posting Group");
        ThirdObject.Add('CPG', Cust."Customer Posting Group");
        SecondArr.Add(ThirdObject);
        Object.Add('Posing Group', SecondArr);

        //Download the json file
        TempBlob.CreateInStream(Instr);
        TempBlob.CreateOutStream(OutStr);
        Object.WriteTo(OutStr); //Write from Json object to outstream variable
        Outstr.WriteText(Result); //Write from outstream object to text varaible
        InStr.ReadText(Result); //Read from instream variable to text varaible
        DownloadFromStream(Instr, 'Download Json Data', 'C:\Temp\', '', FileName); //Sends instream to file and downloads it from server to client
    end;

    /// <summary>
    /// HttpTest
    /// </summary>
    procedure HttpTest()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Request: HttpRequestMessage;
        Result: Text;
        Output: Text;
        NegResponseMsg: Label 'Response was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
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
        Request.SetRequestUri('https://needlecraftworld.co.uk');
        Request.Method('Get');
        Client.Send(Request, Response);
        if Response.IsSuccessStatusCode then begin
            Content := Response.Content;
            Content.ReadAs(Output);
            Message(Output);
        end else
            Message(NegResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);
    end;

    /// <summary>
    /// JsonReadAndWrite.
    /// </summary>
    /// <param name="KNHAPITable">VAR Record "KNH_API_Table".</param>
    procedure JsonRead(var KNHAPITable: Record "KNHAPI_Table")
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Result: Text;
        Output: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        SubJObject: JsonObject;
        SubJToken: JsonToken;
        NegResponseMsg: Label 'Response was negative %1,%2', Comment = '%1 = HttpStatusCode, %2 = Reason';
    begin
        Client.Get('https://needlecraftworld.co.uk' + Format(KNHAPITable.Id), Response);
        if Response.IsSuccessStatusCode then begin

            Content := Response.Content; //Store content
            Content.ReadAs(Result); //Place content in Result text variable
            JObject.ReadFrom(Result); //Place result in Json object

            JObject.Get('name', JToken); //place name in token
            KNHAPITable.Name := CopyStr(JToken.AsValue().AsText(), 1, 50); //Place in API table

            JObject.Get('username', JToken); //place username in token
            KNHAPITable."User Name" := CopyStr(JToken.AsValue().AsText(), 1, 50); //Place in API table

            JObject.Get('email', JToken); //Place in email in token
            KNHAPITable.Email := CopyStr(JToken.AsValue().AsText(), 1, 50); //Place in API table

            JObject.Get('address', JToken); //Place address in token
            if JToken.IsObject then begin
                JToken.WriteTo(Output); //Write from Json token to text variable
                SubJObject.ReadFrom(Output); //Read from text variable to Json object

                SubJObject.Get('street', SubJToken); //Place street in token 
                KNHAPITable.Address := CopyStr(SubJToken.AsValue().AsText(), 1, 50); //Place in API table

                SubJObject.Get('suite', SubJToken); //Place suite in token
                KNHAPITable."Address 2" := CopyStr(SubJToken.AsValue().AsText(), 1, 50); //Place in API table

                SubJObject.Get('city', SubJToken); //Place city in token
                KNHAPITable.City := CopyStr(SubJToken.AsValue().AsText(), 1, 30); //Place in API table
            end else
                Error('Json data is missing');
        end else
            Message(NegResponseMsg, Response.HttpStatusCode, Response.ReasonPhrase);
    end;
}
