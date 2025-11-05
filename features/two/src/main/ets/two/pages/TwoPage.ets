import { HMRouter } from "@hadss/hmrouter";
import { RouterUrl } from "component";

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
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.2f92ff'))
  }
}