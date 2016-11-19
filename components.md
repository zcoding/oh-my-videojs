# Components

video.js 使用了“组件”

基类: `Component`

## 组件的几个重要方法

+ `.createEl()` 创建组件对应的 DOM 元素
+ `.el()` 返回组件的 DOM 元素
+ `.name()` 返回组件的名称
+ `.children()` 返回组件的子组件
+ `.player()` 返回组件的播放器实例，如果组件本身就是播放器，就返回本身
+ `.dispose()` 销毁组件（同时也销毁子组件）
+ `.getChildById()` 通过 ID 获取子组件
+ `.getChild()` 通过名称获取子组件
+ `.addChild()` 添加子组件
+ `.removeChild()` 移除子组件
+ `.on()` 添加事件监听
+ `.off()` 移除事件监听
+ `.one()` 添加事件监听，仅一次
+ `.trigger()` 触发事件
+ `.ready()` 添加 ready 事件回调
+ `.triggerReady()` 触发 ready 事件
+ `.$()` 选择元素，类似 jQuery 方法
+ `.hasClass(), .addClass(), .removeClass(), .toggleClass()` 类似 jQuery 方法
+ `.show(), .hide()` 显示／隐藏
+ `.getAttribute(), .setAttribute(), .removeAttribute()` 获取／设置／删除 DOM 元素的属性
+ `.width(), .height(), .dimensions()` 设置播放器宽度／高度
+ `.currentDimensions(), .currentWidth(), .currentHeight()` 获取播放器宽短／高度
+ `.setTimeout(), .clearTimeout(), .setInterval(), .clearInterval()` 定时器相关

### 静态方法

+ `.registerComponent()` 注册组件
+ `.getComponent()` 获取组件

## video.js 的原生组件

### Player

+ `.techGet_()`

#### 播放控制相关方法

+ `.play()`
+ `.pause()`

#### 播放时间相关

+ `.currentTime()` 当前播放时间
+ `.remainingTime()` 播放剩余时间

### Button

`Button` 继承自 `ClickableComponent`

### ControlBar

