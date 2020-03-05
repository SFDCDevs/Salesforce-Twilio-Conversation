public class Callout_Utility {
    public static HTTPResponse doCallout(string EndPoint, string Method, map<string,string> Headers, string Body, integer TimeOut){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(EndPoint);
        req.setMethod(Method);
        if(Body != '')
            req.setbody(body);
        req.setTimeout(TimeOut);
        for(String HeaderKey : Headers.keySet())
            req.setHeader(HeaderKey, Headers.get(Headerkey));
        Http http = new Http();
        HTTPResponse response = http.send(req);
        return response;
    }
}