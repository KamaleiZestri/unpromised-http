package cases;

import http.HttpClient;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestQueryParamsAndHeaders extends TestBase {
    private static var BASE_URL:String = "https://httpbin.org";

    function setupClass() {
        BASE_URL = host();
        haxe.Log.trace = logging.ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = logging.ExampleTracer.DefaultTrace;
    }

    function testGet(async:Async) {
        var client = new HttpClient();
        switch (client.get('${BASE_URL}/get?param1=value1&param2=value2', null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/get?param1=value1&param2=value2", json.url);
                Assert.equals("value1", json.args.param1);
                Assert.equals("value2", json.args.param2);
                Assert.equals("header value1", json.headers.Header1);
                Assert.equals("header value2", json.headers.Header2);
                async.done();
            }
            case Fail(error):
            {
                Assert.fail();
                async.done();
            }
        }
    }

    function testPost(async:Async) {
        var client = new HttpClient();
        switch (client.post('${BASE_URL}/post?param1=value1&param2=value2', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/post?param1=value1&param2=value2", json.url);
                Assert.equals("value1", json.args.param1);
                Assert.equals("value2", json.args.param2);
                Assert.equals("header value1", json.headers.Header1);
                Assert.equals("header value2", json.headers.Header2);
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
        switch (client.put('${BASE_URL}/put?param1=value1&param2=value2', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/put?param1=value1&param2=value2", json.url);
                Assert.equals("value1", json.args.param1);
                Assert.equals("value2", json.args.param2);
                Assert.equals("header value1", json.headers.Header1);
                Assert.equals("header value2", json.headers.Header2);
                async.done();
            }
            case Fail(error):
            {
                Assert.fail();
                async.done();
            }
        }
    }

    function testDelete(async:Async) {
        var client = new HttpClient();
        switch (client.delete('${BASE_URL}/delete?param1=value1&param2=value2', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/delete?param1=value1&param2=value2", json.url);
                Assert.equals("value1", json.args.param1);
                Assert.equals("value2", json.args.param2);
                Assert.equals("header value1", json.headers.Header1);
                Assert.equals("header value2", json.headers.Header2);
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
