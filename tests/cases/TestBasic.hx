package cases;

import http.HttpClient;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestBasic extends TestBase {
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
        
        switch(client.get('${BASE_URL}/get'))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/get", json.url);
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
        switch(client.post('${BASE_URL}/post'))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/post", json.url);
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
        
        switch(client.put('${BASE_URL}/put'))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/put", json.url);
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

        switch(client.delete('${BASE_URL}/delete'))
        {
            case Success(response):
            {
                Assert.notNull(response.body);
                var json = response.bodyAsJson;
                Assert.notNull(json);
                Assert.equals(host() + "/delete", json.url);
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