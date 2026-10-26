package http;

import http.HttpMethod;
import http.HttpOption;
import http.HttpRequest;
import http.providers.DefaultHttpProvider;
import logging.LogLevel;

class HttpClient {
    /**
     * Whether to follow http redirects automatically or not
     */
    public var followRedirects:Bool = true;
    /**
     * If a http request fails, try to restablish a connection attempt `x` times
     */
    public var retryCount:Null<Int> = 0;
    /**
     * Add a delay to the retry attempt
     */
    public var retryDelayMs:Int = 1000;
    /**
     * A set of default headers that will be added to all outgoing http requests
     * See the enum `StandardHeaders` for a list of http headers 
     */
    public var defaultRequestHeaders:Map<String, Any>;
    public var requestTransformers:Array<IHttpRequestTransformer>;
    public var responseTransformers:Array<IHttpResponseTransformer>;

    /*
     * Callback that will enable modification of the http request that will be 
     * requeued
     */
    public var onBeforeRedirect:HttpRequest->Void = null;

    public function new() {
    }


    @:isVar public var encodeUrl(default, set):Bool = true;
    function set_encodeUrl(value) {
        if (_provider != null) {
            _provider.encodeUrl = value;
        }
        return encodeUrl = value;
    }
    
    private var _provider:IHttpProvider = null;
    public var provider(get, set):IHttpProvider;
    private function get_provider():IHttpProvider {
        if (_provider == null) {
            _provider = new DefaultHttpProvider();
		    _provider.encodeUrl = encodeUrl;
        }
        return _provider;
    }
    private function set_provider(value:IHttpProvider):IHttpProvider {
        _provider = value;
        return value;
    }
	/**
	 * Add a header to the default header map
	 * @param header - name of the header
	 * @param value - value of the header
	 */
	public inline function setDefaultRequestHeader(header:String, value:Any) {
		if (this.defaultRequestHeaders == null) {
			this.defaultRequestHeaders = [];
		}
		this.defaultRequestHeaders[header] = value;
	}

	/**
	 * Remove a header from the default header map
	 * @param header - name of the header
	 * @param value - value of the header
	 */
	public inline function removeDefaultRequestHeader(header:String, value:Any) {
		return this.defaultRequestHeaders != null && this.defaultRequestHeaders.remove(header);
	}
    /**
     * Performs a get request 
     * @param request - The url that is being requested
     * @param queryParams - Add any query parameters
     * @param headers - Add any additional headers that should go along with the request, these will be in addition to the headers set on `defaultHeaders`. \nNote headers specified here will take precedent over ones specified as default
     * @return HttpOption
     */
    public inline function get(request:HttpRequest, queryParams:Map<String, Any> = null, headers:Map<String, Any> = null):HttpOption {
        request.method = HttpMethod.Get;
        return makeRequest(request, null, queryParams, headers);
    }
    /**
     * Performs a post request 
     * @param request - The url that is being requested
     * @param queryParams - Add any query parameters
     * @param headers - Add any additional headers that should go along with the request, these will be in addition to the headers set on `defaultHeaders`. \nNote headers specified here will take precedent over ones specified as default
     * @return HttpOption
     */
    public inline function post(request:HttpRequest, body:Any = null, queryParams:Map<String, Any> = null, headers:Map<String, Any> = null):HttpOption {
        request.method = HttpMethod.Post;
        return makeRequest(request, body, queryParams, headers);
    }
    /**
     * Performs a patch request 
     * @param request - The url that is being requested
     * @param queryParams - Add any query parameters
     * @param headers - Add any additional headers that should go along with the request, these will be in addition to the headers set on `defaultHeaders`. \nNote headers specified here will take precedent over ones specified as default
     * @return HttpOption
     */
    public inline function patch(request:HttpRequest, body:Any = null, queryParams:Map<String, Any> = null, headers:Map<String, Any> = null):HttpOption {
        request.method = HttpMethod.Patch;
        return makeRequest(request, body, queryParams, headers);
    }
    /**
     * Performs a put request
     * @param request - The url that is being requested
     * @param body - Add a data object
     * @param queryParams - Add any query parameters
     * @param headers - Add any additional headers that should go along with the request, these will be in addition to the headers set on `defaultHeaders`. \nNote headers specified here will take precedent over ones specified as default
     * @return HttpOption
     */
    public inline function put(request:HttpRequest, body:Any = null, queryParams:Map<String, Any> = null, headers:Map<String, Any> = null):HttpOption {
        request.method = HttpMethod.Put;
        return makeRequest(request, body, queryParams, headers);
    }
    /**
     * Performs a delete request
     * @param request - The url that is being requested
     * @param body - Add a data object 
     * @param queryParams - Add any query parameters
     * @param headers - Add any additional headers that should go along with the request, these will be in addition to the headers set on `defaultHeaders`. \nNote headers specified here will take precedent over ones specified as default
     * @return HttpOption
     */
    public inline function delete(request:HttpRequest, body:Any = null, queryParams:Map<String, Any> = null, headers:Map<String, Any> = null):HttpOption {
        request.method = HttpMethod.Delete;
        return makeRequest(request, body, queryParams, headers);
    }

    /**
     * Trigger a http request 
     * @param request - The url that is being requested
     * @param body - Add a data object 
     * @param queryParams - Add any query parameters
     * @param headers - Add any additional headers that should go along with the request, these will be in addition to the headers set on `defaultHeaders`. \nNote headers specified here will take precedent over ones specified as default
     * @return HttpOption
     */
    public function makeRequest(request:HttpRequest, body:Any = null, queryParams:Map<String, Any> = null, headers:Map<String, Any> = null):HttpOption {
        var copy = request.clone();

        // query params
        var finalQueryParams:Map<String, Any> = null;
        if (copy.queryParams != null) {
            if (finalQueryParams == null) {
                finalQueryParams = [];
            }
            for (key in copy.queryParams.keys()) {
                finalQueryParams.set(key, copy.queryParams.get(key));
            }
        }
        if (queryParams != null) {
            if (finalQueryParams == null) {
                finalQueryParams = [];
            }
            for (key in queryParams.keys()) {
                finalQueryParams.set(key, queryParams.get(key));
            }
        }
        copy.queryParams = finalQueryParams;

        // headers
        var finalRequestHeaders:Map<String, Any> = defaultRequestHeaders;
        if (copy.headers != null) {
            if (finalRequestHeaders == null) {
                finalRequestHeaders = [];
            }
            for (key in copy.headers.keys()) {
                finalRequestHeaders.set(key, copy.headers.get(key));
            }
        }
        if (headers != null) {
            if (finalRequestHeaders == null) {
                finalRequestHeaders = [];
            }
            for (key in headers.keys()) {
                finalRequestHeaders.set(key, headers.get(key));
            }
        }
        copy.headers = finalRequestHeaders;

        // body
        if (body != null) {
            copy.body = body;
        }

        return processRequest(copy, 0);
    }

    private function processRequest(request:HttpRequest, currentRetryCount:Int):HttpOption
    {
        if (requestTransformers != null) {
            for (transformer in requestTransformers) {
                transformer.process(request);
            }
        }

        #if includeHttpTraces
        var method:String = request.method;
        trace('making "${method.toLowerCase()}" request to "${request.url.build()}"', LogLevel.Info);
        #end

        var resOpt = provider.makeRequest(request);

        #if includeHttpTraces
        switch (resOpt)
        {
            case Success(response):
            {
                trace('response received (${response.httpStatus})', LogLevel.Info);
                trace('response received: ', LogLevel.Debug);
                trace('    headers:', LogLevel.Debug, response.headers);
                trace('    body:', LogLevel.Debug, response.bodyAsString);
            }
            case Fail(error): trace('null response received', LogLevel.Warning);
        }
        #end

        switch (resOpt)
        {
            case Fail(error):
            {
                if (retryCount == null) {
                    #if includeHttpTraces
                    trace('request failed (${error.httpStatus})', LogLevel.Error);
                    #end
                    error.retryCount = 0;
                    return Fail(error);
                } else {
                    currentRetryCount++;
                    if (currentRetryCount > retryCount) {
                        if (retryCount > 0) {
                            trace('request failed (${error.httpStatus}), retries exhausted', LogLevel.Error);
                            error.retryCount = currentRetryCount - 1;
                        } else {
                            trace('request failed (${error.httpStatus})', LogLevel.Error);
                            error.retryCount = 0;
                        }
                        return Fail(error);
                    } else {
                        trace('request failed (${error.httpStatus}), retrying (${currentRetryCount} of ${retryCount})', LogLevel.Error);
                        return processRequest(request, currentRetryCount);
                    }
                }

            }
            case Success(response):
            {
                if (responseTransformers != null) {
                    for (transformer in responseTransformers) {
                        transformer.process(response);
                    }
                }

                // handle redirections by requeing the request with the new url
                if (followRedirects && (response.httpStatus == 301 || response.httpStatus == 302)) {
                    var redirectLocation:String = null;
                    if (response.headers != null) {
                        redirectLocation = response.headers.get("location");
                        if (redirectLocation == null) {
                            redirectLocation = response.headers.get("Location");
                        }
                    }

                    var url:Url = Url.fromString(redirectLocation);
                    /* possibly ill conceived - should redirect location be taken "as is" and lose any params / headers on original request?
                    var redirectQueryParams:Map<String, Any> = [];
                    if (url.queryParams != null) {
                        redirectQueryParams = url.queryParams.copy();
                    }
                    redirectQueryParams.remove("location");
                    redirectQueryParams.remove("Location");
                    */

                    // we'll consider it an error if there is no location header
                    if (redirectLocation == null) {
                        #if includeHttpTraces
                        trace('redirect encountered (${response.httpStatus}), no location header found', LogLevel.Error);
                        #end
                        var httpError = new HttpError("no location header found", response.httpStatus);
                        httpError.body = response.body;
                        httpError.headers = response.headers;
                        return Fail(httpError);
                    }

                    /* possibly ill conceived - should redirect location be taken "as is" and lose any params / headers on original request?
                    var queryParams = item.request.url.queryParams; // cache original queryParams from url
                    for (k in redirectQueryParams.keys()) {
                        if (queryParams == null) {
                            queryParams = [];
                        }                    
                        queryParams.set(k, redirectQueryParams.get(k));
                    }
                    item.request.url.queryParams = queryParams;
                    */
                    request.url = redirectLocation;
                    retryCount = 0;
                    if (onBeforeRedirect != null) {
                        onBeforeRedirect(request);
                    }
                    return processRequest(request, currentRetryCount);
                }

                return Success(response);
            }
        }
    }
}

typedef RequestQueueItem = {
    var retryCount:Int;
    var request:HttpRequest;
    var resolve:HttpResponse->Void;
    var reject:Dynamic->Void;
}
