<a href="https://github.com/core-haxe/http/actions/workflows/nodejs.yaml"><img src="https://github.com/core-haxe/http/actions/workflows/nodejs.yaml/badge.svg"></a>
<a href="https://github.com/core-haxe/http/actions/workflows/hl.yaml"><img src="https://github.com/core-haxe/http/actions/workflows/hl.yaml/badge.svg"></a>
<a href="https://github.com/core-haxe/http/actions/workflows/hxcpp.yaml"><img src="https://github.com/core-haxe/http/actions/workflows/hxcpp.yaml/badge.svg"></a>
<a href="https://github.com/core-haxe/http/actions/workflows/neko.yaml"><img src="https://github.com/core-haxe/http/actions/workflows/neko.yaml/badge.svg"></a>

# http
flexible http client and server supporting different http providers

# features
 - GET, POST, PUT, DELETE http verbs
 - Ability to swap out http providers (via `IHttpProvider`) - currently uses modified versions of Haxe's http
 - Ability to follow redirects
 - Ability to retry failed requests
 - Ability to transform requests / responses (using `IHttpRequestTransformer` or `IHttpResponseTransformer`);
 - Simple, but flexible, interface
 
# basic usage

### get

```haxe
var client = new HttpClient();
client.followRedirects = false; // defaults to true
client.retryCount = 5; // defaults to 0
client.retryDelayMs = 0; // defaults to 1000
client.provider = new MySuperHttpProvider(); // defaults to "DefaultHttpProvider"
client.requestQueue = QueueFactory.instance.createQueue(QueueFactory.SIMPLE_QUEUE); // defaults to "NonQueue"
client.defaultRequestHeaders = ["someheader" => "somevalue"];
client.requestTransformers = [new MyRequestTransformerA(), new MyRequestTransformerB()];
client.responseTransformers = [new MyResponseTransformerA(), new MyResponseTransformerB()];
var opt = client.get('http://someurl?param1=value1', ["param2" => "value2"], ["header1" => "header value 1"]);
switch (opt)
{
    case Success(response:HttpResponse):
        var foo = response.bodyAsJson.bar;
    case Fail(error:HttpError): //error
}

```

### post

```haxe
var client = new HttpClient();
switch (client.post('http://someurl?param1=value1', {foo: "bar"}, ["param2" => "value2"], ["header1" => "header value 1"]))
{
    case Success(response:HttpResponse):
        var foo = response.bodyAsJson.bar;
    case Fail(error:HttpError): //error
}
```
(all parameters except the url are optional)

# server (nodejs only currently)
```haxe
var httpServer = new HttpServer();
httpServer.onRequest = (httpRequest, httpResponse) -> {
    return new Promise((resolve, reject) -> {
        var userId = httpRequest.queryParams.get("userId");
        if (userId == null) { // exceptions will be sent back as 500's
            throw "no user id";
        }
        
        if (Std.parseInt(userId) == null) { // you can also customize errors by using HttpError
            var error = new HttpError(500);
            error.body = Bytes.ofString("user is not a number");
            reject(error);
            return;
        }
        
        httpResponse.write("this is the response for " + userId);
        resolve(httpResponse);
    });
}
httpServer.start(1234);
```
(see tests for more examples)

# Debugging
Use compiler flag `includeHttpTraces` to include debug traces from this library. Read test cases and logging/ExampleTracer.hx for more info.