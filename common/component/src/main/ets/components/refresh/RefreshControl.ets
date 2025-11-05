import { RefreshFooter } from './RefreshFooter'
import { RefreshHeader } from './RefreshHeader'
import { RefreshState } from './RefreshState'
import { RefreshFooterController } from './RefreshFooterController'
import { RefreshHeaderController } from './RefreshHeaderController'
import { EMPTY_VIEW_LOADING, EMPTY_VIEW_NODATA, EmptyView } from './EmptyView'

/**
 * 刷新控制组件，用于管理下拉刷新和上拉加载更多功能。
 * 该组件结合了头部刷新（RefreshHeader）和尾部加载（RefreshFooter），并提供了相应的控制器来处理刷新逻辑。
 */
@ComponentV2
export struct RefreshControl {
  /**
   * Scroller实例，用于管理滚动行为。
   */
  @Param public scroller: Scroller = new Scroller();
  /**
   * 头部刷新控制器，负责管理下拉刷新的逻辑。
   */
  @Param @Require @Once public headerController: RefreshHeaderController;
  /**
   * 头部刷新构建器，用于自定义头部刷新内容。
   * @param controller - 头部刷新控制器实例。
   */
  @BuilderParam public headerBuilder?: (controller: RefreshHeaderController) => void;
  /**
   * 主体内容构建器，用于构建列表主体内容。
   */
  @BuilderParam public contentBuilder: () => void;
  /**
   * 页面是否有数据。
   */
  @Param public isEmpty?: boolean = undefined;
  /**
   * 空页面构建器，用于构建空页面内容。
   */
  @BuilderParam emptyViewBuilder?: () => void;
  /**
   * 尾部加载控制器，负责管理上拉加载更多的逻辑。
   */
  @Param @Once public footerController?: RefreshFooterController = undefined;
  /**
   * 尾部加载构建器，用于自定义尾部加载内容。
   * @param controller - 尾部加载控制器实例。
   */
  @BuilderParam public footerBuilder?: (controller: RefreshFooterController) => void;
  /**
   * 最大宽度，默认为100%。
   */
  @Param public maxWidth: Length = '100%';
  /**
   * 最大高度，默认为100%。
   */
  @Param public maxHeight: Length = '100%';
  /**
   * 当前最大区域宽度，由onAreaChange事件更新。
   */
  @Local private _maxAreaWidth?: number;
  /**
   * 当前最大区域高度，由onAreaChange事件更新。
   */
  @Local private _maxAreaHeight?: number;
  // 触摸相关属性
  private _touchStartY: number = 0;
  private _lastTouchMoveY: number = 0;
  private _touchMoveY: number = 0;
  private _listYOffsetOld: number = 0;
  private _listYOffsetNew: number = 0;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Up | PanDirection.Down });
  // 初始化
  /*
  * 是否初始化
  */
  private _hasInit: boolean = false

  /**
   * 计算头部可见性状态。
   * @returns {Visibility} 如果头部控制器状态不是Inactive，则返回Visible，否则返回Hidden。
   */
  @Computed
  private get _headerVisibility(): Visibility {
    return this.headerController.state != RefreshState.Inactive ? Visibility.Visible : Visibility.Hidden;
  }

  /**
   * 计算尾部可见性状态。
   * @returns {Visibility} 如果尾部控制器存在且状态不是Inactive，则返回Visible，否则返回Hidden。
   */
  @Computed
  private get _footerVisibility(): Visibility {
    return this.footerController !== undefined && this.footerController.state != RefreshState.Inactive ?
    Visibility.Visible : Visibility.Hidden;
  }

  /**
   * 计算内容高度。
   * @returns {number} 内容高度，考虑了头部和尾部的拖动偏移量。
   */
  @Computed
  private get _contentHeight(): number {
    return Math.max(
      (this._maxAreaHeight !== undefined ? this._maxAreaHeight : 0) - this.headerController.dragOffset -
        (this.footerController !== undefined ? this.footerController.dragOffset : 0), 0);
  }

  /**
   * 检查是否处于活跃状态。
   * @returns {boolean} 如果头部或尾部控制器处于非Inactive状态或活跃状态，则返回true。
   */
  @Computed
  private get _isActive(): boolean {
    return this.headerController.state == RefreshState.Inactive || this.headerController.isActive ||
      (this.footerController !== undefined &&
        (this.footerController.state == RefreshState.Inactive || this.footerController.isActive));
  }

  /**
   * 判断当前是否处于刷新状态。
   * @returns {boolean} 如果headerController的状态是Refresh，则返回true，否则返回false。
   */
  @Computed
  private get _isRefresh(): boolean {
    return this.headerController.state === RefreshState.Refresh;
  }

  /**
   * 组件即将出现时调用。
   */
  aboutToAppear(): void {
    if (this._hasInit) {
      return;
    }
    this._hasInit = true;
    if (this.headerBuilder === undefined) {
      this.headerBuilder = this._headerBuilder;
    }
    if (this.footerController !== undefined && this.footerBuilder === undefined) {
      this.footerBuilder = this._footerBuilder;
    }
    if (this.isEmpty !== undefined && this.emptyViewBuilder === undefined) {
      this.emptyViewBuilder = this._emptyBuilder;
    }
  }

  /**
   * 组件即将消失时调用。
   */
  aboutToDisappear(): void {
  }

  /**
   * 构建UI布局。
   */
  build() {
    Column() {
      // 头部刷新区域
      if (this.headerBuilder !== undefined) {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            this.headerBuilder(this.headerController);
          }.width('100%').height(this.headerController.options.height)
          .visibility(this._headerVisibility);
        }
        .width('100%')
        .height(this.headerController.dragOffset)
        .backgroundColor(this.headerController.options.backgroundColor);
      }

      // 主体列表区域
      Column() {
        Stack() {
          this.contentBuilder();
          if (this.isEmpty !== undefined && this.emptyViewBuilder !== undefined) {
            Column() {
              this.emptyViewBuilder();
            }
            .hitTestBehavior(HitTestMode.None)
            .width('100%').visibility(this.isEmpty ? Visibility.Visible : Visibility.Hidden)
          }
        }.width('100%');
      }
      .width('100%')
      .height(this._contentHeight);

      // 尾部加载区域
      if (this.footerController !== undefined && this.footerBuilder) {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            this.footerBuilder(this.footerController);
          }.width('100%').height(this.footerController.options.height)
          .visibility(this._footerVisibility);
        }
        .width('100%')
        .height(this.footerController.dragOffset)
        .backgroundColor(this.footerController.options.backgroundColor);
      }
    }
    .width(this.maxWidth).height(this.maxHeight)
    .onAreaChange((_: Area, newValue: Area) => {
      this._maxAreaWidth = Math.round(Number(newValue.width).valueOf());
      this._maxAreaHeight = Math.round(Number(newValue.height).valueOf());
    })
    .parallelGesture(
      PanGesture(this.panOption)
        .onActionStart((e) => {
          if (e !== undefined) {
            this._touchStartY = e.offsetY;
            this._lastTouchMoveY = e.offsetY;
          }
        })
        .onActionUpdate((e) => {
          if (e !== undefined) {
            this._onActionUpdate(e);
          }
        })
        .onActionEnd(() => {
          this._onActionEnd();
        })
    );
  }

  /**
   * 默认空页面构建器，用于在无数据时展示空视图。
   */
  @Builder
  private _emptyBuilder() {
    EmptyView({
      status: this._isRefresh ? EMPTY_VIEW_LOADING : EMPTY_VIEW_NODATA,
      hitTestMode: HitTestMode.None,
      onTapped: () => {
        this.headerController.beginRefreshing();
      }
    });
  }

  /**
   * 默认头部刷新构建器。
   * @param controller - 头部刷新控制器实例。
   */
  @Builder
  private _headerBuilder(controller: RefreshHeaderController) {
    RefreshHeader({ controller: controller });
  }

  /**
   * 默认尾部加载构建器。
   * @param controller - 尾部加载控制器实例。
   */
  @Builder
  private _footerBuilder(controller: RefreshFooterController) {
    RefreshFooter({ controller: controller });
  }

  /**
   * 处理手势更新事件。
   * @param event - 手势事件对象。
   */
  private _onActionUpdate(event: GestureEvent) {
    if (!this._isActive) {
      return;
    }
    const scrollerOffset = this.scroller.currentOffset();
    if (!scrollerOffset) {
      return;
    }
    this._touchMoveY = event.offsetY;
    const moveDistanceY = this._touchMoveY - this._lastTouchMoveY;
    const dragOffsetY = this._touchMoveY - this._touchStartY;
    const isHeaderAction = moveDistanceY > 0;
    const isFooterAction = moveDistanceY < 0;
    const yOffset = scrollerOffset.yOffset;
    const isMoveToTop = Math.abs(yOffset) < 0.001;
    this._listYOffsetNew = scrollerOffset.yOffset;

    if ((this.footerController !== undefined ? !this.footerController.isRefreshing : true) &&
      ((this.headerController.isInactive && isMoveToTop && isHeaderAction) ||
      this.headerController.isActive)) {
      // RefreshHeader处于非活跃状态、列表处于顶部位置、当前手势是下拉手势
      // RefreshHeader处于活跃状态
      // 此时处理RefreshHeader处于活跃状态刷新
      // 防止下拉回滑时list组件底层跟着滑动
      if (moveDistanceY < 0) {
        this.scroller.scrollTo({ xOffset: 0, yOffset: 0 });
      }
      this.headerController.onMoveUpdate(dragOffsetY);
    } else if (this.footerController !== undefined && !this.headerController.isRefreshing &&
      ((this.footerController.isInactive && this.scroller.isAtEnd() && isFooterAction) ||
      this.footerController.isActive)) {
      // 列表处于底部位置且上滑时、已上滑时
      this.footerController.onMoveUpdate(-dragOffsetY);
    }
    this._listYOffsetOld = this._listYOffsetNew;
    this._lastTouchMoveY = this._touchMoveY;
  };

  /**
   * 处理手势结束事件。
   */
  private _onActionEnd() {
    if (this.headerController.options.isRestoreAfterRefresh && this.headerController.isActive) {
      this.scroller.scrollEdge(Edge.Top);
    } else if (this.footerController != undefined && this.footerController.options.isRestoreAfterRefresh &&
    this.footerController.isActive) {
      this.scroller.scrollEdge(Edge.Bottom);
    }
    if (this.headerController.isDragging) {
      this.headerController.onMoveEnd();
    } else if (this.footerController !== undefined && this.footerController.isDragging) {
      this.footerController.onMoveEnd();
    }
  }
}
