package cases;

import http.HttpClient;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestHeaders extends TestBase {
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
        switch(client.get('${BASE_URL}/get', null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/get", json.url);
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
        switch (client.post('${BASE_URL}/post', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/post", json.url);
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
        switch (client.put('${BASE_URL}/put', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/put", json.url);
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

    function testPatch(async:Async) {
        var client = new HttpClient();
        switch (client.put('${BASE_URL}/patch', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/patch", json.url);
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
        switch (client.delete('${BASE_URL}/delete', null, null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/delete", json.url);
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

    function testGet_DefaultHeaders(async:Async) {
        var client = new HttpClient();
        client.defaultRequestHeaders = [
            "Header1" => "default header value1",
            "Header2" => "default header value2",
            "Header3" => "default header value3"
        ];
        switch (client.get('${BASE_URL}/get', null, ["Header1" => "header value1", "Header2" => "header value2"]))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/get", json.url);
                Assert.equals("header value1", json.headers.Header1);
                Assert.equals("header value2", json.headers.Header2);
                Assert.equals("default header value3", json.headers.Header3);
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
 