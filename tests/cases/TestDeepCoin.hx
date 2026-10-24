package cases;

import http.HttpClient;
import http.HttpMethod;
import http.HttpRequest;
import utest.Assert;
import utest.Async;

@:timeout(20000)
class TestDeepCoin extends TestBase {
    function setupClass() {
        haxe.Log.trace = logging.ExampleTracer.JsonTrace;
    }

    function teardownClass() {
        haxe.Log.trace = logging.ExampleTracer.DefaultTrace;
    }

    function testBasicNoHeaders(async:Async) {
        var http = new HttpClient();
        var url = new HttpRequest('https://api.deepcoin.com/deepcoin/market/instruments?instType=SPOT');
        url.method = HttpMethod.Get;
        switch (http.makeRequest(url))
        {
            case Success(response):
            {
                Assert.notNull(response.bodyAsJson);
                async.done();
            }
            case Fail(err):
            {
                Assert.fail(err.message);
                trace(err.message);
                async.done();
            }
        }
    }

    function testBasicWithHeaders(async:Async) {
        var http = new HttpClient();
        var url = new HttpRequest('https://api.deepcoin.com/deepcoin/market/instruments?instType=SPOT');
        url.method = HttpMethod.Get;
        url.headers = ['Host' => 'api.deepcoin.com', 'User-Agent' => 'CustomApp'];
        switch (http.makeRequest(url))
        {
            case Success(response):
            {
                Assert.notNull(response.bodyAsJson);
                async.done();
            }
            case Fail(err):
            {
                Assert.fail(err.message);
                trace(err.message);
                async.done();
            }
        }
    }
}