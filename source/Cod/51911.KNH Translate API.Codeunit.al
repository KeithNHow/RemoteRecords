/// <summary>
/// Codeunit KNH Translate API (ID 51911).
/// </summary>
codeunit 51911 "Translate API"
{
    /// <summary>
    /// CallAPI.
    /// </summary>
    /// <param name="InputVal">Text.</param>
    /// <param name="OutputVal">VAR Text.</param>
    procedure CallAPI(InputVal: Text; var OutputVal: Text[50])
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Header: HttpHeaders;
        url: Text;
        Result: Text;
        Outputurl: Text;
        JObject: JsonObject;
        SubJObject: JsonObject;
        JToken: JsonToken;
        SubJToken: JsonToken;
        SubResult: Text;
    begin
        //Create Header definition, set the url along with the parameters
        Header := Client.DefaultRequestHeaders;
        Header.Add('X-RapidAPI-Key', SalesSetup."KNH Authentication Key");
        Header.Add('X-RapidAPI-Host', SalesSetup."KNH Host Key");
        url := 'https://nlp-translation.p.rapidapi.com/v1/translate/?text=';
        Request.SetRequestUri(url + InputVal + '&' + 'to=es');
        Outputurl := Request.GetRequestUri();
        Request.Method('Get');
        Client.Send(Request, Response);
        //Play with the output
        if Response.IsSuccessStatusCode then begin
            Response.Content.ReadAs(Result);
            JObject.ReadFrom(Result);
            JObject.Get('Translated_Text', JToken);
            JToken.WriteTo(SubResult);
            SubJObject.Get('es', SubJToken);
            OutputVal := CopyStr(SubJToken.AsValue().AsText(), 1, 50);
        end else
            Message('Failed %1, %2', Response.HttpStatusCode, Response.ReasonPhrase);
    end;

}
