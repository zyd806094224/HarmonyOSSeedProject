import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter'
import { CommonConstants, Logger, RouterUrl } from 'component'
import { AttributeUpdater } from '@kit.ArkUI'

/**
 * LauncherNavModifier 类负责修改导航属性以控制导航栏的显示状态。
 * 继承自 AttributeUpdater 类，用于更新 NavigationAttribute 类型的属性。
 */
class LauncherNavModifier extends AttributeUpdater<NavigationAttribute> {
  /**
   * 初始化导航属性修改器。
   * @param instance 要修改的 NavigationAttribute 实例。
   */
  initializeModifier(instance: NavigationAttribute): void {
    // 设置导航栏为隐藏状态。
    instance.hideNavBar(true)
  }
}

/**
 * 启动页面承载容器
 */
@Entry
@ComponentV2
struct Launcher {
  modifier: LauncherNavModifier = new LauncherNavModifier()
  /**
   * 冷启动需要弹窗后显示内容区域
   */
  @Local showMainContent: boolean = true

  aboutToAppear(): void {
    Logger.e("zzz","launcher-aboutToAppear")
  }

  /**
   * 创建页面结构
   */
  build() {
    Column() {
      HMNavigation({
        navigationId: CommonConstants.LAUNCHER_NAVIGATION_ID,
        homePageUrl: this.showMainContent ? RouterUrl.MAIN_PAGE_URL : '',
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          modifier: this.modifier,
        }
      })
    }.height('100%')
    .width('100%')
  }
}