package com.miniplayer.events {

  import flash.events.Event;

  public class MiniPlayerEvent extends Event {

    public static const SHIT:String = "SHIT";

    public function MiniPlayerEvent(pType:String, pData:Object = null){
      super(pType, true, false);
      _data = pData;
    }

  }

}
