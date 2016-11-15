package {

  import flash.external.ExternalInterface;

  public class Logger {

    public static function log(msg:Object):void {
      ExternalInterface.call("debug_as_log", msg);
    }

  }

}
