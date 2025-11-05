import { HandleTouchCallBack, TabBarController } from './TabBarController'
import { ReferenceTabBarItemInterface, TabBarItemInterface } from './TabBarItem'
import { _TabBarItemAttribute } from './TabBarItemAttribute'
import {
  IndicatorAnimationType,
  IndicatorPosition,
  IndicatorPosition2Align,
  TabBarItemDistributionType,
  TabBarItemDistributionType2FlexAlign,
  TabBarOptions,
  TabBarOptionsInterface
} from './TabBarOptions'
import { display } from '@kit.ArkUI'
import { ReferenceTabBarIndicatorInterface, ReferenceTabBarInterface } from './ReferenceTabBarInterface'
import { TabDataSource } from './TabDataSource'
import { Logger } from '../../utils/Logger'
import { TabBarItemComponent } from './TabBarItemComponent'
import { AnyType } from '../../AnyType'

/**
 * TabBarComponent 是一个用于创建和管理标签栏的组件。
 * 它支持自定义选项、指示器样式、事件处理等功能。
 */
@ComponentV2
export struct TabBarComponent {
  /**
   * 数据源，用于获取 TabBarItem 数据。
   * @param _dataSource 数据源，默认为空。
   */
  @Param _dataSource: TabDataSource = new TabDataSource()
  /**
   * 选中项的索引。
   * @param index 当前选中的标签项索引。
   */
  @Param @Require index: number
  /**
   * 标签项数组。
   * @param items 标签项数组。
   */
  @Param @Require items: TabBarItemInterface[]
  /**
   * 标签栏配置选项。
   * @param tabBarOptions 标签栏配置选项。
   */
  @Param @Require tabBarOptions: TabBarOptionsInterface
  /**
   * TabBarController 实例，用于控制 TabBar 的行为。
   */
  @Param @Require controller?: TabBarController
  /**
   * 选中项改变时的回调函数。
   * @param onSelectItem 回调函数，参数为选中的 TabBarItemInterface 和索引。
   */
  @Param @Require onSelectItem?: (item: TabBarItemInterface, index: number) => void
  // 控制器
  /**
   * TabBar 滚动到边缘时的回调函数。
   * @param onScrollEdge 回调函数，参数为滚动的边缘位置。
   */
  @Param @Require onScrollEdge?: (side: Edge) => void
  /**
   * 初始化数据完成后的回调函数。
   * @param onInitData 回调函数，无参数。
   */
  @Param @Require onInitData?: () => void
  /**
   * 自定义 TabBarItem 视图的构建器。
   * @param customTabBarItemBuilder 构建器函数，参数为 ReferenceTabBarInterface。
   */
  @BuilderParam customTabBarItemBuilder?: (props: ReferenceTabBarInterface) => void
  /**
   * 自定义 Indicator 视图的构建器。
   * @param customIndicatorBuilder 构建器函数，参数为 ReferenceTabBarIndicatorInterface。
   */
  @BuilderParam customIndicatorBuilder?: (props: ReferenceTabBarIndicatorInterface) => void
  /**
   * 左边附加视图的构建器。
   * @param leftItemBuilder 构建器函数，无参数。
   */
  @BuilderParam leftItemBuilder?: () => void
  /**
   * 右边附加视图的构建器。
   * @param rightItemBuilder 构建器函数，无参数。
   */
  @BuilderParam rightItemBuilder?: () => void
  /**
   * 双向绑定处理，用于更新 index。
   */
  @Event $index: (index: number) => void
  /**
   * 双向绑定处理，用于更新 items。
   */
  @Event $items: (items: TabBarItemInterface[]) => void
  /**
   * 双向绑定处理，用于更新 tabBarOptions。
   */
  @Event $tabBarOptions: (tabBarOptions: TabBarOptionsInterface) => void
  /**
   * 标记 TabBar 的位置是否已经初始化。
   */
  @Local private _hasInitTabPos: boolean = false
  /**
   * 指示器宽度。
   * @param _indicatorWidth 指示器宽度，默认值为20。
   */
  @Local private _indicatorWidth: number = 20
  /**
   * 指示器高度。
   * @param _indicatorHeight 指示器高度，默认值为4。
   */
  @Local private _indicatorHeight: number = 4
  /**
   * 指示器的实际宽度
   */
  @Local private _indicatorActualWidth: number = 20
  /**
   * 指示器的实际高度
   */
  @Local private _indicatorActualHeight?: Length
  /**
   * 指示器的 X 轴偏移量，用于对齐选中的 TabBarItem 的中心。
   */
  @Local private _indicatorOffsetX: number = 0
  /**
   * 下一个选中项的索引。
   */
  @Local private _nextIndex: number = 0
  /**
   * 指示器的临时 X 轴偏移量，用于在触摸移动过程中计算新的偏移量。
   */
  private _tempIndicatorOffsetX: number = 0
  /**
   * Scroll 容器的高度。
   */
  @Local private _scrollHeight: Length = 0
  /**
   * Scroll 容器的宽度。
   */
  @Local private _scrollWidth: number = 0
  /**
   * Scroll 容器内容宽度
   */
  @Local private _scrollContentWidth: number = 0
  /**
   * Scroller 实例，用于处理滚动事件。
   */
  private _scroller: Scroller = new Scroller()
  /**
   * 存储每个 TabBarItem 的属性，包括位置和大小。
   */
  private _attrs: Map<number, _TabBarItemAttribute> = new Map()
  /**
   * 标记组件是否已经初始化。
   */
  private _hasInit: boolean = false
  /**
   * 标记数据是否已经初始化。
   */
  private _hasInitData: boolean = false
  /**
   * TabBar 内容的宽度，用于指示器联动时判断手势滑动距离的百分比，默认为屏幕宽度。
   */
  private _tabContentWidth: number = px2vp(display.getDefaultDisplaySync().width)
  /**
   * 记录触摸开始时的 X 坐标。
   */
  private _moveStartX: number = 0
  /**
   * 记录触摸开始时的时间戳。
   */
  private _moveStartTime: number = 0
  /**
   * 记录触摸结束时的时间戳。
   */
  private _moveEndTime: number = 0

  /**
   * 是否与item高度一致, 只有在 IndicatorPosition.Center 模式下支持。
   */
  @Computed
  private get _isSameHeightWithItem(): boolean {
    return this.tabBarOptions.indicatorOptions.position === IndicatorPosition.Center &&
      this.tabBarOptions.indicatorOptions.isSameHeightWithItem === true
  }

  /*
   * 最大可配置scroll offset x偏移量
   * @returns {number} 最大可配置scroll offset x偏移量
   */
  @Computed
  private get _maxScrollXOffset(): number {
    return Math.max(0,
      this._scrollContentWidth + this._contentMarginLeft + this._contentMarginRight - this._scrollWidth)
  }

  /**
   * 计算滚动视图的左侧padding
   * @returns {number} 计算后的滚动视图的左侧padding
   */
  @Computed
  private get _contentMarginLeft(): number {
    return Number(this.tabBarOptions.contentMargin?.left ?? 0).valueOf()
  }

  /**
   * 计算滚动视图的右侧padding
   * @returns {number} 计算后的滚动视图的右侧padding
   */
  @Computed
  private get _contentMarginRight(): number {
    return Number(this.tabBarOptions.contentMargin?.right ?? 0).valueOf()
  }

  /**
   * 组件即将出现时的生命周期方法。
   * 初始化数据和处理相关逻辑。
   */
  aboutToAppear(): void {
    if (this._hasInit) {
      return
    }
    this._hasInit = true
    if (!this._hasInitData) {
      this._initData()
    }
  }

  /**
   * 构建组件的UI结构。
   * 包含左侧附加视图、滚动视图、右侧附加视图等。
   */
  build() {
    Row() {
      // 左侧附加视图
      if (this.leftItemBuilder !== undefined && this.tabBarOptions.leftItemOptions.isFixed) {
        Column() {
          this.leftItemBuilder()
        }
        .height(this.tabBarOptions.leftItemOptions.isSameHeightWithTabBar ? this._scrollHeight : null)
        .visibility(this.tabBarOptions.leftItemOptions.isHide ? Visibility.None : Visibility.Visible)
        .layoutWeight(this.tabBarOptions.isWidthFillParent ? 0 : 1)
      }

      // tabContent
      Scroll(this._scroller) {
        this._tabBarScrollContentBuilder()
      }
      .backgroundColor(this.tabBarOptions.backgroundColor)
      .scrollBar(BarState.Off)
      .scrollable(this.tabBarOptions.scrollable)
      .width(this.tabBarOptions.isWidthFillParent ? '100%' : null)
      .layoutWeight(this.tabBarOptions.isWidthFillParent ? 1 : 0)
      .align(this.tabBarOptions.itemAlign) // 这里控制item的位置，比如居左居右
      .edgeEffect(this.tabBarOptions.edgeEffect)
      .padding(this.tabBarOptions.contentMargin)
      .border(this.tabBarOptions.border)
      .onAreaChange((oldArea: Area, newArea: Area) => {
        this._handleScrollAreaChanged(oldArea, newArea)
      })
      .onScrollEdge((side: Edge) => {
        if (this.onScrollEdge) {
          this.onScrollEdge(side)
        }
      })

      // 右侧附加视图
      if (this.rightItemBuilder !== undefined && this.tabBarOptions.rightItemOptions.isFixed) {
        Column() {
          this.rightItemBuilder()
        }
        .height(this.tabBarOptions.rightItemOptions.isSameHeightWithTabBar ? this._scrollHeight : null)
        .visibility(this.tabBarOptions.rightItemOptions.isHide ? Visibility.None : Visibility.Visible)
        .layoutWeight(this.tabBarOptions.isWidthFillParent ? 0 : 1)
      }
    }
    .alignItems(this.tabBarOptions.verticalAlign) // scroll垂直方向对齐设置
  }

  /**
   * 同步标签内容的宽度。
   * @param width 标签内容的宽度。
   */
  _syncTabContentWidth(width: number) {
    this._tabContentWidth = width
  }

  /**
   * 处理触摸事件。
   * 根据触摸事件更新指示器的位置和宽度。
   * @param event 触摸事件。
   * @param currentIndex 当前选中的标签项索引。
   * @param duration 动画持续时间。
   * @param onMove 移动事件回调函数。
   */

  _handleTouch(event: TouchEvent, currentIndex: number,
    duration: number | undefined = this.tabBarOptions.itemOptions.animationDuration,
    callBack: HandleTouchCallBack | undefined) {
    const notAction = this.tabBarOptions.indicatorOptions.animationType !== IndicatorAnimationType.Linkage ||
      !this.tabBarOptions.tabContentScrollable;
    if (notAction && callBack === undefined) {
      return
    }
    // 记录手指触摸的位置和时间，用于计算手指滑动的偏移量和滑动时间。
    let startX = this._moveStartX
    let offset = 0
    if (event.type === TouchType.Down) {
      this._moveStartX = event.touches[0].x
      this._moveStartTime = Date.now()
    }
    // 手指滑动过程中更新指示器位置和宽度
    if (event.type === TouchType.Move) {
      offset = event.touches[0].x - startX
      if ((offset >= 0 && currentIndex > 0) || (offset <= 0 && currentIndex < this.items.length - 1)) {
        const isMoveToLeft: boolean = offset > 0
        const nextIndex = isMoveToLeft ? currentIndex - 1 : currentIndex + 1
        this._nextIndex = nextIndex
        const nextAttr = this.getItemAttr(nextIndex)
        const currentAttr = this.getItemAttr(currentIndex)
        if (nextAttr !== undefined && currentAttr !== undefined) {
          // 计算滚动百分比, 更新指示器位置
          let movePercentage = Math.abs(offset) / this._tabContentWidth
          movePercentage = Math.min(movePercentage, 1)
          if (callBack !== undefined) {
            callBack(this.items[currentIndex], currentIndex, nextIndex, movePercentage);
          }
          const subIndicatorOffsetX = nextAttr.minX - currentAttr.midX
          if (!notAction) {
            this._indicatorOffsetX = this._tempIndicatorOffsetX + subIndicatorOffsetX * movePercentage
            // 更新指示器宽度
            if (this.tabBarOptions.indicatorOptions.isSameWidthWithItem) {
              this._indicatorWidth = currentAttr.width + (nextAttr.width - currentAttr.width) * movePercentage
            }
          }
        }
      }
    }

    // 手指抬起来时根据滑动的距离和手指接触的时间判断是否要滚动到下一个item。
    if (event.type === TouchType.Up) {
      this._moveEndTime = Date.now()
      let touchDuration = this._moveEndTime - this._moveStartTime
      let offset = event.touches[0].x - startX
      this._moveStartX = 0
      this._moveStartTime = 0
      this._moveEndTime = 0
      if (touchDuration <= 500) {
        // 手指滑动距离30存在误差，可能30时并没有成功切换到下一个item, 不过这种误差在UI上是指示器向反方向偏移了一点，然后滚动到正确的位置上，是可以接受的。
        if (!notAction && Math.abs(offset) >= 30) {
          const nextIndex = this.index + (offset > 0 ? -1 : 1)
          if (nextIndex >= 0 && nextIndex <= this._dataSource.totalCount() - 1) {
            this._scrollIndicatorTo(nextIndex, duration)
          }
        }
      }
    }
  }

  /// CRUD Actions

  /**
   * 选择指定索引的标签项。
   * @param atIndex 要选择的标签项索引。
   * @param duration 动画持续时间。
   */
  _selectItem(atIndex: number, duration: number | undefined = this.tabBarOptions.itemOptions.animationDuration) {
    if (!this._isValidIndex(atIndex)) {
      Logger.e(`TabBarComponent`, `selectItem: index ${atIndex} out of range`)
      return
    }
    this._syncIndex(atIndex)
    this._scrollIndicatorTo(atIndex, duration)
    // 改善指示器滚动过程中抖动问题
    this._delay(150, () => {
      this._scrollItemTo(atIndex, duration)
    })
  }

  /**
   * 设置标签项列表。
   * @param newItems 新的标签项列表。
   * @param selectIndex 要选择的标签项索引。
   */
  _setItems(newItems: TabBarItemInterface[], selectIndex: number = this.index) {
    // 替换所有items时需要先替换TabBar的,接着在重新与dataSource绑定.
    this._syncItems(newItems)
    this._dataSource.setItems(newItems)
    let defaultIndex = selectIndex < this._dataSource.totalCount() ? Math.max(selectIndex, 0) : 0
    this._delay(200, () => {
      this._selectItem(defaultIndex)
    })
  }

  /**
   * 更新指定索引的标签项。
   * @param atIndex 要更新的标签项索引。
   * @param item 新的标签项。
   */
  _update(atIndex: number, item: TabBarItemInterface) {
    if (!this._isValidIndex(atIndex)) {
      Logger.e(`TabBarComponent`, `update: atIndex ${atIndex} out of range`)
      return
    }
    this._dataSource.update(atIndex, item)
    // 需要触发滚动指示器,以修复指示器不居中问题.
    this._delay(100, () => {
      this._selectItem(atIndex)
    })
  }

  /**
   * 在标签栏末尾添加新的标签项。
   * @param items 要添加的标签项数组。
   * @returns 新的标签项数量。
   */
  _push(...items: TabBarItemInterface[]): number {
    let newLength = this._dataSource.push(...items)
    // 在tabBar末尾添加完新item之后执行一次选中当前的item，以使被选中的item更新滚动位置。
    this._selectItem(this.index)
    return newLength
  }

  /**
   * 在指定索引插入新的标签项。
   * @param atIndex 插入位置的索引。
   * @param item 要插入的标签项。
   */
  _insert(atIndex: number, item: TabBarItemInterface) {
    if (atIndex < 0 || atIndex > this._dataSource.totalCount()) {
      Logger.e(`TabBarComponent`, `insert: atIndex ${atIndex} out of range`)
      return
    }
    this._dataSource.insert(atIndex, item)
    if (atIndex <= this.index) {
      this._selectItem(this.index + 1)
    }
    this._delay(200, () => {
      this._scrollIndicatorTo(this.index)
    })
  }

  /**
   * 删除指定索引的标签项。
   * @param atIndex 要删除的标签项索引。
   * @returns 被删除的标签项。
   */
  _delete(atIndex: number): TabBarItemInterface | undefined {
    if (!this._isValidIndex(atIndex)) {
      Logger.e(`TabBarComponent`, `delete: atIndex ${atIndex} out of range`)
      return undefined
    }
    let hasChangeIndex: boolean = atIndex <= this.index
    if (atIndex < this.index) {
      this._syncIndex(this.index - 1)
    } else if (atIndex === this.index) {
      // 如果删除的是当前选中的item,则默认重新选中第一个item。
      this._syncIndex(0)
    }
    let deletedItems = this._dataSource.delete(atIndex)
    this._delay(200, () => {
      this._scrollIndicatorTo(this.index)
      if (hasChangeIndex) {
        this._selectItem(this.index)
        if (this.onSelectItem) {
          let selectedItem = this._getItem(this.index)
          if (selectedItem) {
            this.onSelectItem(selectedItem, this.index)
          }
        }
      }
    })
    return deletedItems.length > 0 ? deletedItems[0] : undefined
  }

  /**
   * 获取指定索引的标签项。
   * @param atIndex 标签项的索引。
   * @returns 标签项。
   */
  _getItem(atIndex: number): TabBarItemInterface | undefined {
    if (!this._isValidIndex(atIndex)) {
      Logger.e(`TabBarComponent`, `getItem: atIndex ${atIndex} out of range`)
      return undefined
    }
    return this._dataSource.getData(atIndex)
  }

  /**
   * 根据条件查找标签项的索引。
   * @param predicate 查找条件。
   * @param thisArg 可选的 this 上下文。
   * @returns 标签项的索引。
   */
  _findIndex(
    predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType
  ): number {
    return this._dataSource.findIndex(predicate, thisArg)
  }

  // 双向同步设置

  /**
   * 根据条件查找标签项。
   * @param predicate 查找条件。
   * @param thisArg 可选的 this 上下文。
   * @returns 标签项。
   */
  _find(
    predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType
  ): TabBarItemInterface | undefined {
    return this._dataSource.find(predicate, thisArg)
  }

  /**
   * 同步索引。
   * @param newIndex 新的选中索引。
   */
  private _syncIndex(newIndex: number) {
    this.$index(newIndex)
  }

  /**
   * 同步 items。
   * @param newItems 新的items。
   */
  private _syncItems(newItems: TabBarItemInterface[]) {
    this.$items(newItems)
  }

  /**
   * 同步 tabBarOptions。
   * @param newTabBarOptions 新的tabBarOptions。
   */
  private _sysTabBarOptions(newTabBarOptions: TabBarOptionsInterface) {
    this.$tabBarOptions(newTabBarOptions)
  }

  /// Builder

  /**
   * 初始化数据。
   */
  private _initData() {
    // TabComponent已经限制了this.index 这里已经是安全的不再处理
    // this._syncIndex(this.index)
    // 绑定数据源
    this._dataSource.setItems(this.items)
    if (this.tabBarOptions === undefined) {
      this._sysTabBarOptions(new TabBarOptions())
    }
    this._indicatorWidth = this.tabBarOptions.indicatorOptions.width ?? 20
    this._indicatorHeight = this.tabBarOptions.indicatorOptions.height ?? 4
    this._hasInitData = true
    this._nextIndex = this.index

    if (this.controller !== undefined) {
      this.controller._bind(this)
    }
    if (this.tabBarOptions.indicatorOptions.position == IndicatorPosition.Center) {
      let tabBarOptions = this.tabBarOptions
      tabBarOptions.indicatorOptions.margin = {
        top: 0,
        bottom: 0,
        left: 0,
        right: 0
      }
      this._sysTabBarOptions(tabBarOptions)
    }
    if (this.onInitData !== undefined) {
      this.onInitData()
    }
  }

  /**
   * 在scroll中构建左侧附加视图。
   */
  @Builder
  private _scrollLeftItemBuilder() {
    if (this.leftItemBuilder !== undefined && !this.tabBarOptions.leftItemOptions.isFixed) {
      Column() {
        this.leftItemBuilder()
      }
      .height(this.tabBarOptions.leftItemOptions.isSameHeightWithTabBar ? this._scrollHeight : null)
      .visibility(this.tabBarOptions.leftItemOptions.isHide ? Visibility.None : Visibility.Visible)
    }
  }

  /**
   * 在scroll中构建右侧附加视图。
   */
  @Builder
  private _scrollRightItemBuilder() {
    if (this.rightItemBuilder !== undefined && !this.tabBarOptions.rightItemOptions.isFixed) {
      Column() {
        this.rightItemBuilder()
      }
      .height(this.tabBarOptions.rightItemOptions.isSameHeightWithTabBar ? this._scrollHeight : null)
      .visibility(this.tabBarOptions.rightItemOptions.isHide ? Visibility.None : Visibility.Visible)
    }
  }

  /**
   * 构建内容。
   */
  @Builder
  private _tabBarScrollContentBuilder() {
    Stack({ alignContent: IndicatorPosition2Align(this.tabBarOptions.indicatorOptions.position) }) {
      // 底部居中堆叠
      if (this.tabBarOptions.indicatorOptions.position === IndicatorPosition.Center) {
        this._tabBarIndicatorBuilder()
      }
      this._tabBarItemContentBuilder()
      // 指示器在item顶部底部
      if (this.tabBarOptions.indicatorOptions.position !== IndicatorPosition.Center) {
        this._tabBarIndicatorBuilder()
      }
    }.onAreaChange((oldArea, newArea) => {
      if (oldArea.width !== newArea.width) {
        this._scrollContentWidth = Number(newArea.width).valueOf()
      }
    })
  }

  /**
   * 构建内容 tabBarItem。
   */
  @Builder
  private _tabBarItemContentBuilder() {
    Row({ space: this.tabBarOptions.itemSpace }) {
      // 左侧附加视图
      this._scrollLeftItemBuilder()
      // tabBarItem
      ForEach(this.items, (item: TabBarItemInterface, index: number) => {
        this._tabBarItemBuilder({ currentItemIndex: index, selectedItemIndex: this.index, item: item })
      }, (_: TabBarItemInterface, index: number) => this._dataSource.identifier(index))
      // 右侧附加视图
      this._scrollRightItemBuilder()
    }
    .constraintSize({
      minWidth: this.tabBarOptions.itemDistributionType === TabBarItemDistributionType.None ? null : '100%'
    })
    .justifyContent(TabBarItemDistributionType2FlexAlign(this.tabBarOptions.itemDistributionType))
  }

  /**
   * 构建指示器。
   */
  @Builder
  private _tabBarIndicatorBuilder() {
    if (!this.tabBarOptions.indicatorOptions.isHide && this._hasInitTabPos && this.items.length > 0) {
      Column() {
        Row() {
          if (this.customIndicatorBuilder !== undefined) {
            // 自定义指示器
            Column() {
              this.customIndicatorBuilder({
                nextItemIndex: this._nextIndex,
                selectedItemIndex: this.index,
                tabBarOptions: this.tabBarOptions,
                indicatorWidth: this._indicatorWidth,
                indicatorHeight: this._indicatorHeight,
              })
            }
            .margin(this.tabBarOptions.indicatorOptions.margin)
          } else {
            Row() {
              Text('')
                .height(this._indicatorHeight)
                .border(this.tabBarOptions.indicatorOptions.border)
                .margin(this.tabBarOptions.indicatorOptions.margin)
                .backgroundColor(this.tabBarOptions.indicatorOptions.color)
                .flexGrow(1)
            }.width(this._indicatorWidth)
          }
        }
      }
      .offset({
        x: this._indicatorOffsetX - this._indicatorActualWidth / 2,
        y: 0
      }) /// 这里控制indicator的位置, indicatorOffsetX的值为被选中的item的centerX
      .clip(false)
      .backgroundColor(Color.Transparent)
      .onAreaChange((_, newArea) => {
        const width = Number(newArea.width).valueOf()
        if (this._indicatorActualWidth != width) {
          this._indicatorActualWidth = width
        }
        if (this._indicatorActualHeight !== newArea.height) {
          this._indicatorActualHeight = newArea.height
        }
      })
    }
  }

  /// 尺寸位置变化监听

  /**
   * 构建标签项内容的UI结构。
   * @param props 标签项引用接口。
   */
  @Builder
  private _tabBarItemBuilder(props: ReferenceTabBarItemInterface) {
    Column() {
      // 指示器在item顶部
      if (this.tabBarOptions.indicatorOptions.position === IndicatorPosition.Top &&
        this._indicatorActualHeight !== undefined) {
        // 空占位
        Text('').width(0).height(this._indicatorActualHeight)
      }
      TabBarItemComponent({
        selectedItemIndex: props.selectedItemIndex,
        currentItemIndex: props.currentItemIndex,
        tabBarOptions: this.tabBarOptions,
        item: props.item,
        customItemBuilder: this.customTabBarItemBuilder
      })
      // 指示器在item底部
      if (this.tabBarOptions.indicatorOptions.position === IndicatorPosition.Bottom &&
        this._indicatorActualHeight !== undefined) {
        // 空占位
        Text('').width(0).height(this._indicatorActualHeight)
      }
    }
    .onAreaChange((_, newArea) => {
      this._handleTabBarItemAreaChange(props.currentItemIndex, newArea)
    })
    .onClick(() => {
      this._selectItem(props.currentItemIndex)
      if (this.onSelectItem !== undefined) {
        this.onSelectItem(props.item, props.currentItemIndex)
      }
    })
  }

  /**
   * 处理标签项的尺寸位置变化。
   * @param ofIndex 标签项的索引。
   * @param newArea 新的尺寸位置信息。
   */
  private _handleTabBarItemAreaChange(ofIndex: number, newArea: Area) {
    // 更新保存所有item的position
    const attr = new _TabBarItemAttribute(newArea)
    this._attrs.set(ofIndex, attr)
    // 第一次加载出来滚动到默认选中的item位置
    if (!this._hasInitTabPos && this.index === ofIndex) {
      this._indicatorOffsetX = attr.midX
      if (this.tabBarOptions.indicatorOptions.isSameWidthWithItem) {
        this._indicatorWidth = attr.width
      }
      if (this.tabBarOptions.indicatorOptions.isSameHeightWithItem) {
        this._indicatorHeight = attr.height
      }
      this._hasInitTabPos = true
      this._scrollItemTo(this.index)
    }
    if (this.index === ofIndex) {
      this._scrollIndicatorTo(this.index)
    }
  }

  /**
   * 处理滚动视图的尺寸位置变化。
   * @param oldArea 旧的尺寸位置信息。
   * @param newArea 新的尺寸位置信息。
   */
  private _handleScrollAreaChanged(oldArea: Area, newArea: Area) {
    if (oldArea.height !== newArea.height) {
      this._scrollHeight = newArea.height
    }
    if (oldArea.width !== newArea.width) {
      this._scrollWidth = Number(newArea.width).valueOf()
      if (this.tabBarOptions.shouldScrollToCurrentIndexWhenWidthChanged) {
        let selectedIndexAttr = this._attrs.get(this.index)
        // 如果当前选中的item已经可见则不需要滚动item的位置
        if (selectedIndexAttr !== undefined) {
          let x = selectedIndexAttr.minX
          if (!(x >= this._contentMarginLeft &&
            selectedIndexAttr.maxX <= this._scrollWidth - this._contentMarginRight)) {
            this._delay(500, () => {
              this._scrollItemTo(this.index)
            })
          }
        }
      }
    }
  }

  /**
   * 延时执行操作。
   * @param duration 延时时间。
   * @param handler 回调函数。
   */
  private _delay(duration: number, handler: () => void) {
    new Promise<void>((resolve, _) => {
      setTimeout(() => {
        resolve()
      }, duration)
    })
      .then(() => {
        handler()
      })
  }

  /**
   * 检查索引是否有效。
   * @param index 索引。
   * @returns 是否有效。
   */
  private _isValidIndex(index: number): boolean {
    return index >= 0 && index <= this._dataSource.totalCount() - 1
  }

  /**
   * 获取标签项的属性。
   * @param index 标签项的索引。
   * @returns 标签项的属性。
   */
  private getItemAttr(index: number): _TabBarItemAttribute | undefined {
    if (index >= this._attrs.size) {
      return undefined
    }
    return this._attrs.get(index)
  }

  /// Scroll

  /**
   * 滚动指示器到指定索引。
   * @param newIndex 新的索引。
   * @param duration 动画持续时间。
   */
  private _scrollIndicatorTo(newIndex: number,
    duration: number | undefined = this.tabBarOptions.itemOptions.animationDuration) {
    if (!this._isValidIndex(newIndex)) {
      Logger.e(`TabBarComponent`, `_scrollIndicatorTo: newIndex ${newIndex} out of range`)
      return
    }
    this._nextIndex = newIndex
    const nextAttr = this.getItemAttr(newIndex)
    if (nextAttr != undefined) {
      let nextOffsetX = nextAttr.midX
      this._tempIndicatorOffsetX = nextOffsetX
      const nextWidth = nextAttr.width
      const nextHeight = nextAttr.height
      const isOffsetXChange = this._indicatorOffsetX !== nextOffsetX
      const isWidthChange =
        this.tabBarOptions.indicatorOptions.isSameWidthWithItem && nextWidth !== this._indicatorWidth
      const isHeightChange = this._isSameHeightWithItem && nextHeight !== this._indicatorHeight
      animateTo({ duration: duration, curve: Curve.Linear }, () => {
        if (isOffsetXChange) {
          this._indicatorOffsetX = nextOffsetX
        }
        if (isWidthChange) {
          this._indicatorWidth = nextWidth
        }
        if (isHeightChange) {
          this._indicatorHeight = nextHeight
        }
      })
    }
  }

  /**
   * 滚动标签项到指定索引。
   * @param index 索引。
   * @param duration 动画持续时间。
   */
  private _scrollItemTo(index: number,
    duration: number | undefined = this.tabBarOptions.itemOptions.animationDuration) {
    if (!this._isValidIndex(index)) {
      Logger.e(`TabBarComponent`, `_scrollItemTo: index ${index} out of range`)
      return
    }

    if (index < this._attrs.size) {
      let attr = this._attrs.get(index)
      if (attr) {
        const optimizeOffsetX = this.tabBarOptions.optimizeOffsetX ?? 0
        const xOffset = Math.max(Math.min(attr.minX - optimizeOffsetX, this._maxScrollXOffset), 0)
        // 使item尽量滚到中间位置
        this._scroller.scrollTo({
          xOffset: xOffset,
          yOffset: this._scroller.currentOffset().yOffset,
          animation: { duration: duration, curve: Curve.Linear }
        })
      }
    }
  }
}