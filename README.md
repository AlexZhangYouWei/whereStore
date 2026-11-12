# whereStore（附近餐廳）

2017 年製作的 iOS 專題作品：找出附近餐廳，查看店家資訊，並在店家頁面留言。

> 本專案已停止維護，僅作為作品保存。目標版本為 iOS 8，在新版 Xcode 上可能無法直接建置。

## 功能

- **附近餐廳**：用 MapKit 與 CoreLocation 在地圖上標示附近店家，並計算距離
- **餐廳搜尋**：依條件搜尋店家
- **詳細資訊**：店名、地址、電話、類別、公休日、評價、餐點照片
- **留言板**：店家留言存放在 Firebase Realtime Database
- **收藏**：收藏喜歡的店家

## 技術

- Objective-C、UIKit、Storyboard
- MapKit、CoreLocation
- Firebase（Core、Realtime Database），以 CocoaPods 管理

## 建置

```bash
pod install
open 專題.xcworkspace
```

需要自己的 Firebase 專案，並以對應的 `GoogleService-Info.plist` 取代原本的檔案。
