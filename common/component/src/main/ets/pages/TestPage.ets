import { HMRouter } from "@hadss/hmrouter";
import { RouterUrl } from "../RouterUrl";

@HMRouter({ pageUrl: RouterUrl.TEST_PAGE_URL })
@ComponentV2
export struct TestPage{

  build() {
    Column(){
      Text('测试页面')
        .fontSize($r('app.float.size_12'))
        .fontColor(Color.White)
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.2f92ff'))
  }
}