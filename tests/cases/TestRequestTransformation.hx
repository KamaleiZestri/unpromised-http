package cases;

import http.HttpClient;
import http.HttpRequest;
import http.IHttpRequestTransformer;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestRequestTransformation extends TestBase {
    private static var BASE_URL:String = "https://httpbin.org";

    function setupClass() {
        BASE_URL = host();
        haxe.Log.trace = logging.ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = logging.ExampleTracer.DefaultTrace;
    }

    function testBasic(async:Async) {
        var client = new HttpClient();
        client.requestTransformers = [new AddHeaders()];
        switch (client.get('${BASE_URL}/get'))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/get", json.url);
                Assert.equals("header value1", json.headers.Headeraddedfromtransformer1);
                Assert.equals("header value2", json.headers.Headeraddedfromtransformer2);
                async.done();
            }
            case Fail(error):
            {
                Assert.fail();
                async.done();
            }
        }
    }
}

private class AddHeaders implements IHttpRequestTransformer {
    public function new() {
    }

    public function process(request:HttpRequest) {
        if (request.headers == null) {
            request.headers = [];
        }

        request.headers.set("Headeraddedfromtransformer1", "header value1");
        request.headers.set("Headeraddedfromtransformer2", "header value2");
    }
}