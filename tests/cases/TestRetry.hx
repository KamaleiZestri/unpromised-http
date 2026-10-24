package cases;

import http.HttpClient;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestRetry extends TestBase {
    private static var BASE_URL:String = "https://httpbin.org";

    function setupClass() {
        BASE_URL = host();
        haxe.Log.trace = logging.ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = logging.ExampleTracer.DefaultTrace;
    }

    function testRetry_Default(async:Async) {
        var client = new HttpClient();
        client.retryDelayMs = 0;
        switch (client.get('${BASE_URL}/status/500'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals(500, error.httpStatus);
                Assert.equals(0, error.retryCount);
                async.done();
            }
        }
    }

    function testRetry_More(async:Async) {
        var client = new HttpClient();
        client.retryDelayMs = 0;
        client.retryCount = 5;
        switch (client.get('${BASE_URL}/status/500'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals(500, error.httpStatus);
                Assert.equals(5, error.retryCount);
                async.done();
            }
        }
    }

    function testRetry_Less(async:Async) {
        var client = new HttpClient();
        client.retryDelayMs = 0;
        client.retryCount = 1;
        switch (client.get('${BASE_URL}/status/500'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals(500, error.httpStatus);
                Assert.equals(1, error.retryCount);
                async.done();
            }
        }
    }

    function testRetry_Zero(async:Async) {
        var client = new HttpClient();
        client.retryCount = 0;
        client.retryDelayMs = 0;
        switch (client.get('${BASE_URL}/status/500'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals(500, error.httpStatus);
                Assert.equals(0, error.retryCount);
                async.done();
            }
        }
    }

    function testRetry_Null(async:Async) {
        var client = new HttpClient();
        client.retryCount = null;
        client.retryDelayMs = 0;
        switch (client.get('${BASE_URL}/status/500'))
        {
            case Success(response):
            {
                Assert.fail("shouldnt get here");
                async.done();
            }
            case Fail(error):
            {
                Assert.equals(500, error.httpStatus);
                Assert.equals(0, error.retryCount);
                async.done();
            }
        }
    }
}