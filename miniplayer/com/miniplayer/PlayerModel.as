package com.miniplayer {

  import flash.events.EventDispatcher;
  import flash.media.Video;
  import com.miniplayer.events.MiniPlayerEvent;
  import com.miniplayer.providers.HTTPVideoProvider;

  public class PlayerModel extends EventDispatcher {

    private var _provider:HTTPVideoProvider;
    private var _src:String = ""; // 播放链接
    private var _videoReference:Video;

    private static var _singleton:PlayerModel;

    public function PlayerModel(pLock:SingletonLock) {
      if (!pLock is SingletonLock) {
        throw new Error("Invalid Singleton access.  Use VideoJSModel.getInstance()!");
      }
    }

    public function get src():String {
      return _src;
    }
    public function set src(pSrc:String):void {
      _src = pSrc;
      initProvider();
    }

    public function get videoReference():Video{
      return _videoReference;
    }
    public function set videoReference(pVideo:Video):void {
      _videoReference = pVideo;
    }

    public function pause():void {
      _provider.pause();
    }

    private function initProvider():void {
      _provider = new HTTPVideoProvider();
      _provider.attachVideo(_videoReference);
      _provider.src = _src;
    }

    public static function getInstance():PlayerModel {
      if (_singleton === null) {
        _singleton = new PlayerModel(new SingletonLock());
      }
      return _singleton;
    }

  }

}

// 保证单例不能在外部生成
class SingletonLock {}
