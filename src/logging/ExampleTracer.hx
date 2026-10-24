package logging;
using haxe.EnumTools;


class ExampleTracer
{
    public static function CoreHaxeTrace(message:Dynamic, ?posInfos:haxe.PosInfos)
    {
        var objectsBuf = new StringBuf();
        var levelString = "";

        if (posInfos != null)
        {
            for(item in posInfos.customParams)
            {
                if (Std.isOfType(item, Enum))
                    levelString = setLevelString(item);
                else 
                    objectsBuf.add(formatObject(item));
            }
        }

        print(levelString + message + objectsBuf.toString());

    }

    public static function JsonTrace(message:Dynamic, ?posInfos:haxe.PosInfos)
    {

    }

    public static function DefaultTrace(v:Dynamic, ?posInfos:haxe.PosInfos)
    {
        if (posInfos != null)
            print('${posInfos.className}:${posInfos.methodName}: $v');
        else
            print(v);
    }

    private static function formatObject(obj:Any):String {
        if (obj == null) {
            return "";
        }
        switch (Type.typeof(obj)) {
            case TClass(haxe.ds.StringMap):
                var o:Dynamic = {};
                var sm = cast(obj, haxe.ds.StringMap<Dynamic>);
                for (key in sm.keys()) {
                    Reflect.setField(o, key, sm.get(key));
                }
                return haxe.Json.stringify(o);
            case _:
        }
        return Std.string(obj);
    }

    private static function setLevelString(obj:Any):String
    {
        var objType = Type.getEnum(obj);
        if (objType.getName() != "LogLevel")
            return "";
        
        switch (obj:LogLevel)
        {
            case Info: return "INFO: ";
            case Debug: return "DEBUG: ";
            case Warning: return "WARNING: ";
            case Data: return "DATA: ";
            case Error: return "ERROR: ";
            case Performance: return "PERFORMANCE: ";
        }
    }

    private inline static function print(s:String)
    {
        #if js
        js.Browser.console.log(s);
        #elseif sys
        Sys.println(s);
        #else
        trace(s);
        #end
    }
}