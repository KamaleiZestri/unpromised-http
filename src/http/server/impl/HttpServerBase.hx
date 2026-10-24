package http.server.impl;

import haxe.io.Path;
import promises.Promise;

#if (sys || hxnodejs)

class HttpServerBase {

    public var onRequest:HttpRequest->HttpResponse->Promise<HttpResponse> = null;

    private var _fileDirs:Array<FileDir> = null;

    private var options:HttpServerOptions = {};

    public function new(options:HttpServerOptions = null) {
        this.options = options;
        if (this.options == null) {
            this.options = {};
        }
    }

    public function start(port:Int) {
    }

    public function stop() {
    }

    public function serveFilesFrom(prefix:String, dir:String) {
        if (_fileDirs == null) {
            _fileDirs = [];
        }
        var dir = Path.normalize(Sys.getCwd() + "/" + dir);
        #if includeHttpTraces
        trace('serving static resources from "${dir}"', LogLevel.Info);
        #end
        _fileDirs.push({
            prefix: prefix,
            dir: dir
        });
    }
}

typedef FileDir = {
    var prefix:String;
    var dir:String;
}

#else

class HttpServerBase {
    public var onRequest:HttpRequest->HttpResponse->Promise<HttpResponse> = null;
    
    private var options:HttpServerOptions = {};

    public function new(options:HttpServerOptions = null) {
        this.options = options;
        if (this.options == null) {
            this.options = {};
        }
    }

    public function start(port:Int) {
    }

    public function stop() {
    }
}

#end