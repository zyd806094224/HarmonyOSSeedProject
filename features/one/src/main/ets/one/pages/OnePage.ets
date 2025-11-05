import { HMLifecycleState, HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { RouterUrl, TabBarOptions, TabBarOptionsInterface } from "component";


/**
 * 使用 HMRouter 装饰器定义路由 URL
 */
@HMRouter({ pageUrl: RouterUrl.ONE_TAB_INDEX_PAGE })
@Entry
@ComponentV2
export struct OnePage {

  /**
   * 标志位，用于判断是否已经初始化过
   */
  private _hasInit: boolean = false

  /**
   * TabBar配置
   */
  @Local private tabBarOptions: TabBarOptionsInterface = new TabBarOptions()

  /**
   * 组件生命周期函数，在组件实例进入页面节点树时执行
   */
  aboutToAppear(): void {
    if (this._hasInit) {
      return
    }
    this._hasInit = true
    const owner = HMRouterMgr.getCurrentLifecycleOwner();
    owner?.addObserver(HMLifecycleState.onShown, (ctx) => {
      this.onPageShow()
    })
    owner?.addObserver(HMLifecycleState.onHidden, (ctx) => {
      this.onPageHide()
    })
  }

  /**
   * 页面显示时调用
   */
  onPageShow(): void {

  }
  /**
   * 页面隐藏时调用
   */
  onPageHide(): void {

  }

  build() {
    Column(){
      Text('one测试页面')
        .fontSize($r('app.float.size_12'))
        .fontColor(Color.White)
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.2f92ff'))
  }


}