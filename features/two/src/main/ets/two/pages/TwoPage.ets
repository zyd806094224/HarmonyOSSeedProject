import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { CommonConstants, RouterUrl } from "component";

/**
 * 使用 HMRouter 装饰器定义路由 URL
 */
@HMRouter({ pageUrl: RouterUrl.TWO_TAB_INDEX_PAGE })
@Entry
@ComponentV2
export struct TwoPage{

  build() {
    Column(){
      Text('two测试页面')
        .fontSize($r('app.float.size_12'))
        .fontColor(Color.White)
      Button('跳转h5页面')
        .width(CommonConstants.WRAP_CONTENT)
        .height($r('app.float.size_24'))
        .fontSize($r('app.float.size_12'))
        .fontColor(Color.White)
        .onClick(() => {
          HMRouterMgr.push({
            navigationId: CommonConstants.LAUNCHER_NAVIGATION_ID,
            pageUrl: RouterUrl.WEB_PAGE_URL,
            param: {
              url: 'http://106.15.7.132:3000/',
              title: '测试标题'
            }
          })
        })
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.2f92ff'))
  }
}