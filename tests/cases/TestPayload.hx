package cases;

import haxe.Json;
import http.ContentTypes;
import http.HttpClient;
import http.StandardHeaders;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestPayload extends TestBase {
    private static var BASE_URL:String = "https://httpbin.org";

    function setupClass() {
        BASE_URL = host();
        haxe.Log.trace = logging.ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = logging.ExampleTracer.DefaultTrace;
    }

    function testPost(async:Async) {
        var client = new HttpClient();
        client.defaultRequestHeaders = [StandardHeaders.ContentType => ContentTypes.ApplicationJson];
        switch (client.post('${BASE_URL}/post', {foo: "foo string", bar: 111}))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/post", json.url);
                var data = json.data;
                Assert.notNull(data);
                var jsonData = Json.parse(data);
                Assert.equals("foo string", jsonData.foo);
                Assert.equals(111, jsonData.bar);
                async.done();
            }
            case Fail(error):
            {
                Assert.fail();
                async.done();
            }
        }
    }

    function testPut(async:Async) {
        var client = new HttpClient();
        client.defaultRequestHeaders = [StandardHeaders.ContentType => ContentTypes.ApplicationJson];
        switch (client.put('${BASE_URL}/put', {foo: "foo string", bar: 111}))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/put", json.url);
                var data = json.data;
                Assert.notNull(data);
                var jsonData = Json.parse(data);
                Assert.equals("foo string", jsonData.foo);
                Assert.equals(111, jsonData.bar);
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