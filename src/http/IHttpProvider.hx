package http;

interface IHttpProvider {
    public var encodeUrl:Bool;
    function makeRequest(request:HttpRequest):HttpOption;
}
