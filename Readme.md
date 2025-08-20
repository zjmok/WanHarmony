# 基于 HarmonyOS 5.0.0(12) 的 WanAndroid App

api 和官方网站 <https://www.wanandroid.com>

"compatibleSdkVersion": "5.0.0(12)"

开发工具 Deveco Studio 5.0.3, API 12

## 效果

### 手机端

<div style="display: flex; justify-content: space-between;">
    <img src="pictrue/pic_phone.png" width="32%">
    <img src="pictrue/pic_phone2.png" width="32%">
    <img src="pictrue/pic_phone3.png" width="32%">
</div>

### 折叠屏

<img src="pictrue/pic_foldable.png" width="512">

<img src="pictrue/pic_foldable2.png" width="512">

### 平板端

<img src="pictrue/pic_tablet.png" width="768">

<img src="pictrue/pic_tablet2.png" width="768">

<!-- 0.3 倍缩放 -->

### others

<img src="pictrue/pic_code.png" alt="Alt text" width="1080">

## 功能和技术点

- [x] 网络：使用原生 NetworkKit 的 http 进行网络请求（可选三方库 @ohos/axios），cookies 使用原生 PersistentStorage 持久化存储（可选三方库 @tencent/mmkv）
- [x] 图片：使用原生 Image（可选三方库 @ohos/imageknife）
- [x] 状态管理：使用 V1 稳定版。
- [x] 页面路由：原生 NavPathStack + Navigation + NavDestination（可选三方库 @hadss/hmrouter、@hzw/zrouter）
- [x] 首页使用 Tabs 组件，自定义 tabBar
- [x] 页面刷新和加载更多：使用原生 Refresh 组件的 onRefreshing 进行刷新；使用 List 的 onReachEnd 进行加载更多。（可选三方库 @abner/refresh、@ohos/pulltorefresh）
- [x] 适配不同宽度的页面，PersonPage 已使用 Flex 适配
- [x] 浏览历史，侧滑删除使用 @abner/refresh，时间格式化使用 JavaScript 库 dayjs，存储使用原生 PersistentStorage 持久化存储（可选三方库 @tencent/mmkv、@liushengyi/smartdb、@ohos/dataorm）
- [ ] 深色模式
- [ ] 完善其它接口的页面

## 开发过程中的一些记录

### Webview

微信文章需要开启 DOM

```typescript
Web().domStorageAccess(true) // 开启 DOM 存储，否则 微信文章 会显示异常
```

### 适配 Tablet、Foldable

利用 Flex 组件，适配了不同宽度的页面。PersonPage 已经适配好。

### 