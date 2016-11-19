# video.js 的插件开发

video.js 中通过 `videojs.plugin()` 方法添加插件，这个插件的初始化函数会直接添加到 `Player.prototype` 中。因此，初始化函数中的 context 就是 Player 实例。

## videojs.plugin(name, init)

+ name 就是插件名称，就是添加到 Player.prototype 的函数名
+ init 就是插件的初始化函数
