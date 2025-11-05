import { HMLifecycleState, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { webview } from '@kit.ArkWeb';
import { CommonConstants } from '../CommonConstants';
import { LoadingStatus } from '../CommonEnums';
import { RouterUrl } from '../RouterUrl';
import { Logger } from '../utils/Logger';
import { window } from '@kit.ArkUI';


/**
 * 路由传递的页面参数
 */
export class WebPageData {
  url?: ResourceStr;
  title?: ResourceStr;
  barBackgroundColor?: ResourceColor;
  /**
   * 其他url参数
   */
  otherUrlParams?: Record<string, string>
}

const TAG = 'WebPage'


/**
 * 使用webview加载页面
 */
@HMRouter({ pageUrl: RouterUrl.WEB_PAGE_URL })
@ComponentV2
export struct WebPage {
  /**
   * 内嵌页面时传入的地址
   */
  @Param originUrl?: string = undefined
  /**
   * 路由传递的html地址
   */
  @Local url: ResourceStr = ''
  /**
   * 路由传递的页面参数
   */
  pageData?: WebPageData
  /**
   * webview控制器
   */
  @Param controller: webview.WebviewController = new webview.WebviewController();
  /**
   * 下载代理
   */
  downloadDelegate: webview.WebDownloadDelegate = new webview.WebDownloadDelegate();
  /**
   * 窗口的系统区域信息
   */
  windowAvoidArea?: window.AvoidArea = AppStorage.get<window.AvoidArea>(CommonConstants.APP_STORAGE_WINDOW_AVOID_AREA);
  /**
   * 网页标题
   */
  @Local title?: string = undefined
  /**
   * 是否是根页面
   */
  @Local isRootPage: boolean = true
  /**
   * 加载状态
   */
  @Local loadingState: LoadingStatus = LoadingStatus.LOADING
  /**
   * 页面加载布局高度
   */
  @Local loadingHeight: string = CommonConstants.MATCH_PARENT
  /**
   * 是否在恢复时刷新页面
   */
  @Param refreshWhenResume: boolean = false

  /**
   * 页面即将显示
   */
  aboutToAppear(): void {
    const owner = HMRouterMgr.getCurrentLifecycleOwner();

    // 如果不是通过路由打开页面可能没有参数
    if (HMRouterMgr.getCurrentParam()) {
      this.pageData = HMRouterMgr.getCurrentParam() as WebPageData;
      this.url = this.pageData.url ?? ''
      // 监听返回键
      owner?.addObserver(HMLifecycleState.onBackPressed, () => {
        if (this.shouldInterceptBack()) {
          this.controller.backward()
          return true // 拦截返回键
        }
        return false
      })
    }

    webview.WebCookieManager.putAcceptCookieEnabled(true)
    webview.WebCookieManager.putAcceptThirdPartyCookieEnabled(true)

    // 重新可见
    owner?.addObserver(HMLifecycleState.onShown, () => {
      if (this.refreshWhenResume) {
        this.controller.refresh()
      }
    })
  }

  /**
   * 是否拦截返回键
   * @returns 拦截的结果
   */
  shouldInterceptBack() {
    // 判断网页容器是否可以返回到上一页
    return this.controller.accessBackward()
  }

  /**
   * 构建页面
   */
  build() {
    Column() {
      // 标题栏，默认从路由跳转都显示标题栏
      if (this.pageData) {
        this.TitleBar()
      }
      // 显示loading
      if (this.loadingState === LoadingStatus.LOADING) {
        Row() {
          LoadingProgress()
            .width($r('app.float.size_50'))
            .height($r('app.float.size_50'))
        }.width(CommonConstants.MATCH_PARENT)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height(this.loadingHeight)
      }

      // 网页容器
      Web({ src: this.originUrl ?? this.url, controller: this.controller })
        .cacheMode(CacheMode.Online)// 不使用缓存
          // .javaScriptProxy({
          //   object: this.bridge,
          //   name: this.bridgeName,
          //   methodList: this.bridge.methods,
          //   controller: this.controller
          // })
        .onOverrideUrlLoading((callback) => {
          let requestUrl = callback.getRequestUrl()
          Logger.i(TAG, 'opening link: ' + requestUrl)
          return false
        })
        .onControllerAttached(() => {

        })
        .onProgressChange((callback) => {
          if (this.controller.accessBackward()) {
            this.isRootPage = false
          } else {
            this.isRootPage = true
          }
          if (callback.newProgress === 100 && this.loadingState === LoadingStatus.LOADING) {
            this.loadingState = LoadingStatus.SUCCESS
          }
        })
        .onPageBegin(() => {
          this.isRootPage = true
          this.loadingState = LoadingStatus.LOADING
        })
        .onPageVisible(() => {
          if (this.loadingState === LoadingStatus.LOADING) {
            this.loadingState = LoadingStatus.SUCCESS
          }
        })
        .onTitleReceive((event) => {
          this.title = event.title
        })
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .fileAccess(false)
        .mixedMode(MixedMode.All)
        .margin({ bottom: this.pageData ? `${(this.windowAvoidArea?.bottomRect?.height ?? 0)}px` : 0 })

    }.height(CommonConstants.MATCH_PARENT)
  }

  /**
   * 创建标题栏
   */
  @Builder
  TitleBar() {
    RelativeContainer() {
      // 返回键
      Image($r('app.media.icon_back'))
        .id('back')
        .width($r('app.float.size_44'))
        .height(CommonConstants.MATCH_PARENT)
        .fillColor($r('app.color.black'))
        .padding($r('app.float.size_14'))
        .alignRules({
          left: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: HorizontalAlign.Start },
          center: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: VerticalAlign.Center },
        })
        .onClick(() => {
          if (this.shouldInterceptBack()) {
            this.controller.backward()
          } else {
            HMRouterMgr.pop()
          }
        })

      if (!this.isRootPage) {
        Text($r('app.string.close'))
          .id('close')
          .alignRules({
            left: { anchor: 'back', align: HorizontalAlign.End },
            center: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: VerticalAlign.Center },
          })
          .fontSize($r('app.float.size_14'))
          .width($r('app.float.size_40'))
          .height(CommonConstants.MATCH_PARENT)
          .onClick(() => {
            HMRouterMgr.pop()
          })
      }

      // 标题
      Text(this.title ?? this.pageData?.title ?? "")
        .fontSize($r('app.float.size_18'))
        .fontColor($r('app.color.default_text_color'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.MARQUEE })
        .alignRules({
          middle: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: HorizontalAlign.Center },
          center: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: VerticalAlign.Center },
          left: { anchor: this.isRootPage ? 'back' : 'close', align: HorizontalAlign.End },
          right: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: HorizontalAlign.End },
        })
        .textAlign(TextAlign.Center)
        .margin({
          left: this.isRootPage ? $r('app.float.size_10') : $r('app.float.size_4'),
          right: $r('app.float.size_4')
        })

      // 底部分割线
      Divider()
        .height($r('app.float.size_1'))
        .backgroundColor($r('app.color.f5f5f5'))
        .alignRules({
          bottom: { anchor: CommonConstants.RELATIVE_PARENT_ID, align: VerticalAlign.Bottom },
        })
    }
    .width(CommonConstants.MATCH_PARENT)
    .backgroundColor($r('app.color.white'))
    .height($r('app.float.size_50'))
  }

  /**
   * 页面销毁
   */
  aboutToDisappear(): void {
    // // 移除js对象
    // this.controller.deleteJavaScriptRegister(this.bridgeName)
    // // 回调页面销毁
    // this.bridge.onPageDestroy()
  }
}