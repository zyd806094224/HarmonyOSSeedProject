import { HMRouter } from "@hadss/hmrouter";
import { Logger, RouterUrl } from "component";
import { ApiResult, httpClient, HttpError } from "network";

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

@HMRouter({ pageUrl: RouterUrl.THREE_TAB_INDEX_PAGE })
@Entry
@ComponentV2
export struct ThreePage {
  // 用于在UI上显示网络请求的结果
  @Local responseText: string = '点击按钮发起请求';

  aboutToAppear(): void {
    // 添加请求拦截器
    // 拦截器是可选的，适用于需要在每个请求发送前执行通用逻辑的场景，例如添加统一的 header
    httpClient.addRequestInterceptor({
      onRequest(config) {
        // 在这里可以修改请求配置
        // 示例：添加认证头。在实际应用中，token通常来自登录后保存的用户信息
        if (!config.header) {
          config.header = {};
        }
        config.header['Authorization'] = 'Bearer your-dynamic-token-here';
        Logger.i("HttpClientExample", `Request Interceptor: Added Authorization header to request for ${config.url}`);
        // 注意：此时config.url还是相对路径，完整URL会在后续网络库内部构建
        return config;
      }
    });
  }

  /**
   *  发起 GET 请求示例
   *  GET请求通常用于获取数据
   */
  async testGet(): Promise<void> {
    this.responseText = 'Fetching data with GET...';
    try {
      // 发起GET请求，期望返回的数据结构是 ApiResult<T>
      // httpClient.get<T> 中的 T 代表 ApiResult.data 的类型
      // 这里的URL `/user/test` 是一个相对路径，httpClient内部会自动拼接 baseURL
      const response: ApiResult<string> = await httpClient.get<string>(`/user/test`);

      // 请求成功，response.data 就是服务器返回的具体业务数据
      this.responseText = `GET Success: ${response.data}`;
      Logger.i("HttpClientExample", `GET Response Data: ${JSON.stringify(response)}`);

    } catch (error) {
      // 请求失败，错误会被包装成 HttpError 对象
      if (error instanceof HttpError) {
        // 从 HttpError 对象中可以获取状态码、错误信息等
        this.responseText = `GET Error: Code=${error.code}, Message=${error.message}`;
        Logger.e("HttpClientExample", `GET HttpError: ${error.message}`);
      } else {
        // 其他未知错误
        this.responseText = `GET Error: An unexpected error occurred.`;
        Logger.e("HttpClientExample", `GET Unexpected Error: ${error}`);
      }
    }
  }

  build() {
    Column({ space: 20 }) {
      Text('HttpClient 使用示例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)

      // 显示网络请求结果的区域
      Text(this.responseText)
        .fontSize(16)
        .fontColor(Color.Black)
        .backgroundColor(Color.White)
        .padding(10)
        .borderRadius(8)
        .width('90%')
        .textAlign(TextAlign.Start)
        .height(100)


      // GET 请求按钮
      Button('发起 GET 请求')
        .width('90%')
        .onClick(() => {
          this.testGet();
        })

      // POST 请求按钮
      Button('发起 POST 请求')
        .width('90%')
        .onClick(() => {

        })

      Text('请在日志中查看 "HttpClientExample" 标签获取更详细的请求和响应信息。')
        .fontSize(12)
        .fontColor(Color.White)
        .width('90%')

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.2f92ff'))
  }
}
