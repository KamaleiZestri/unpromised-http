package cases;

import http.HttpClient;
import http.HttpError;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestErrors extends TestBase {
    private static var BASE_URL:String = "https://httpbin.org";

    function setupClass() {
        BASE_URL = host();
        haxe.Log.trace = logging.ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = logging.ExampleTracer.DefaultTrace;
    }

    function testGet_500(async:Async) {
        var client = new HttpClient();
        client.retryDelayMs = 0;
        client.retryCount = 0;
        switch (client.get('${BASE_URL}/status/500'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals("", error.bodyAsString);
                Assert.equals(500, error.httpStatus);
                async.done();
            }
        }
    }

    function testGet_404(async:Async) {
        var client = new HttpClient();
        client.retryDelayMs = 0;
        client.retryCount = 0;
        switch (client.get('${BASE_URL}/status/404'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals("", error.bodyAsString);
                Assert.equals(500, error.httpStatus);
                async.done();
            }
        }
    }
}