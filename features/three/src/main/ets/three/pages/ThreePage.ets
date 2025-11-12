import { HMRouter } from "@hadss/hmrouter";
import { AnyType, Logger, RouterUrl } from "component";
import { ApiResult, httpClient, HttpError } from "network";
import { JSON } from "@kit.ArkTS";


/**
 * httpClient 使用示例
 *
 * 核心功能:
 * 1. GET/POST 请求: 展示了如何发起 GET 和 POST 请求。
 * 2. 状态管理: 使用 @Local 变量在 UI 上同步显示网络请求的结果。
 * 3. 错误处理: 捕获 HttpError 并显示错误码和错误信息。
 * 4. 请求拦截器: 演示了如何通过 addRequestInterceptor 添加统一的请求头。
 * 5. UI交互: 通过按钮触发网络请求，并将结果反馈给用户。
 */
interface LoginUser {
  no: string;
  password: string;
}

@HMRouter({ pageUrl: RouterUrl.THREE_TAB_INDEX_PAGE })
@Entry
@ComponentV2
export struct ThreePage {
  // 用于在UI上显示网络请求的结果
  @Local responseText: string = '点击按钮发起请求';

  aboutToAppear(): void {
    // 添加请求拦截器
    httpClient.addRequestInterceptor({
      onRequest(config) {
        if (!config.header) {
          config.header = {};
        }
        // 示例：添加认证头
        config.header['Authorization'] = 'Bearer your-dynamic-token-here';
        Logger.i("zzz", `Request Interceptor: Processing request for ${config.url}`);
        return config;
      }
    });
  }

  /**
   *  发起 GET 请求示例
   */
  async testGet(): Promise<void> {
    this.responseText = 'Fetching data with GET...';
    try {
      const response: ApiResult<string> = await httpClient.get<string>(`/user/test`);
      this.responseText = `GET Success: ${response.data}`;
      Logger.i("zzz", `GET Response Data: ${JSON.stringify(response)}`);
    } catch (error) {
      this.handleError('GET', error);
    }
  }

  /**
   * 发起 POST 请求示例
   */
  async testPostJson(): Promise<void> {
    this.responseText = 'Submitting data with POST (JSON)...';
    try {
      const postData: LoginUser = { no: 'zhangsan', password: '123456' };
      const response: ApiResult<AnyType> = await httpClient.post(
        `/user/login`,
        JSON.stringify(postData)
      );
      // 为了在UI上显示，最好是解析后取某个字段，或者直接显示整个字符串
      Logger.i("zzz", `POST (JSON) Response Data: ${JSON.stringify(response)}`);
      this.responseText = `POST (JSON): ${JSON.stringify(response)}`;
    } catch (error) {
      this.handleError('POST (JSON)', error);
    }
  }

  // 统一的错误处理函数
  private handleError(method: string, error: AnyType) {
    if (error instanceof HttpError) {
      this.responseText = `${method} Error: Code=${error.code}, Message=${error.message}`;
      Logger.e("zzz", `${method} HttpError: ${error.message}`);
    } else {
      this.responseText = `${method} Error: An unexpected error occurred.`;
      Logger.e("zzz", `${method} Unexpected Error: ${error}`);
    }
  }

  build() {
    Column({ space: 15 }) {
      Text('HttpClient 使用示例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .padding({ top: 20, bottom: 10 })

      // 显示网络请求结果的区域
      Scroll() {
        Text(this.responseText)
          .fontSize(16)
          .fontColor(Color.Black)
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .backgroundColor(Color.White)
      .padding(10)
      .borderRadius(8)
      .width('90%')
      .height(120)
      .scrollable(ScrollDirection.Vertical)


      // GET 请求按钮
      Button('发起 GET 请求')
        .width('90%')
        .onClick(() => this.testGet())

      // POST (JSON) 请求按钮
      Button('发起 POST 请求 (JSON)')
        .width('90%')
        .onClick(() => this.testPostJson())
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.2f92ff'))
  }
}