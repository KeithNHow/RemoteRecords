/// <summary>
/// Codeunit "KNH JsonWrite" (ID 50100).
/// </summary>
codeunit 51910 JsonWrite
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
        Object.WriteTo(OutStr); //Write json data of the json object to text object
        Outstr.WriteText(Result); //Write text to outstream object
        InStr.ReadText(Result); //Reads text from an instream object
        DownloadFromStream(Instr, 'Download Json Data', '', '', FileName); //Sends file from server computer to client computer.
    end;

    /// <summary>
    /// APIConnect.
    /// </summary>
    procedure APIConnect()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Request: HttpRequestMessage;
        Result: Text;
        Output: Text;
    begin
        //Method 1
        Client.Get('https://jsonplaceholder.typicode.com/posts', Response);
        if Response.IsSuccessStatusCode then
            Content := Response.Content
        else
            Message('Response was negative %1,%2', Response.HttpStatusCode, Response.ReasonPhrase);
        Content.ReadAs(Result);

        //Method 2
        Request.SetRequestUri('https://jsonplaceholder.typicode.com/users');
        Request.Method('Get');
        Client.Send(Request, Response);
        if Response.IsSuccessStatusCode then
            Content := Response.Content
        else
            Message('Response was negative %1,%2', Response.HttpStatusCode, Response.ReasonPhrase);
        Content.ReadAs(Output);
        Message(Output);
    end;

    /// <summary>
    /// JsonReadAndWrite.
    /// </summary>
    /// <param name="APITable">VAR Record "API Table".</param>
    procedure JsonReadAndWrite(var APITable: Record "API Table")
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: HttpContent;
        //Request: HttpRequestMessage;
        Result: Text;
        Output: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        SubJObject: JsonObject;
        SubJToken: JsonToken;
    begin
        /*
        //Method 1
        Client.Get('https://jsonplaceholder.typicode.com/posts', Response);
        if Response.IsSuccessStatusCode then
            Content := Response.Content
        else
            Message('Response was negative %1,%2', Response.HttpStatusCode, Response.ReasonPhrase);
        Content.ReadAs(Result);

        //Method 2
        Request.SetRequestUri('https://jsonplaceholder.typicode.com/users');
        Request.Method('Get');
        Client.Send(Request, Response);
        if Response.IsSuccessStatusCode then
            Content := Response.Content
        else
            Message('Response was negative %1,%2', Response.HttpStatusCode, Response.ReasonPhrase);
        Content.ReadAs(Output);
        Message(Output);
        */

        Client.Get('https://jsonplaceholder.typicode.com/users/' + Format(APITable.Id), Response);
        if Response.IsSuccessStatusCode then begin
            Content := Response.Content; //Store content
            Content.ReadAs(Result); //Read into text variable
            //Store the object in the json Object
            JObject.ReadFrom(Result); //Read from text variable
            JObject.Get('name', JToken); //place in token
            APITable.Name := CopyStr(JToken.AsValue().AsText(), 1, 50); //Remove from token and place in API table
            JObject.Get('username', JToken);
            APITable."User Name" := CopyStr(JToken.AsValue().AsText(), 1, 50);
            JObject.Get('email', JToken);
            APITable.Email := CopyStr(JToken.AsValue().AsText(), 1, 50);
            JObject.Get('address', JToken);
            if JToken.IsObject then begin
                JToken.WriteTo(Output);
                SubJObject.ReadFrom(Output);
                SubJObject.Get('street', SubJToken);
                APITable.Address := CopyStr(SubJToken.AsValue().AsText(), 1, 50);
                SubJObject.Get('suite', SubJToken);
                APITable."Address 2" := CopyStr(SubJToken.AsValue().AsText(), 1, 50);
                SubJObject.Get('city', SubJToken);
                APITable.City := CopyStr(SubJToken.AsValue().AsText(), 1, 30);
            end else
                Error('Json data is missing');
        end else
            Message('Response was negative %1,%2', Response.HttpStatusCode, Response.ReasonPhrase);
    end;
}
