package http;

import http.HttpError;
import http.HttpResponse;

/**
    A wrapper type which can have either a successful HTTP Request (HttpRequest)
    or a failure (HttpError).
**/
enum HttpOption
{
    Success(response:HttpResponse);
    Fail(error:HttpError);
}