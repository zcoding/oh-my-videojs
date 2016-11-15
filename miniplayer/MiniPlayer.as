package {

  import flash.display.Sprite;
  import flash.system.Security;
  import flash.external.ExternalInterface;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
  import flash.utils.Timer;
  import flash.events.TimerEvent;
  import flash.events.ContextMenuEvent;
  import flash.events.NetStatusEvent;
  import flash.events.AsyncErrorEvent;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.media.Video;
  import flash.utils.getTimer;

  [SWF(backgroundColor="#000000", frameRate="60", width="640", height="480")]
  public class MiniPlayer extends Sprite {

    private var _stageSizeTimer:Timer;
    private var _throughputTimer:Timer;
    private var _nc:NetConnection;
    private var _ns:NetStream;
    private var _uiVideo:Video;
    private var _metaData:Object;
    private var _isBuffering:Boolean; // 是否正在缓存

    private var _loadStartTimestamp:int = 0; // 开始加载的时间
    private var _currentThroughput:int = 0; // 加载速率

    private var _liveUrl:String = ""; // 直播地址

    public function MiniPlayer() {
      Security.allowDomain("*");
      _stageSizeTimer = new Timer(250);
      _stageSizeTimer.addEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
      _stageSizeTimer.start();
      _throughputTimer = new Timer(250);
      _throughputTimer.addEventListener(TimerEvent.TIMER, onThroughputTimerTick);
    }

    private function onStageSizeTimerTick(e:TimerEvent):void {
      if(stage.stageWidth > 0 && stage.stageHeight > 0) {
        _stageSizeTimer.stop();
        _stageSizeTimer.removeEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
        init();
      }
    }

    // 初始化右键菜单
    private function init():void {
      var _ctxMenuI1:ContextMenuItem = new ContextMenuItem("MiniPlayer v0.1.0", false, true, true);
      var _ctxMenuI2:ContextMenuItem = new ContextMenuItem("About MiniPlayer");
      _ctxMenuI2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandle);
      var _ctxMenu:ContextMenu = new ContextMenu();
      _ctxMenu.hideBuiltInItems();
      _ctxMenu.customItems.push(_ctxMenuI1, _ctxMenuI2);
      this.contextMenu = _ctxMenu;
      ExternalInterface.call('player_ready');
      _uiVideo = new Video(640, 400);
      _uiVideo.smoothing = true;
      addChild(_uiVideo);
      initNetConnection();
    }

    // 监听 NetConnection 连接状态
    private function onNetConnectionStatus(e:NetStatusEvent):void {
      switch (e.info.code) {
        case "NetConnection.Connect.Success":
          Logger.log("nc 连接成功");
          initNetStream();
          break;
        case "NetConnection.Connect.Closed":
          Logger.log("nc 连接关闭了");
          break;
        case "NetConnection.Connect.Failed":
          Logger.log("nc 连接失败了");
          break;
        case "NetConnection.Connect.NetworkChange":
          Logger.log("nc 连接状态有变");
          break;
        case "NetConnection.Connect.Rejected":
          Logger.log("nc 连接被拒绝");
          break;
      }
    }

    // 监听 NetStream 连接状态
    private function onNetStreamStatus (e:NetStatusEvent):void {
      switch (e.info.code) {
        case "NetStream.Play.Start":
          _loadStartTimestamp = getTimer(); // 开始加载时间
          _throughputTimer.reset();
          _throughputTimer.start();
          Logger.log("ns 播放开始了");
          break;
        case "NetStream.Play.Failed":
          Logger.log("ns 播放失败了");
        case "NetStream.Pause.Notify":
          Logger.log("ns 播放暂停了");
          break;
        case "NetStream.Unpause.Notify":
          Logger.log("ns 播放恢复了");
          break;
        case "NetStream.Play.StreamNotFound":
          Logger.log("ns 播放不了: " + _liveUrl);
          break;
        case "NetStream.Play.NoSupportedTrackFound":
          Logger.log("文件不支持播放");
          break;
        case "NetStream.Buffer.Full":
          _isBuffering = false;
          Logger.log("ns 缓存满了");
          break;
        case "NetStream.Buffer.Flush": // 这个事件在 pause 的时候会触发，但是实际上并不会清空缓存
          Logger.log("ns 触发 Flush");
          break;
        case "NetStream.Buffer.Empty":
          _isBuffering = true;
          Logger.log("ns 缓存空了");
          break;
        case "NetStream.Play.Stop":
          Logger.log("ns 播放停止了");
          initNetConnection(); // 重连
          break;
      }
    }

    private function formatThroughput (cThroughput:int):String {
      if (cThroughput < 1024) {
        return cThroughput + " B/s";
      } else if (cThroughput < 1024 * 1024) {
        return (cThroughput / 1024) + " KB/s";
      } else {
        return (cThroughput / (1024 * 1024)) + " MB/s";
      }
    }

    // 计时器：throughputTimer
    private function onThroughputTimerTick (e:TimerEvent):void {
      if (_ns) {
        _currentThroughput = _ns.bytesLoaded / ((getTimer() - _loadStartTimestamp) / 1000);
        //Logger.log("当前加载速率: " + formatThroughput(_currentThroughput));
      }
    }

    private function initNetStream():void {
      if (_ns) {
        Logger.log("尝试关闭 ns");
        _ns.close();
        _ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
        _ns = null;
      }
      _ns = new NetStream(_nc);
      _ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
      _ns.client = this;
      _ns.inBufferSeek = true; // Smart seeking
      _ns.bufferTime = 0;
      _ns.bufferTimeMax = 1;
      _ns.useHardwareDecoder = true; // 使用硬件解码
      _ns.play(_liveUrl);
      //_ns.pause();
      _uiVideo.clear();
      _uiVideo.attachNetStream(_ns);
    }

    private function onAsyncError(e:AsyncErrorEvent):void {
      Logger.log("async error");
    }

    // 初始化 _nc
    private function initNetConnection():void {
      Logger.log("初始化 nc");
      if (_nc) {
        try {
          Logger.log("尝试关闭 nc");
          _nc.close();
        } catch (e:Error) {
          Logger.log("尝试关闭 nc 出错");
        }
        _nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
        _nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
        _nc = null;
      }
      _nc = new NetConnection();
      _nc.client = this;
      _nc.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
      _nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
      _nc.connect(null);
    }

    public function onMetaData(pMetaData:Object):void {
      _metaData = pMetaData;
      for (var k:String in _metaData) {
        //Logger.log(k + ": " + _metaData[k]);
      }
    }

    private function menuItemSelectHandle(e:ContextMenuEvent):void {
      ExternalInterface.call("window.open", 'https://github.com/zcoding/video.js', '_blank');
    }

  }

}
