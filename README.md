# oh-my-videojs
video.js 和 video-js-swf 的源码分析

## `Video`

+ `attachNetStream(netStream:NetStream):void` 将 NetStream 的数据帧通过 Video 显示出来
+ `clear():void` 清空当前播放画面
+ `width` 和 `height` 获取／设置宽度／高度

## `NetStream`

初始化一个 `NetStream` 的正确姿势:

1. 创建 `NetStream` 实例
2. 添加 `NetStatusEvent.NET_STATUS` 事件监听
3. 创建一个 Video 容器并调用 `attachNetStream` 方法，将 Video 和 NetStream 关联起来
4. 调用 `play` 方法开始播放
5. 调用 `addChild` 将 Video 添加到 stage

### properties

#### `bufferTime`

在开始播放之前至少要缓存多少秒的数据

+ 默认是 0.1 秒

#### `bufferLength`

当前缓冲区中的缓存了多少秒的数据

+ 通过比较 `bufferLength` 和 `bufferTime` 的大小，可以预估离缓存满还有多长时间

#### `bufferTimeMax`

指定缓冲区最大可以缓存多少秒的数据。

+ 如果 bufferTimeMax > 0 且 bufferLength >= bufferTimeMax ， audio 就会加速播放直到 bufferLength 减小到 bufferTime ；如果是 video-only ，video 就会加速播放直到 bufferLength 减小到 bufferTime
+ 加速的范围在 1.5% ~ 6.25%

#### `bytesLoaded`

当前已加载的字节数

#### `bytesTotal`

当前加载的文件的总字节数

### methods

#### `.play()`

从本地文件系统或者 web 服务器播放一个媒体文件

播放一个外部 flv 文件：

```javascript
_ns.play('http://path/to/example.flv');
```

#### `.close()`

停止播放并将时间重置为 0

#### `.pause()`

暂停播放，如果已经暂停就什么也不做。要恢复播放调用 `.resume()` 方法。要切换“播放／暂停”调用 `.togglePause()` 方法。

__从 Flash Player 9.0.115.0 开始，暂停播放的时候不会清空缓存，这种策略称为“smart pause”，这样的好处是恢复播放的时候可以直接从缓存播放，减少造成延迟。__*为了兼容旧的播放器，“NetStream.Buffer.Flush”这个事件依然会触发，但是此时并不意味着缓存一定被清空。*

#### `.appendBytes()`

## `NetConnection`

初始化一个 `NetConnection` 的正确姿势:

1. 创建 `NetConnection` 实例
2. 添加 `NetStatusEvent.NET_STATUS` 事件监听
3. 调用 `connect` 方法，传一个 `null` 参数（表示从本地文件系统或者 web 服务器播放视频／音频）

```actionscript
var _nc:NetConnection = new NetConnection();
_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
_nc.connect(null);
```

## 关于 NetStream 和 NetConnection 的 client

client 属性定义了 NetStream 和 NetConnection 的回调函数被调用时的对象，例如 onMetaData 触发时应该调用哪个对象的 onMetaData 方法

## flash.utils

### flash.utils.getTimer

从 swf 文件开始播放到当前时间的总毫秒数

## NetStatusEvent

### NetConnection.Connect.Closed

正常关闭成功

### NetConnection.Connect.Success

尝试连接成功

### NetConnection.Connect.Failed

尝试连接失败

### NetConnection.Connect.NetworkChange

Flash 播放器检测到网络的变化：无线连接断开／无线连接成功／网线断开，等等

> Don't use this event to implement your NetConnection reconnect logic. Use "NetConnection.Connect.Closed" to implement your NetConnection reconnect logic.

### NetConnection.Connect.Rejected

尝试连接被拒

### NetStream.Buffer.Flush

数据流已经停了，而且缓存已经清空