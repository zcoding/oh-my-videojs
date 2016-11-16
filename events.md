# 自定义事件

## ActionScript 的事件系统

### flash.events.Event

事件基类

### flash.events.EventDispatcher

事件适配器基类

### 如何触发事件

调用 `dispatchEvent` 方法

### 如何添加事件监听

调用 `addEventListener` 方法

## video-js-swf 的事件系统

继承 Event 的类有

+ `VideoJSEvent`
+ `VideoPlaybackEvent`
+ `VideoErrorEvent`

继承 EventDispatcher 的类有

+ `VideoJSModel`

### 原生事件类型

+ `Event.RESIZE`

### 自定义事件类型

+ `VideoJSEvent.STAGE_RESIZE` 舞台大小缩放的时候触发
+ `VideoJSEvent.BACKGROUND_COLOR_SET` 设置背景颜色的时候触发
+ `VideoPlaybackEvent.ON_CUE_POINT`
+ `VideoPlaybackEvent.ON_META_DATA`
+ `VideoPlaybackEvent.ON_XMP_DATA`
+ `VideoPlaybackEvent.ON_NETSTREAM_STATUS`
+ `VideoPlaybackEvent.ON_NETCONNECTION_STATUS`
+ `VideoPlaybackEvent.ON_STREAM_READY`
+ `VideoPlaybackEvent.ON_STREAM_NOT_READY`
+ `VideoPlaybackEvent.ON_STREAM_START`
+ `VideoPlaybackEvent.ON_STREAM_CLOSE`
+ `VideoPlaybackEvent.ON_STREAM_METRICS_UPDATE`
+ `VideoPlaybackEvent.ON_STREAM_PAUSE`
+ `VideoPlaybackEvent.ON_STREAM_RESUME`
+ `VideoPlaybackEvent.ON_STREAM_SEEK_COMPLETE`
+ `VideoPlaybackEvent.ON_STREAM_REBUFFER_START`
+ `VideoPlaybackEvent.ON_STREAM_REBUFFER_END`
+ `VideoPlaybackEvent.ON_ERROR`
+ `VideoPlaybackEvent.ON_UPDATE`
+ `VideoPlaybackEvent.ON_VIDEO_DIMENSION_UPDATE`
+ `VideoPlaybackEvent.ON_TEXT_DATA`
+ `VideoPlaybackEvent.SRC_MISSING`

### 如何触发

+ `VideoJSModel` 的 `broadcastEvent` 方法调用 `dispatchEvent` 触发

## video.js 的事件系统

swf 内部可以触发 video.js 中定义的事件，具体的事件名称通过 _jsEventProxyName 和 _jsErrorEventProxyName 来设置

+ `broadcastEventExternally`
+ `broadcastErrorEventExternally`

实际上 _jsEventProxyName 和 _jsErrorEventProxyName 是不能设置的，其值就是 "videojs.Flash.onEvent" 和 "videojs.Flash.onError"，不能设置是基于 XSS 考虑

