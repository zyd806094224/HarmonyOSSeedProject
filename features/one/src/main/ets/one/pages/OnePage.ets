import { HMLifecycleState, HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import {
  ReferenceTabBarInterface,
  ReferenceTabBarItemInterface,
  RouterUrl,
  TabBarOptions,
  TabBarOptionsInterface,
  TabComponent,
  TabController
} from "component";
import { ListTabItemComponent } from "../components/ListTabItemComponent";
import { ListTabType } from "../enums/ListTabType";
import { ListTabItem } from "../model/ListTabItem";
import { CommonList } from "./CommonList";
import { TestPage } from "./TestPage";


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
   * 所有新闻标签项数组
   */
  @Local private tabItems: ListTabItem[] = ListTabItem.getAllListTabItems()
  /**
   * TabBar配置
   */
  @Local private tabBarOptions: TabBarOptionsInterface = new TabBarOptions()
  /**
   * TabController控制器实例
   */
  private _tabController: TabController = new TabController()

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
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        TabComponent({
          index: 0,
          items: this.tabItems,
          tabBarOptions: this.tabBarOptions,
          controller: this._tabController,
          customTabBarItemBuilder: (props) => {
            this.tabBarItemBuilder(props)
          },
          contentBuilder: (props) => {
            this.pageBuilder(props)
          }
        })
      }
    }.width('100%').height('100%') // 设置宽度为 100%
  }

  /**
   * 页面展示时调用。
   */
  @Local private onShow: () => void = () => {
  };
  /**
   * 页面隐藏时调用。
   */
  @Local private onHide: () => void = () => {
  };

  /**
   * 构建每个标签页的内容
   */
  @Builder
  private pageBuilder(props: ReferenceTabBarItemInterface) {
    if (((props.item as ListTabItem).tabType === ListTabType.OneList)) {
      CommonList({
        selectedItemIndex: props.selectedItemIndex,
        currentItemIndex: props.currentItemIndex,
        item: props.item as ListTabItem,
        onShow: this.onShow!!,
        onHide: this.onHide!!
      })
    } else if (((props.item as ListTabItem).tabType === ListTabType.TwoList)) {
      TestPage()
    }
  }

  /**
   * 构建TabBarItem组件
   */
  @Builder
  private tabBarItemBuilder(props: ReferenceTabBarInterface) {
    ListTabItemComponent({
      currentItemIndex: props.currentItemIndex,
      selectedItemIndex: props.selectedItemIndex,
      tabBarOptions: props.tabBarOptions,
      item: props.item as ListTabItem
    })
  }
}