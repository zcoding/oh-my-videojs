package com.miniplayer.providers {

  import flash.media.Video;

  public interface IProvider {

    function load():void;

    function play():void;

    function pause():void;

    function resume():void;

    function stop():void;

    function die():void;

    function attachVideo(pVideo:Video):void;

    function get time():Number;

    function get paused():Boolean;

    function set src(pValue:String):void;

    function get readyState():int;

  }

}
