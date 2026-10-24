package http.providers;

import haxe.Http;
import haxe.Json;
import haxe.io.Bytes;
import http.HttpOption;
import logging.LogLevel;



class DefaultHttpProvider implements IHttpProvider {
    public var encodeUrl:Bool = true;

    public function new() {
    }

    public function makeRequest(request:HttpRequest):HttpOption 
    {
            var url = request.url.build(false);
            var http = new Http(url);
        var httpResult:HttpOption;
            var response = new HttpResponse();
            response.originalRequest = request;

            // add any params from the url query
            var allParameters:Map<String, Any> = [];
            for (queryParamKey in request.url.queryParams.keys()) {
                allParameters.set(queryParamKey, request.url.queryParams.get(queryParamKey));
            }
            // lets also add (and overwrite) any params that come from the actual request
            for (queryParamKey in request.queryParams.keys()) {
                allParameters.set(queryParamKey, request.queryParams.get(queryParamKey));
            }
            // finally lets add them to the actual request
            for (queryParamKey in allParameters.keys()) {
                http.addParameter(queryParamKey, allParameters.get(queryParamKey));
            }

            // add headers
            if (request.headers != null) {
                for (headerKey in request.headers.keys()) {
                    http.addHeader(headerKey, request.headers.get(headerKey));
                }
            }

        #if includeHttpTraces
                var method:String = request.method;
        trace('making "${method.toLowerCase()}" request to "${url}"', LogLevel.Debug);
        trace('    headers:', LogLevel.Debug, request.headers);
        trace('    query params:', LogLevel.Debug,  allParameters);
                if (request.body != null) {
            trace('    body:', LogLevel.Debug, request.body);
                }
        #end

            #if sys
            var output = new haxe.io.BytesOutput();
            #end
            http.onBytes = (bytes:Bytes) -> {
                response.headers = http.responseHeaders;
                response.body = bytes;
            httpResult =  Success(response);
            }
            /*
            http.onData = (data:String) -> {
                trace("onData", data.length);
            }
            */
            http.onStatus = (status:Int) -> {
                response.httpStatus = status;
            }
            http.onError = (msg:String) -> {
                var httpError = new HttpError(msg, response.httpStatus);
                if (http.responseBytes != null) {
                    httpError.body = http.responseBytes;
                }
                if (http.responseHeaders != null) {
                    httpError.headers = http.responseHeaders;
                }
            httpResult =  Fail(httpError);
            }

            var body:Any = request.body;
            if (body != null) {
                if (request.headers != null) {
                    var contentType = request.headers.get(StandardHeaders.ContentType);
                    if (contentType == ContentTypes.ApplicationJson) {
                        if (!(body is String)) {
                            body = Json.stringify(body);
                        }
                    }
                }

                if ((body is String)) {
                    http.setPostData(body);
                } else if ((body is Bytes)) {
                    http.setPostBytes(body);
                } else {
                    http.setPostData(Std.string(body));
                }
            }

            switch (request.method) {
                case Get:
                    http.request();
                case Post:
                    http.request(true);
                case Put:
                    #if sys

                    http.customRequest(true, output, null, "PUT");

                    #else

                    http.customRequest(true, "PUT");
                    http.request(true);

                    #end
                case Delete:
                    #if sys

                    http.customRequest(true, output, null, "DELETE");

                    #else

                    http.customRequest(true, "DELETE");
                    http.request(true);

                    #end
                case Patch:
                    #if sys

                    http.customRequest(true, output, null, "PATCH");

                    #else

                    http.customRequest(true, "PATCH");
                    http.request(true);

                    #end
                case _:
                    throw new HttpError("http method not implemented (" + request.method + ")");
            }
        return httpResult;
    }
}
