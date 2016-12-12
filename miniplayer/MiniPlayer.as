package {

  import flash.display.Sprite;
  import flash.system.Security;
  import flash.external.ExternalInterface;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
  import flash.ui.ContextMenuBuiltInItems;
  import flash.utils.Timer;
  import flash.events.TimerEvent;
  import flash.events.ContextMenuEvent;
  import flash.media.Video;

  import com.miniplayer.Logger;
  import com.miniplayer.PlayerModel;

  [SWF(backgroundColor="#000000", frameRate="60", width="640", height="480")]
  public class MiniPlayer extends Sprite {

    private var _stageSizeTimer:Timer;
    private var _uiVideo:Video;

    private var _model:PlayerModel;

    public function MiniPlayer() {
      _model = PlayerModel.getInstance();
      Security.allowDomain("*");
      _stageSizeTimer = new Timer(250);
      _stageSizeTimer.addEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
      _stageSizeTimer.start();
    }

    private function onStageSizeTimerTick(e:TimerEvent):void {
      if(stage.stageWidth > 0 && stage.stageHeight > 0) {
        _stageSizeTimer.stop();
        _stageSizeTimer.removeEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
        init();
      }
    }

    private function menuItemSelectHandle(e:ContextMenuEvent):void {
      ExternalInterface.call("window.open", 'https://github.com/zcoding/oh-my-videojs', '_blank');
    }

    private function _initUI():void {
      var _ctxMenu:ContextMenu = new ContextMenu();
      _ctxMenu.hideBuiltInItems();

      var _ctxMenuI1:ContextMenuItem = new ContextMenuItem("MiniPlayer v0.1.0", false, true, true);
      _ctxMenu.customItems.push(_ctxMenuI1);
      var _ctxMenuI2:ContextMenuItem = new ContextMenuItem("About MiniPlayer");
      _ctxMenu.customItems.push(_ctxMenuI2);
      _ctxMenuI2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandle);
      this.contextMenu = _ctxMenu;
      if (ExternalInterface.available) {
        registerExternalMethods();
      }
      _uiVideo = new Video(640, 400);
      _uiVideo.smoothing = true;
      addChild(_uiVideo);
      _model.videoReference = _uiVideo;
    }

    private function init():void {
      _initUI();
      ExternalInterface.call('player_ready');
    }

    // 注册 JS 调用 AS 的方法
    private function registerExternalMethods():void {
      ExternalInterface.addCallback("minijs_setProperty", onSetPropertyCalled);
      ExternalInterface.addCallback("minijs_getProperty", onGetPropertyCalled);
      ExternalInterface.addCallback("minijs_pause", onPauseCalled);
    }

    private function onSetPropertyCalled(propertyName:String = "", pValue:* = null):void {
      switch (propertyName) {
        case "src":
          _model.src = pValue;
          break;
        default:
          Logger.log(pValue);
          break;
      }
    }

    private function onGetPropertyCalled(propertyName:String = ""):Object {
      return propertyName;
    }

    private function onPauseCalled():void {
      _model.pause();
    }

  }

}
