import { AnyType } from '../../AnyType'
import { TabBarItemInterface } from './TabBarItem'
import { OuterTabBoundaryChangeEvent, TabComponent } from './TabComponent'

/**
 * 内部类，用于生成唯一的键值，避免与其他对象冲突。
 */
class _TabControllerKey {
}

/**
 * TabController 类用于管理 Tab 组件。
 */
export class TabController {
  /**
   * 存储 TabComponent 实例的弱引用映射表。
   * 使用 WeakMap 可以避免内存泄漏，因为当 TabComponent 实例被销毁时，WeakMap 中的引用也会自动清除。
   * @private
   */
  private weakMap = new WeakMap<object, TabComponent>()
  /**
   * 用于标识当前 TabController 实例的唯一键。
   * @private
   */
  private key: _TabControllerKey = new _TabControllerKey()

  /**
   * 获取当前选中的项的索引。
   *
   * @returns 当前选中的项的索引，默认为 0。
   */
  public get currentIndex(): number {
    return this.comp?._currentIndex() ?? 0
  }

  /**
   * 获取当前绑定的 TabComponent 实例。
   *
   * @returns 当前绑定的 TabComponent 实例，如果没有绑定则返回 undefined。
   */
  private get comp(): TabComponent | undefined {
    return this.weakMap.get(this.key)
  }

  /**
   * 切换到指定索引的内容页面。标签栏也会选择新的索引。
   *
   * @param index 目标页面的索引。
   * @param duration 动画持续时间，默认为 TabComponent 中的 animationDuration。
   */
  public changeIndex(index: number,
    duration: number | undefined = this.comp?.tabBarOptions.itemOptions.animationDuration) {
    this.comp?._changeIndex(index, duration)
  }

  /**
   * 绑定 TabComponent 作为委托。
   *
   * @param tabComponent 用于绑定的 TabComponent 实例。
   */
  _bind(tabComponent: TabComponent) {
    this.weakMap.set(this.key, tabComponent)
  }

  /**
   * 更新指定索引的项。
   *
   * @param index 要更新的项的索引。
   * @param item 新的项。
   */
  public update(index: number, item: TabBarItemInterface) {
    this.comp?._update(index, item)
  }

  /**
   * 在数组末尾添加新元素，并返回新的数组长度。
   *
   * @param items 要添加的新元素。
   * @returns 新的数组长度。如果操作失败，则返回 -1。
   */
  public push(...items: TabBarItemInterface[]): number {
    return this.comp?._push(...items) ?? -1
  }

  /**
   * 在指定索引插入新项。
   *
   * @param atIndex 插入新项的索引。
   * @param item 新的项。
   */
  public insert(atIndex: number, item: TabBarItemInterface) {
    this.comp?._insert(atIndex, item)
  }

  /**
   * 删除指定索引的项。
   *
   * @param atIndex 要删除的项的索引。
   * @returns 被删除的项，如果索引超出范围则返回 undefined。
   */
  public delete(atIndex: number): TabBarItemInterface | undefined {
    let tab = this.comp
    if (tab) {
      return tab._delete(atIndex)
    }
    return undefined
  }

  /**
   * 用新项替换当前项，并选择指定索引的项。
   *
   * @param withItems 用于替换当前项的新项数组。
   * @param selectIndex 如果提供，将选择该索引的项；否则使用当前索引。
   */
  public setItems(withItems: TabBarItemInterface[], selectIndex: number = this.currentIndex) {
    this.comp?._setItems(withItems, selectIndex)
  }

  /**
   * 返回数组中第一个满足条件的元素的索引，如果没有找到则返回 -1。
   *
   * @param predicate 用于测试数组中每个元素的函数。
   * @param thisArg 执行 predicate 时使用的 this 值。
   * @returns 第一个满足条件的元素的索引，如果没有找到则返回 -1。
   */
  public findIndex(predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType): number {
    return this.comp?._findIndex(predicate, thisArg) ?? -1
  }

  /**
   * 返回数组中第一个满足条件的元素的值，如果没有找到则返回 undefined。
   *
   * @param predicate 用于测试数组中每个元素的函数。
   * @param thisArg 执行 predicate 时使用的 this 值。
   * @returns 第一个满足条件的元素的值，如果没有找到则返回 undefined。
   */
  public find(predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType): TabBarItemInterface | undefined {
    return this.comp?._find(predicate, thisArg)
  }

  /**
   * 返回指定索引的项。
   *
   * @param atIndex 项的索引。
   * @returns 指定索引的项，如果索引超出范围则返回 undefined。
   */
  public getItem(atIndex: number): TabBarItemInterface | undefined {
    return this.comp?._getItem(atIndex)
  }

  /**
   * 预加载指定索引的标签内容。
   *
   * @param indices 要预加载的标签内容的索引数组。
   * @returns 返回预加载操作的 Promise。
   * @throws 如果参数无效，抛出 BusinessError 错误：
   * <br> 1. 参数类型不是 Array<number>。
   * <br> 2. 参数是空数组。
   * <br> 3. 参数包含无效的索引。
   */
  public preloadItems(indices: Optional<Array<number>>): Promise<void> | undefined {
    return this.comp?._preloadItems(indices)
  }

  /**
   * 设置 TabBar 的内容宽度，指示器将使用该宽度计算手势滑动的百分比。
   * 默认值为设备宽度。
   * 注意：如果 TabComponent 没有完全填充屏幕，需要调用此接口设置 TabBar 内容宽度。
   *
   * @param width TabBar 内容的宽度。
   */
  public syncTabContentWidth(width: number) {
    this.comp?._syncTabContentWidth(width)
  }


  /**
   * 处理内部 TabBoundaryChangeEvent 事件。
   *
   * @param event TabBoundaryChangeEvent 事件对象。
   */
  public handleInnerTabBoundaryChangeEvent(event: OuterTabBoundaryChangeEvent) {
    this.comp?._handleInnerTabBoundaryChangeEvent(event)
  }
}
