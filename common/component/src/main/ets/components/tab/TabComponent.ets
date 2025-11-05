import { TabBarComponent } from './TabBarComponent'
import { TabBarController } from './TabBarController'
import { ReferenceTabBarItemInterface, TabBarItemInterface } from './TabBarItem'
import { ReferenceTabBarIndicatorInterface, ReferenceTabBarInterface } from './ReferenceTabBarInterface'
import { IndicatorAnimationType, TabBarOptions, TabBarOptionsInterface } from './TabBarOptions'
import { TabController } from './TabController'
import { TabDataSource } from './TabDataSource'

/**
 * OuterTabBoundaryChangeEvent 是一个用于表示外部边界更改的事件的枚举。
 * 用于处理外部嵌套时，通知外部TabComponent切换页面的事件。
 */
export enum OuterTabBoundaryChangeEvent {
  /**
   * 上一个索引。
   */
  Previous = 0,
  /**
   * 下一个索引。
   */
  Next = 1
}

/**
 * TouchMoveEventType 是用于表示触摸事件各个阶段的枚举类型。
 *
 * 该枚举定义了触摸事件处理过程中不同阶段的类型：
 * - `Start`：触摸操作开始时的阶段。
 * - `Move`：触摸点在屏幕上移动的阶段。
 * - `Sliding`：触摸结束后，惯性滑动的阶段。
 * - `End`：触摸操作结束，拖拽结束的阶段。
 *
 * 该枚举常用于处理触摸屏设备的事件流，帮助在不同阶段执行相应的业务逻辑。
 */
export enum TouchMoveEventType {

  /// 触摸操作开始阶段
  Start = 'Start',

  /// 触摸操作中的移动阶段
  Move = 'TouchMove',

  /// 触摸结束后的惯性滑动阶段
  Sliding = 'Slide',

  /// 触摸操作结束阶段
  End = 'End'
}

/**
 * TabComponent 是一个用于管理标签栏和页面内容的组件。
 */
@ComponentV2
export struct TabComponent {
  /**
   * 当前选中的标签项的索引。
   * @param index 当前选中的标签项索引。
   */
  @Param @Once public index: number = 0
  /**
   * 标签项数组。
   * @param items 标签项数组。
   */
  @Param @Once public items: TabBarItemInterface[] = []
  /**
   * 标签栏配置选项。
   * @param tabBarOptions 标签栏配置选项。
   */
  @Param @Once public tabBarOptions: TabBarOptionsInterface = new TabBarOptions()
  /**
   * TabController 实例，用于控制 TabComponent 的行为。
   * @param controller TabController 实例。
   */
  @Param public controller?: TabController = undefined
  /**
   * 点击了 TabBarItem 的回调函数。
   * @param onClickTabBarItem 回调函数，参数为选中的 TabBarItem 和索引。
   */
  @Param public onClickTabBarItem?: (item: TabBarItemInterface, index: number) => void = undefined
  /**
   * 切换了 TabBarItem 的回调函数。
   * @param onChangeTabBarItem 回调函数，参数为选中的 TabBarItem 和索引。
   */
  @Param public onChangeTabBarItem?: (item: TabBarItemInterface, index: number) => void = undefined
  /**
   * 切换了页面的回调函数。
   * @param onChangePage 回调函数，参数为选中的 TabBarItem 和索引。
   */
  @Param public onChangePage?: (item: TabBarItemInterface, index: number) => void = undefined
  /**
   * 触摸移动到页面的回调函数。
   * @param onTouchMovePage 回调函数，参数为选中的 TabBarItem、索引、目标索引和百分比。
   * @param item 当前选中的 TabBarItem。
   * @param currentIndex 当前索引。
   * @param targetIndex 目标索引。
   * @param progress 进度 0.0 - 1.0。
   */
  @Param public onTouchMoveHandle?: (eventType: TouchMoveEventType, currentItem: TabBarItemInterface,
    currentIndex: number,
    targetIndex: number,
    progress: number) => void = undefined
  /**
   * TabBar 滚动到边缘的回调函数。
   * @param onScrollEdge 回调函数，参数为滚动的边缘位置。
   */
  @Param public onScrollEdge?: (side: Edge) => void = undefined
  /**
   * 外部Tab边界改变事件。
   * @param onOuterTabBoundaryChangeEvent 外部Tab边界改变事件。
   */
  @Param public onOuterTabBoundaryChangeEvent?: (event: OuterTabBoundaryChangeEvent) => void = undefined
  /**
   * 自定义 TabBarItem 视图的构建器。
   * @param customTabBarItemBuilder 构建器函数，参数为 ReferenceTabBarInterface。
   */
  @BuilderParam public customTabBarItemBuilder?: (props: ReferenceTabBarInterface) => void
  /**
   * 自定义 Indicator 视图的构建器。
   * @param customIndicatorBuilder 构建器函数，参数为 ReferenceTabBarIndicatorInterface。
   */
  @BuilderParam customIndicatorBuilder?: (props: ReferenceTabBarIndicatorInterface) => void
  /**
   * 左边附加视图的构建器。
   * @param leftItemBuilder 构建器函数，无参数。
   */
  @BuilderParam public leftItemBuilder?: () => void
  /**
   * 右边附加视图的构建器。
   * @param rightItemBuilder 构建器函数，无参数。
   */
  @BuilderParam public rightItemBuilder?: () => void
  /**
   * Page页面视图的构建器。
   * @param contentBuilder 构建器函数，参数为 ReferenceTabBarItemInterface。
   */
  @BuilderParam public contentBuilder: (props: ReferenceTabBarItemInterface) => void
  /**
   * TabsController 实例，用于管理 Tabs 组件。
   */
  private _tabsController: TabsController = new TabsController()
  /**
   * TabBarController 实例，用于管理 TabBar 组件。
   */
  private _tabBarController: TabBarController = new TabBarController()
  /**
   * SwiperController 实例，用于管理 Swiper 组件。
   */
  private _swiperController: SwiperController = new SwiperController()
  /**
   * 标记组件是否已经初始化。
   */
  private _hasInit: boolean = false
  /**
   * 数据源实例。
   */
  private _dataSource: TabDataSource = new TabDataSource()
  /**
   * 标记数据源是否已经绑定。
   */
  @Local private _hasBindDataSource: boolean = false
  /**
   * 当前选中的 Tabs 索引。
   */
  @Local private _tabsIndex: number = 0
  /**
   * 标记是否正在进行动画。
   */
  private _isOnAnimation: boolean = false
  /**
   * 标记是否正在进行手势拖动。
   */
  private _isOnGestureSwipe: boolean = false
  /**
   * 标记是否是手势拖动。
   */
  private _isOnTouch: boolean = false
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
   * 记录进度
   */
  private _moveProgress: number = 0
  /**
   * 记录tab宽度
   */
  private _tabWidth: number = 0
  private _intervalId?: number

  /**
   * 处理边界触摸的标志
   * 此标志用于指示是否需要处理边界触摸事件
   */
  @Computed
  private get _needHandleBoundaryTouch(): boolean {
    if (this.tabBarOptions.enableRecycling) {
      return this.tabBarOptions.disableSwipe !== true
    } else {
      return this.tabBarOptions.tabContentScrollable !== false
    }
  }

  /**
   * 组件即将显示时的回调函数。
   */
  aboutToAppear() {
    if (!this._hasInit) {
      this._hasInit = true
      // 校验初始化选中索引，不安全边界修正
      this.index = Math.max(Math.min(this.index, this.items.length - 1), 0);
      this._tabsIndex = this.index
      if (this.controller !== undefined) {
        this.controller._bind(this)
      }
    }
  }

  /**
   * 返回当前选中的项的索引。
   * @returns 当前选中的项的索引。
   */
  _currentIndex(): number {
    return this._tabBarController.currentIndex
  }

  /**
   * 切换到指定索引的内容页面。标签栏也会选择新的索引。
   * @param index 目标页面的索引。
   * @param duration 动画持续时间，默认为 TabBarOptions 中的 animationDuration。
   */
  _changeIndex(index: number, duration: number | undefined = this.tabBarOptions.itemOptions.animationDuration) {
    this._tabBarController.selectItem(index, duration)
    if (this.tabBarOptions.enableRecycling) {
      this._swiperController.changeIndex(index, true)
    } else {
      this._tabsController.changeIndex(index)
    }
  }

  /**
   * 更新指定索引的项。
   * @param index 要更新的项的索引。
   * @param item 新的项。
   */
  _update(index: number, item: TabBarItemInterface) {
    this._tabBarController.update(index, item)
  }

  /**
   * 在数组末尾添加新元素，并返回新的数组长度。
   * @param items 要添加的新元素。
   * @returns 新的数组长度。
   */
  _push(...items: TabBarItemInterface[]): number {
    return this._tabBarController.push(...items)
  }

  /**
   * 在指定索引插入新项。
   * @param atIndex 插入新项的索引。
   * @param item 新的项。
   */
  _insert(atIndex: number, item: TabBarItemInterface) {
    let fixedIndex = Math.min(Math.max(atIndex, 0), this._dataSource.totalCount())
    if (fixedIndex <= this.index) {
      this._tabsIndex = this.index + 1;
    }
    this._tabBarController.insert(atIndex, item)
  }

  /**
   * 删除指定索引的项。
   * @param atIndex 要删除的项的索引。
   * @returns 被删除的项，如果索引超出范围则返回 undefined。
   */
  _delete(atIndex: number): TabBarItemInterface | undefined {
    if (atIndex < this._dataSource.totalCount() && atIndex >= 0) {
      if (atIndex < this.index) {
        this._tabsIndex = this.index - 1
      } else if (atIndex === this.index) { // 如果删除的是当前选中的item,则默认重新选中第一个item。
        this._tabsIndex = 0
      }
    }
    return this._tabBarController.delete(atIndex)
  }

  /**
   * 用新项替换当前项，并选择指定索引的项。
   * @param withItems 用于替换当前项的新项数组。
   * @param selectIndex 如果提供，将选择该索引的项；否则使用当前索引。
   */
  _setItems(withItems: TabBarItemInterface[], selectIndex: number = this._currentIndex()) {
    let defaultIndex = selectIndex < withItems.length ? Math.max(selectIndex, 0) : 0
    this._tabsIndex = defaultIndex
    this._tabBarController.setItems(withItems, selectIndex)
    this._delay(100, () => {
      if (this.tabBarOptions.enableRecycling) {
        this._swiperController.changeIndex(defaultIndex, true)
      } else {
        this._tabsController.changeIndex(defaultIndex)
      }
    })
  }

  /**
   * 返回数组中第一个满足条件的元素的索引，如果没有找到则返回 -1。
   * @param predicate 用于测试数组中每个元素的函数。
   * @param thisArg 执行 predicate 时使用的 this 值。
   * @returns 第一个满足条件的元素的索引，如果没有找到则返回 -1。
   */
  _findIndex(predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: undefined): number {
    return this._tabBarController.findIndex(predicate, thisArg)
  }

  /**
   * 返回数组中第一个满足条件的元素的值，如果没有找到则返回 undefined。
   * @param predicate 用于测试数组中每个元素的函数。
   * @param thisArg 执行 predicate 时使用的 this 值。
   * @returns 第一个满足条件的元素的值，如果没有找到则返回 undefined。
   */
  _find(predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: undefined): TabBarItemInterface | undefined {
    return this._tabBarController.find(predicate, thisArg)
  }

  /**
   * 返回指定索引的项。
   * @param atIndex 项的索引。
   * @returns 指定索引的项，如果索引超出范围则返回 undefined。
   */
  _getItem(atIndex: number): TabBarItemInterface | undefined {
    return this._tabBarController.getItem(atIndex)
  }

  /**
   * 预加载指定索引的标签内容。
   * @param indices 要预加载的标签内容的索引数组。
   * @returns 返回预加载操作的 Promise。
   * @throws 如果参数无效，抛出错误：
   * <br> 1. 参数类型不是 Array<number>。
   * <br> 2. 参数是空数组。
   * <br> 3. 参数包含无效的索引。
   */
  _preloadItems(indices: Optional<Array<number>>): Promise<void> {
    if (this.tabBarOptions.enableRecycling) {
      return Promise.reject("enableRecycling is true and preloadItems doesn't work. Set enableRecycling to false if want using preloadItems.")
    } else {
      return this._tabsController.preloadItems(indices)
    }
  }

  /**
   * 设置 TabBar 的内容宽度，指示器将使用该宽度计算手势滑动的百分比。
   * 默认值为设备宽度。
   * 注意：如果 TabComponent 没有完全填充屏幕，需要调用此接口设置 TabBar 内容宽度。
   * @param width TabBar 内容的宽度。
   */
  _syncTabContentWidth(width: number) {
    this._tabWidth = width
    this._tabBarController.syncTabContentWidth(width)
  }

  /**
   * 处理内部 TabBoundaryChangeEvent 事件。
   * @param event 外部边界改变事件。
   */
  _handleInnerTabBoundaryChangeEvent(event: OuterTabBoundaryChangeEvent) {
    const nextIndex = this.index + (event === OuterTabBoundaryChangeEvent.Previous ? -1 : 1)
    if (nextIndex >= 0 && nextIndex <= this._dataSource.totalCount() - 1) {
      if (this.tabBarOptions.enableRecycling) {
        this._swiperController.changeIndex(nextIndex, true)
      } else {
        this._tabsController.changeIndex(nextIndex)
      }
    }
  }

  /**
   * 构建组件的 UI 结构。
   */
  build() {
    // 使用Column会导致 TabContent 底部产生偏移 这里使用Flex布局拉伸tabs
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Stretch }) {
      TabBarComponent({
        index: this.index!!,
        items: this.items!!,
        tabBarOptions: this.tabBarOptions!!,
        controller: this._tabBarController,
        customTabBarItemBuilder: this.customTabBarItemBuilder,
        customIndicatorBuilder: this.customIndicatorBuilder,
        leftItemBuilder: this.leftItemBuilder,
        rightItemBuilder: this.rightItemBuilder,
        onSelectItem: (item: TabBarItemInterface, index: number) => {
          this._handleOnSelectItem(index, item)
        },
        onScrollEdge: (side) => {
          if (this.onScrollEdge !== undefined) {
            this.onScrollEdge(side)
          }
        },
        onInitData: () => {
          this.bindDataSource()
        }
      })
      if (this._hasBindDataSource) {
        if (this.tabBarOptions.enableRecycling) {
          Swiper(this._swiperController) {
            LazyForEach(this._dataSource, (item: TabBarItemInterface, index: number) => {
              this.contentBuilder({
                currentItemIndex: index,
                selectedItemIndex: this.index,
                item: item
              })
            }, (_: TabBarItemInterface, index: number) => {
              return this._dataSource.identifier(index)
            })
          }
          .flexGrow(1)
          .cachedCount(this.tabBarOptions.cachedCount)
          .index(this._tabsIndex)
          .autoPlay(false)
          .indicator(false)
          .loop(false)
          .duration(this.tabBarOptions.tabsAnimationDuration)
          .itemSpace(0)
          .curve(Curve.Linear)
          .disableSwipe(this.tabBarOptions.disableSwipe)
          .displayArrow(this.tabBarOptions.displayArrow[0], this.tabBarOptions.displayArrow[1])
          .onChange((index: number) => {
            this._handleOnChange(index)
          })
          .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
            this._handleOnAnimationStart(index, targetIndex, extraInfo)
          })
          .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
            this._handleOnAnimationEnd(index, extraInfo)
          })
          .onGestureSwipe((index, event) => {
            this._handleOnGestureSwipe(index, event)
          })
          .onTouch((event) => {
            this._handleOnTouch(event)
          })
          .onAreaChange((_, newArea: Area) => {
            this._syncTabContentWidth(Number(newArea.width).valueOf())
          })
        } else {
          //  _tabsIndex 绑定
          Tabs({ controller: this._tabsController, index: this._tabsIndex }) {
            ForEach(this.items, (item: TabBarItemInterface, index: number) => {
              TabContent() {
                this.contentBuilder({
                  currentItemIndex: index,
                  selectedItemIndex: this.index,
                  item: item
                })
              }
              .align(Alignment.TopStart)
            }, (_: TabBarItemInterface, index: number) => {
              return this._dataSource.identifier(index)
            })
          }
          .flexGrow(1)
          .barHeight(0)
          .scrollable(this.tabBarOptions.tabContentScrollable)
          .animationDuration(this.tabBarOptions.tabsAnimationDuration)
          .onChange((index: number) => {
            this._handleOnChange(index)
          })
          .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
            this._handleOnAnimationStart(index, targetIndex, extraInfo)
          })
          .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
            this._handleOnAnimationEnd(index, extraInfo)
          })
          .onGestureSwipe((index, event) => {
            this._handleOnGestureSwipe(index, event)
          })
          .onTouch((event) => {
            this._handleOnTouch(event)
          })
          .onAreaChange((_, newArea: Area) => {
            this._syncTabContentWidth(Number(newArea.width).valueOf())
          })
        }
      }
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 绑定数据源方法
   * 此方法用于将TabBar控件的数据源绑定到当前组件
   * 如果数据源存在，则将其赋值给私有变量_dataSource，并设置_hasBindDataSource为true
   */
  private bindDataSource() {
    const dataSource = this._tabBarController.dataSource()
    if (dataSource) {
      this._dataSource = dataSource
      this._hasBindDataSource = true
    }
  }

  /**
   * 处理选择项事件的方法
   * @param index 被选中项的索引
   * @param item 被选中的TabBarItem对象
   * 此方法根据是否启用循环来选择下一项，并触发点击和变更事件
   */
  private _handleOnSelectItem(index: number, item: TabBarItemInterface) {
    if (this.tabBarOptions.enableRecycling) {
      this._swiperController.changeIndex(index, true)
    } else {
      this._tabsController.changeIndex(index)
    }

    if (this.onClickTabBarItem !== undefined) {
      this.onClickTabBarItem(item, index)
    }

    if (this.onChangeTabBarItem !== undefined) {
      this.onChangeTabBarItem(item, index)
    }
  }

  /**
   * 处理动画开始事件的方法
   * @param index 当前项的索引
   * @param targetIndex 目标项的索引
   * @param extraInfo 动画开始的额外信息
   * 此方法在动画开始时设置_isOnAnimation状态，并根据情况选择相应的Tab项
   */
  private _handleOnAnimationStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
    this._isOnGestureSwipe = false
    this._isOnAnimation = true
    if (this._isOnTouch && this._dataSource.totalCount() > 0 && this.onTouchMoveHandle !== undefined) {
      const velocity = Math.abs(extraInfo.velocity)
      if (velocity > 0) {
        // 计算滚动需要的时间
        const interval = (this._tabWidth * Math.abs(1 - this._moveProgress) / vp2px(velocity)) * 1000
        console.info("onTouchMoveHandle interval:", interval)
        // 每50ms 计算一次 计时次数
        const count = interval / 50
        if (count > 1) {
          // 每个计算间隔的增加进度计算
          let slidingProgress: number = 0
          if (index !== targetIndex) {
            slidingProgress = (1 - this._moveProgress) / count
          } else {
            slidingProgress = (0 - this._moveProgress) / count
          }
          this._intervalId = setInterval(() => {
            const progress = Math.max(0, Math.min(1, this._moveProgress + slidingProgress))
            if (this._moveProgress !== progress) {
              this._moveProgress = progress
              this.onTouchMoveHandle?.(TouchMoveEventType.Sliding, this.items[index], index, targetIndex,
                this._moveProgress);
            }
          }, 50)
        }
      }
      this.onTouchMoveHandle(TouchMoveEventType.Sliding, this.items[index], index, targetIndex, this._moveProgress);
    }
    if (index !== targetIndex) {
      this._tabBarController.selectItem(targetIndex)
    } else if (this.tabBarOptions.indicatorOptions.animationType === IndicatorAnimationType.Linkage) {
      this._tabBarController.selectItem(index, this.tabBarOptions.tabsAnimationDuration)
    }
  }

  /**
   * 处理动画结束事件的方法
   * @param index 当前项的索引
   * @param extraInfo 动画结束的额外信息
   * 此方法在动画结束时重置_isOnAnimation状态，并在特定动画类型下选择当前Tab项
   */
  private _handleOnAnimationEnd(index: number, extraInfo: SwiperAnimationEvent) {
    this._isOnAnimation = false
    if (this._intervalId !== undefined) {
      clearInterval(this._intervalId)
      this._intervalId = undefined
    }
    if (this._isOnTouch && this._dataSource.totalCount() > 0 && this.onTouchMoveHandle !== undefined) {
      this.onTouchMoveHandle(TouchMoveEventType.End, this.items[index], index, index, this._moveProgress);
    }
    this._isOnTouch = false
    if (this.tabBarOptions.indicatorOptions.animationType === IndicatorAnimationType.Linkage) {
      this._tabBarController.selectItem(index)
    }
  }

  private _handleOnGestureSwipe(index: number, event: SwiperAnimationEvent) {
    this._isOnGestureSwipe = true
    if (this._isOnTouch && !this._isOnAnimation && this._dataSource.totalCount() > 0 &&
      this.onTouchMoveHandle !== undefined &&
      this._tabWidth > 0) {
      const offset = event.currentOffset
      const isMoveToLeft: boolean = offset > 0
      const targetIndex = isMoveToLeft ? index - 1 : index + 1
      if (targetIndex > -1 && targetIndex < this._dataSource.totalCount()) {
        // 计算滚动百分比, 更新指示器位置
        const progress = Math.min(Math.abs(offset) / this._tabWidth, 1)
        this._moveProgress = progress
        this.onTouchMoveHandle(TouchMoveEventType.Move, this.items[index], index, targetIndex, progress);
      }
    }
  }

  /**
   * 处理触摸事件的方法
   * @param event 触摸事件对象
   * 此方法在非动画执行期间将触摸事件传递给TabBarController处理
   */
  private _handleOnTouch(event: TouchEvent) {
    if (!this._isOnAnimation) {
      if (this._dataSource.totalCount() > 0 && this.onTouchMoveHandle !== undefined) {
        if (event.type === TouchType.Down) {
          this._moveProgress = 0
          this._isOnTouch = true
          this.onTouchMoveHandle(TouchMoveEventType.Start, this.items[this.index], this.index, this.index, 0);
        } else if ((event.type === TouchType.Up || event.type === TouchType.Cancel) && !this._isOnGestureSwipe) {
          this._moveProgress = 0
          this._isOnTouch = false
          this.onTouchMoveHandle(TouchMoveEventType.End, this.items[this.index], this.index, this.index, 0);
        }
      }
      this._tabBarController.handleTouch(event, this.index, this.tabBarOptions.itemOptions.animationDuration,
        undefined);
      if (this.onOuterTabBoundaryChangeEvent !== undefined && this._needHandleBoundaryTouch &&
        (this.index === 0 || this.index === this._dataSource.totalCount() - 1)) {
        this._onBoundaryTouch(event)
      }
    }
  }

  /**
   * 处理边界触摸事件的方法
   * @param event 边界触摸事件对象
   * 此方法在边界触摸事件发生时执行边界触摸处理逻辑
   */
  private _onBoundaryTouch(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      this._moveStartX = event.touches[0].x
      this._moveStartTime = Date.now()
    }
    if (event.type === TouchType.Up) {
      const isStart = this.index === 0
      const isEnd = this.index === this._dataSource.totalCount() - 1
      this._moveEndTime = Date.now()
      const touchDuration = this._moveEndTime - this._moveStartTime
      const offset = event.touches[0].x - this._moveStartX
      this._moveStartX = 0
      this._moveStartTime = 0
      this._moveEndTime = 0
      if (isStart && offset > 0 && touchDuration < 300) {
        this.onOuterTabBoundaryChangeEvent!(OuterTabBoundaryChangeEvent.Previous)
      } else if (isEnd && offset < 0 && touchDuration < 300) {
        this.onOuterTabBoundaryChangeEvent!(OuterTabBoundaryChangeEvent.Next)
      }
    }
  }

  /**
   * 处理变更事件的方法
   * @param index 变更后选中项的索引
   * 此方法更新内部选中索引，并在onChangePage事件存在时触发该事件
   */
  private _handleOnChange(index: number) {
    this._tabsIndex = index
    if (this.onChangePage !== undefined) {
      const item = this._getItem(index)
      if (item !== undefined) {
        this.onChangePage(item, index)
      }
    }
  }

  /**
   * 延迟执行方法
   * @param duration 延迟的时间，以毫秒为单位
   * @param handler 延迟结束后要执行的回调函数
   * 此方法创建一个Promise，使用setTimeout来延迟执行给定的回调函数
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
}