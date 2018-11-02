package lime.net.curl;


import haxe.io.Bytes;
import lime.net.curl.CURL;

#if !macro
@:build(lime.system.CFFI.build())
#end


class CURLMulti
{
	public static function init() : CURL
    {
		#if ((cpp || neko || nodejs) && lime_curl && !macro)
		return lime_curl_multi_init ();
		#else
		return 0;
		#end
	}
	
	
    public static function add_handle(multi : CURL, easy : CURL)
    {
		#if ((cpp || neko || nodejs) && lime_curl && !macro)
        lime_curl_multi_add_handle(multi, easy);
		#end
    }

    
    public static function remove_handle(multi : CURL, easy : CURL)
    {
		#if ((cpp || neko || nodejs) && lime_curl && !macro)
        lime_curl_multi_remove_handle(multi, easy);
		#end
    }
	
	
	public static function perform (multi : CURL, ready : Array<Float>)
    {
		#if ((cpp || neko || nodejs) && lime_curl && !macro)
        lime_curl_multi_perform(multi, ready);
		#end
	}

    
	#if ((cpp || neko || nodejs) && lime_curl && !macro)
    @:cffi private static function lime_curl_multi_init() : Float;
	@:cffi private static function lime_curl_multi_perform
        (multi : Float, ready : Array<Float>) : Void;
	@:cffi private static function lime_curl_multi_add_handle
        (multi : Float, easy : Float) : Void;
	@:cffi private static function lime_curl_multi_remove_handle
        (multi : Float, easy : Float) : Void;
	#end
}
