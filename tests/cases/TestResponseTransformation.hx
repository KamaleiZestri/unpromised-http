package cases;

import http.HttpClient;
import http.HttpError;
import http.HttpResponse;
import http.IHttpResponseTransformer;
import logging.ExampleTracer;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestResponseTransformation extends TestBase {
    private static var BASE_URL:String = "https://httpbin.org";

    function setupClass() {
        BASE_URL = host();
        haxe.Log.trace = ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = ExampleTracer.DefaultTrace;
    }

    function testBasic(async:Async) {
        var client = new HttpClient();
        client.responseTransformers = [new AddHeaders()];
        switch (client.get('${BASE_URL}/get'))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/get", json.url);
                Assert.equals("header value1", response.headers.get("Headeraddedfromtransformer1"));
                Assert.equals("header value2", response.headers.get("Headeraddedfromtransformer2"));
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

private class AddHeaders implements IHttpResponseTransformer {
    public function new() {
    }

    public function process(response:HttpResponse) {
        if (response.headers == null) {
            response.headers = [];
        }

        response.headers.set("Headeraddedfromtransformer1", "header value1");
        response.headers.set("Headeraddedfromtransformer2", "header value2");
    }
}