import { HMRouterMgr } from "@hadss/hmrouter";
import { CommonConstants, RefreshControl, RouterUrl } from "component";
import { CommonListAdItem } from "../components/CommonListAdItem";
import { CommonListNewsItem } from "../components/CommonListNewsItem";
import { CommonListBasicModel, CommonListType, CommonNewsAdModel, CommonNewsModel } from "../model/CommonListModel";
import { ListTabItem } from "../model/ListTabItem";
import { CommonListViewModel } from "../viewmodel/CommonListViewModel";


@ComponentV2
export struct CommonList {
  /**
   * 当前显示的 TabBarItem 的索引
   */
  @Param @Require currentItemIndex: number;
  /**
   * 用户选中的 TabBarItem 的索引
   */
  @Param @Require selectedItemIndex: number;
  /**
   * 当前的 ListTabItem 对象
   */
  @Param @Require item: ListTabItem;
  /**
   * 页面展示时调用
   */
  @Param @Require onShow: () => void;
  /**
   * 页面展示时调用双向绑定
   */
  @Event $onShow: (onShow: () => void) => void;
  /**
   * 页面隐藏时调用
   */
  @Param @Require onHide: () => void;
  /**
   * 页面隐藏时调用双向绑定
   */
  @Event $onHide: (onHide: () => void) => void;
  /**
   * 列表滚动控制器，用于管理列表滚动行为
   */
  private _listScroller: Scroller = new Scroller();
  /**
   * 是否首次刷新
   */
  private _firstRefreshing: boolean = true
  /**
   * 是否已经初始化
   */
  private _hasInit: boolean = false;

  /**
   * 当前的 ViewModel 对象
   */
  @Computed
  private get _viewModel(): CommonListViewModel {
    return new CommonListViewModel(this.item.tabType);
  }

  /**
   * 是否选中
   */
  @Computed
  private get isSelected(): boolean {
    return this.selectedItemIndex === this.currentItemIndex
  }

  aboutToAppear(): void {
    if (!this._hasInit) {
      this._hasInit = true
    }
    if (this.isSelected) {
      this._bindShowAndHideWithFirstRefresh()
    }
  }

  build() {
    RefreshControl({
      scroller: this._listScroller,
      isEmpty: this._viewModel.isEmpty,
      headerController: this._viewModel.headerController,
      footerController: this._viewModel.footerController,
      maxWidth: '100%',
      maxHeight: '100%',
      contentBuilder: () => {
        this._getListView();
      }
    })
  }

  /**
   * 构建列表视图。
   */
  @Builder
  private _getListView() {
    List({ scroller: this._listScroller }) {
      LazyForEach(this._viewModel.dataSource, (item: CommonListBasicModel, index: number) => {
        ListItem() {
          if (item.getNewsType() === CommonListType.Ad) {
            CommonListAdItem({ model: item as CommonNewsAdModel })
          } else {
            CommonListNewsItem({ model: item as CommonNewsModel })
          }
        }.onClick(e => {
          if (item.getNewsType() === CommonListType.Ad) {
            const skipUrl = RouterUrl.WEB_PAGE_URL
            HMRouterMgr.push({
              navigationId: CommonConstants.LAUNCHER_NAVIGATION_ID,
              pageUrl: skipUrl,
              param: {
                url: 'http://106.15.7.132:3000/',
                title: '测试标题'
              }
            })
          } else {
            HMRouterMgr.push({
              navigationId: CommonConstants.LAUNCHER_NAVIGATION_ID,
              pageUrl: RouterUrl.WEB_PAGE_URL,
              param: {
                url: 'http://106.15.7.132:3000/',
                title: '测试标题'
              }
            })
          }
        })
      }, (item: CommonListBasicModel, index: number) => item.getIdentify())
    }
    .divider({
      strokeWidth: 0.5,
      color: '#E8E8E8',
      startMargin: 15,
      endMargin: 15
    })
    .width('100%')
    .height('100%') // 设置列表宽度和高度
    .edgeEffect(EdgeEffect.None);
  }

  /**
   * 绑定页面显示和隐藏事件，并确保在第一次刷新时触发。
   */
  private _bindShowAndHideWithFirstRefresh(): void {
    this.$onShow(() => {
      this.onPageShow()
    })
    this.$onHide(() => {
      this.onPageHide()
    })
    if (this._firstRefreshing) {
      this._viewModel.headerController.beginRefreshing();
      this._firstRefreshing = false
    }
  }

  /**
   * 页面显示时调用
   */
  onPageShow(): void {
    if (this._firstRefreshing) {
      this._viewModel.headerController.beginRefreshing();
      this._firstRefreshing = false
    }
  }

  /**
   * 页面隐藏时调用
   */
  onPageHide(): void {
  }
}