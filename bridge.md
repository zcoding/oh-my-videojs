# video.js 和 video-js-swf 之间的通信

## as3 调用 js 的方法

```javascript
// 先在 js 中定义好给 as3 调用的函数名
function js_func(params) {
  // ...
}
```

```actionscript
// 然后在 as 中调用
ExternalInterface.call("js_func", params);
```

## js 调用 as3 的方法

```actionscript
// 先在 as3 中定义好给 js 调用的函数名
function asFuncCall(params:Object):void {
  // ...
}
ExternalInterface.addCallback("as_func", asFuncCall);
```

```javascript
// 然后在 js 中调用
var swfobj = document.getElementById('player'); // 获取到 swf 所在的 object 对象
swfobj.as_func(params); // 在这个对象上调用刚刚定义的方法
```

## video-js-swf 提供给 video.js 的 API （JS 调用 AS）

+ `vjs_appendBuffer` 通过 Base64 字符串来添加 Buffer
+ `vjs_echo` 没什么用 ?
+ `vjs_endOfStream` 告诉播放器流添加数据完成了
+ `vjs_abort` 调用 seek 方法以清空缓存 ?
+ `vjs_discontinuity` 重置流
+ `vjs_getProperty` 获取属性值
+ `vjs_setProperty` 设置属性值
+ `vjs_autoplay`
+ `vjs_src` 设置播放链接（会触发重新播放和相关事件）
+ `vjs_load`
+ `vjs_play`
+ `vjs_pause`
+ `vjs_resume`
+ `vjs_stop`

### vjs_getProperty 可以获取哪些属性值

+ `mode` 播放模式 video 或者 audio
+ `autoplay` 是否自动播放
+ `loop` 是否循环播放
+ `preload` 是否预加载
+ `metadata` 就是触发 onMetaData 的时候获取的 metadata
+ `duration` HTTP 的情况下：如果有 metadata 就返回 metadata.duration 否则如果设置过 duration 就返回设置的值，否则返回 0
+ `eventProxyFunction` 这个值默认是 "videojs.Flash.onEvent" ，是 video.js 中用来监听 video-js-swf 的事件的函数
+ `errorEventProxyFunction` 这个值默认是 "videojs.Flash.onError"，是 video.js 中用来监听 video-js-swf 的错误事件的函数
+ `currentSrc` 当前播放链接
+ `currentTime` 当前播放时间
+ `time` 同 currentTime
+ `initialTime` 初始时间，总是 0
+ `defaultPlaybackRate` 默认播放速率，总是 1
+ `ended` 判断当前是否播放完了
+ `volume` 当前音量大小
+ `muted` 当前是否静音，同 volume === 0
+ `paused` 当前是否暂停
+ `seeking` 是否处于 seeking 阶段
+ `networkState` 网络状态，有 4 个值：0 未加载，1 已完成加载，3 加载出错，2 其他
+ `readyState` 播放状态，有 5 个值：0 没有收到 metadata ，1 还没开始播放，4 缓存充足，3 还有至少 1 帧的缓存但不够充足，2 缓存不够
+ `buffered`
+ `bufferedBytesStart`
+ `bufferedBytesEnd`
+ `bytesTotal`
+ `videoWidth` 播放区的宽度（就是播放器的宽度）
+ `videoHeight` 播放区的高度（就是播放器的高度）
+ `rtmpConnection` RTMP 连接地址
+ `rtmpStream` RTMP 流地址

### vjs_setProperty 可以设置哪些属性值

__只有下面这些属性是可以设置的，如果要设置的属性不在此列，video-js-swf 会报错给你看__

+ `duration`
+ `mode`
+ `loop`
+ `background` 设置播放器的背景颜色
+ `eventProxyFunction`
+ `errorEventProxyFunction`
+ `autoplay`
+ `preload`
+ `src` 同调用 vjs_src 的效果
+ `currentTime` 设置播放时间会触发 seeking 阶段，播放画面会跳到指定的位置
+ `currentPercent` 效果同 currentTime 但是通过百分比来指定播放位置
+ `muted`
+ `volume`
+ `rtmpConnection`
+ `rtmpStream`
