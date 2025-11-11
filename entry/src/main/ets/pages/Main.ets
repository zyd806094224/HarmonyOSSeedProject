import { HMDefaultGlobalAnimator, HMNavigation, HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { AttributeUpdater, uiObserver } from '@kit.ArkUI'
import { Logger, RouterUrl } from 'component'
import { MainConstants } from '../common/MainConstants'
import { MainBottomTab } from '../widget/MainBottomTab'

/**
 * MainNavModifier 类继承了 AttributeUpdater 类，用于更新导航栏属性
 * 它的目的是在初始化时修改导航栏的显示状态
 */
class MainNavModifier extends AttributeUpdater<NavigationAttribute> {
  /**
   * 初始化导航栏属性的修改器
   *
   * @param instance 导航栏属性的实例，通过它来修改导航栏的显示状态
   */
  initializeModifier(instance: NavigationAttribute): void {
    // 隐藏导航栏
    instance.hideNavBar(true)
  }
}

/**
 * 主页实现
 */
@HMRouter({ pageUrl: RouterUrl.MAIN_PAGE_URL })
@Entry
@Component
export struct Main {
  modifier: MainNavModifier = new MainNavModifier()
  private readonly pageTabs: Array<string> = MainConstants.MAIN_TABS_ARRAY;
  /**
   * 记录是否初次显示
   */
  firstShown: boolean = true

  /**
   * 组件即将显示
   */
  aboutToAppear(): void {
    Logger.e("zzz","Main-aboutToAppear")
    // 监听Tab切换, navDestinationSwitch为type类型，非字符串
    uiObserver.on('navDestinationSwitch', this.getUIContext(), {
      navigationId: MainConstants.MAIN_NAVIGATION_ID
    }, (info) => {
      let newPageName = (info.to as NavDestinationInfo).name.toString();
      if (this.pageTabs.includes(newPageName)) {
        AppStorage.setOrCreate('currentPage', newPageName);
      }
    })
  }

  /**
   * 组件即将隐藏
   */
  aboutToDisappear(): void {
    uiObserver.off('navDestinationSwitch', this.getUIContext(), { navigationId: MainConstants.MAIN_NAVIGATION_ID })
  }

  build() {
    Column() {
      HMNavigation({
        navigationId: MainConstants.MAIN_NAVIGATION_ID,
        homePageUrl: this.pageTabs[0], // 默认页面
        // homePageUrl: RouterUrl.ONE_TAB_INDEX_PAGE, // 测试页面
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          modifier: this.modifier
        }
      }).layoutWeight(1)
        .onAppear(() => {
          if (this.firstShown) {
            this.firstShown = false

            // 发送应用初始化完成事件
            this.getUIContext().getHostContext()?.eventHub.emit('initCompleted')
          }
        })

      MainBottomTab()
    }.height('100%')
    .width('100%')
  }
}