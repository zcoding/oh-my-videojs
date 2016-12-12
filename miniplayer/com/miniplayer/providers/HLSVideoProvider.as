package com.miniplayer.providers {

  import flash.events.EventDispatcher;

  public class HLSVideoProvider extends EventDispatcher implements IProvider {

    private _isPaused:Boolean = false;

    public function play():void {}

    public function pause():void {
      _isPaused = true;
    }

    public function resume():void {
      _isPaused = false;
    }

  }

}
