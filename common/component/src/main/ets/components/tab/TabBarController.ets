import { AnyType } from '../../AnyType'
import { TabBarComponent } from './TabBarComponent'
import { TabBarItemInterface } from './TabBarItem'
import { TabDataSource } from './TabDataSource'

/**
 * 私有类，用于创建一个唯一的键对象。
 */
class _TabBarControllerKey {
}


/**
 * 触摸事件回调函数的类型定义。
 */
export type HandleTouchCallBack = (item: TabBarItemInterface, index: number, targetIndex: number,
  progress: number) => void

/**
 * TabBarController 类用于管理 TabBar 组件。
 */
export class TabBarController {
  /**
   * 弱映射，用于存储 TabBarController 对象和 TabBarComponent 对象之间的映射关系。
   */
  private weakMap = new WeakMap<object, TabBarComponent>()
  /**
   * 私有属性，用于创建一个唯一的键对象。
   */
  private key: _TabBarControllerKey = {}

  /**
   * 返回当前选中的项的索引。
   * @returns 当前选中的项的索引。
   */
  get currentIndex(): number {
    return this.comp?.index ?? 0
  }

  /**
   * 获取 TabBarComponent 实例。
   * @returns TabBarComponent 实例。
   */
  private get comp(): TabBarComponent | undefined {
    return this.weakMap.get(this.key)
  }

  /**
   * 选择指定索引的项，并将指示器滚动到该选中的项。
   * @param index 新选中的项的索引。
   * @param duration 动画持续时间，默认为 TabBarComponent 中的 animationDuration。
   */
  selectItem(atIndex: number,
    duration: number | undefined = this.comp?.tabBarOptions.itemOptions.animationDuration) {
    this.comp?._selectItem(atIndex, duration)
  }

  /**
   * 处理触摸事件，联动指示器和页面。
   * @param event 触摸事件。
   * @param currentIndex 当前选中的项的索引。
   * @param duration 动画持续时间，默认为 TabBarComponent 中的 animationDuration。
   * @param callBack 选项被选中时的回调函数，默认为 undefined。
   */
  handleTouch(event: TouchEvent, currentIndex: number,
    duration: number | undefined = this.comp?.tabBarOptions.itemOptions.animationDuration,
    callBack: HandleTouchCallBack | undefined) {
    this.comp?._handleTouch(event, currentIndex, duration, callBack)
  }

  /**
   * 绑定 TabBarComponent 作为委托。
   * @param tabBar 要绑定的 TabBarComponent 实例。
   */
  _bind(tabBar: TabBarComponent) {
    this.weakMap.set(this.key, tabBar)
  }

  /**
   * 获取数据源。
   * @returns 数据源实例。
   */
  dataSource(): TabDataSource | undefined {
    return this.comp?._dataSource
  }

  /// CRUD 操作

  /**
   * 更新指定索引的项。
   * @param index 要更新的项的索引。
   * @param item 新的项。
   */
  update(index: number, item: TabBarItemInterface) {
    this.comp?._update(index, item)
  }

  /**
   * 在数组末尾添加新元素，并返回新的数组长度。
   * @param items 要添加的新元素。
   * @returns 新的数组长度。
   */
  push(...items: TabBarItemInterface[]): number {
    return this.comp?._push(...items) ?? -1
  }

  /**
   * 在指定索引插入新项。
   * @param atIndex 插入新项的索引。
   * @param item 新的项。
   */
  insert(atIndex: number, item: TabBarItemInterface) {
    this.comp?._insert(atIndex, item)
  }

  /**
   * 删除指定索引的项。
   * @param atIndex 要删除的项的索引。
   * @returns 被删除的项，如果索引超出范围则返回 undefined。
   */
  delete(atIndex: number): TabBarItemInterface | undefined {
    let tabBar = this.comp
    if (tabBar) {
      return tabBar._delete(atIndex)
    }
    return undefined
  }

  /**
   * 用新项替换当前项，并选择指定索引的项。
   * @param withItems 用于替换当前项的新项数组。
   * @param selectIndex 如果提供，将选择该索引的项；否则使用当前索引。
   */
  setItems(withItems: TabBarItemInterface[], selectIndex: number = this.currentIndex) {
    this.comp?._setItems(withItems, selectIndex)
  }

  /**
   * 返回数组中第一个满足条件的元素的索引，如果没有找到则返回 -1。
   * @param predicate 用于测试数组中每个元素的函数。
   * @param thisArg 执行 predicate 时使用的 this 值。
   * @returns 第一个满足条件的元素的索引，如果没有找到则返回 -1。
   */
  findIndex(predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType): number {
    return this.comp?._findIndex(predicate, thisArg) ?? -1
  }

  /**
   * 返回数组中第一个满足条件的元素的值，如果没有找到则返回 undefined。
   * @param predicate 用于测试数组中每个元素的函数。
   * @param thisArg 执行 predicate 时使用的 this 值。
   * @returns 第一个满足条件的元素的值，如果没有找到则返回 undefined。
   */
  find(predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType): TabBarItemInterface | undefined {
    return this.comp?._find(predicate, thisArg)
  }

  /**
   * 返回指定索引的项。
   * @param atIndex 项的索引。
   * @returns 指定索引的项，如果索引超出范围则返回 undefined。
   */
  getItem(atIndex: number): TabBarItemInterface | undefined {
    return this.comp?._getItem(atIndex)
  }

  /**
   * 设置 TabBar 的内容宽度，指示器将使用该宽度计算手势滑动的百分比。
   * 默认值为设备宽度。
   * 注意：如果 TabBarComponent 没有完全填充屏幕，需要调用此接口设置 TabBar 内容宽度。
   * @param width TabBar 内容的宽度。
   */
  syncTabContentWidth(width: number) {
    this.comp?._syncTabContentWidth(width)
  }
}
