import { HMRouter } from "@hadss/hmrouter";
import { Logger, RouterUrl } from "component";
import { ApiResult, httpClient, HttpError } from "network";

/**
 * 使用 HMRouter 装饰器定义路由 URL
 */
@HMRouter({ pageUrl: RouterUrl.THREE_TAB_INDEX_PAGE })
@Entry
@ComponentV2
export struct ThreePage {
  build() {
    Column() {
      Text('three测试页面')
        .fontSize($r('app.float.size_12'))
        .fontColor(Color.White)
      Button('点击网络请求')
        .onClick(() => {
          fetchTest().then((result) => {
            Logger.e("zzz", `API Response: ${result}`);
          })
        })
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.2f92ff'))
  }
}

async function fetchTest(): Promise<void> {
  try {
    const response: ApiResult<object> = await httpClient.get<object>(`/test/`);
    if (response.code === 0) { // Assuming 0 is the success code from your backend
      const data = response.data;
    } else {
      Logger.e("zzz", `API Error: ${response.message}`);
    }
  } catch (error) {
    if (error instanceof HttpError) {
      Logger.e("zzz", `HTTP Error: ${error.message}, Code: ${error.code}`);
    } else {
      Logger.e("zzz", `An unexpected error occurred: ${error.message}`);
    }
  }
}