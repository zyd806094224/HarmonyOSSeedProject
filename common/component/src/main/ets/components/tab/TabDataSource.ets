import { TabBarItemInterface } from './TabBarItem';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import systemDateTime from '@ohos.systemDateTime';
import { Logger } from '../../utils/Logger';
import { BasicDataSource } from '../../utils/BasicDataSource';
import { AnyType } from '../../AnyType';

/**
 * 管理标签栏数据源的类，继承自 BasicDataSource。
 * 提供了对标签栏项的增删改查操作，并支持通知数据变化。
 */
@ObservedV2
export class TabDataSource extends BasicDataSource<TabBarItemInterface> {
  /**
   * 存储标签栏项的私有属性。
   */
  @Trace
  private items: TabBarItemInterface[];

  /**
   * 构造函数，初始化标签栏数据源。
   *
   * @param items - 标签栏项的初始数组。
   */
  constructor(items: TabBarItemInterface[] = []) {
    super();
    for (let index = 0; index < items.length; index++) {
      items[index].index = index;
      items[index].id = this.generateId();
    }
    this.items = items;
  }

  /**
   * 获取标签栏项的总数。
   *
   * @returns 标签栏项的数量。
   */
  public totalCount(): number {
    return this.items.length;
  }

  /**
   * 获取标签栏项列表。
   *
   * @returns 标签栏项列表。
   */
  public getItems(): TabBarItemInterface[] {
    return this.items;
  }

  /**
   * 获取指定索引处的标签栏项。
   *
   * @param atIndex - 要获取的标签栏项的索引。
   * @returns 指定索引处的标签栏项，如果索引超出范围则返回 undefined。
   */
  public getData(atIndex: number): TabBarItemInterface | undefined {
    if (atIndex < this.items.length) {
      return this.items[atIndex];
    }
    return undefined;
  }

  /**
   * 在指定位置插入新的标签栏项。
   *
   * 插入新数据前需要更新插入位置后所有项的索引和 ID。
   *
   * @param atIndex - 插入位置的索引。
   * @param item - 要插入的标签栏项。
   */
  public insert(atIndex: number, item: TabBarItemInterface) {
    item.id = this.generateId();
    item.index = atIndex;

    // 更新插入位置后的所有项的索引和 ID
    for (let index = atIndex; index < this.items.length; index++) {
      this.items[index].index = index + 1;
      this.items[index].id = this.generateId();
    }

    this.items.splice(atIndex, 0, item);
    this.notifyDataAdd(atIndex);
  }

  /**
   * 向标签栏项列表末尾添加多个标签栏项。
   *
   * @param items - 要添加的标签栏项数组。
   * @returns 添加后的标签栏项总数。
   */
  public push(...items: TabBarItemInterface[]): number {
    let oldLength = this.items.length;
    for (let i = 0; i < items.length; i++) {
      items[i].index = i + oldLength;
      items[i].id = this.generateId();
    }

    let newLength = this.items.push(...items);
    this.notifyDataAdd(this.items.length - 1);
    return newLength;
  }

  /**
   * 更新指定索引处的标签栏项。
   *
   * @param atIndex - 要更新的标签栏项的索引。
   * @param item - 新的标签栏项。
   */
  public update(atIndex: number, item: TabBarItemInterface) {
    this.items[atIndex].title = item.title;
    this.notifyDataChange(atIndex);
  }

  /**
   * 设置新的标签栏项列表。
   *
   * @param items - 新的标签栏项列表。
   */
  public setItems(items: TabBarItemInterface[]) {
    this._setUpItems(items);

    let oldLength = this.items.length;
    this.items = items;
    let dataOperations: DataOperation[] = [];

    if (oldLength > 0) {
      dataOperations.push({ type: DataOperationType.DELETE, index: 0, count: oldLength });
    }

    if (items.length > 0) {
      dataOperations.push({ type: DataOperationType.ADD, index: 0, count: items.length });
    }

    dataOperations.push({ type: DataOperationType.RELOAD });
    this.notifyDatasetChange(dataOperations);
  }

  /**
   * 删除指定索引处的标签栏项。
   *
   * @param atIndex - 要删除的标签栏项的索引。
   * @returns 被删除的标签栏项列表。
   */
  public delete(atIndex: number): TabBarItemInterface[] {
    if (atIndex >= this.items.length) {
      return [];
    }

    let deletedItems = this.items.splice(atIndex, 1);
    this._updateItemIndex(atIndex);
    this._updateItemId(atIndex);
    this.notifyDataDelete(atIndex);
    return deletedItems;
  }

  /**
   * 查找符合条件的第一个标签栏项的索引。
   *
   * @param predicate - 用于查找的条件函数。
   * @param thisArg - 可选的 this 参数。
   * @returns 符合条件的第一个标签栏项的索引，未找到时返回 -1。
   */
  public findIndex(
    predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType
  ): number {
    return this.items.findIndex(predicate, thisArg);
  }

  /**
   * 查找符合条件的第一个标签栏项。
   *
   * @param predicate - 用于查找的条件函数。
   * @param thisArg - 可选的 this 参数。
   * @returns 符合条件的第一个标签栏项，未找到时返回 undefined。
   */
  public find(
    predicate: (value: TabBarItemInterface, index: number, obj: TabBarItemInterface[]) => boolean,
    thisArg?: AnyType
  ): TabBarItemInterface | undefined {
    return this.items.find(predicate, thisArg);
  }

  /**
   * 生成唯一的 ID。
   *
   * @returns 唯一的 ID 字符串。
   */
  public generateId(): string {
    let idStr = util.generateRandomUUID(false);

    try {
      let time = systemDateTime.getTime(true);
      idStr += '_' + time;
    } catch (e) {
      let error = e as BusinessError;
      Logger.e("TabDataSource generateId", `Failed to get time. message: ${error.message}, code: ${error.code}`);
    }

    return idStr;
  }

  /**
   * 获取指定索引处的标签栏项的唯一标识符。
   *
   * @param index - 标签栏项的索引。
   * @returns 标签栏项的唯一标识符。
   */
  public identifier(index: number): string {
    const item = this.getData(index);
    if (item !== undefined) {
      return item.id;
    }
    return util.generateRandomUUID(false);
  }

  /**
   * 更新从指定索引开始的所有标签栏项的索引。
   *
   * @param fromIndex - 开始更新的索引，默认为 0。
   */
  private _updateItemIndex(fromIndex: number = 0) {
    for (let index = fromIndex; index < this.items.length; index++) {
      this.items[index].index = index;
    }
  }

  /**
   * 更新从指定索引开始的所有标签栏项的 ID。
   *
   * @param fromIndex - 开始更新的索引，默认为 0。
   */
  private _updateItemId(fromIndex: number = 0) {
    for (let index = fromIndex; index < this.items.length; index++) {
      this.items[index].id = this.generateId();
    }
  }

  /**
   * 同步标签栏项的索引并生成 ID。
   *
   * @param witItems - 要同步的标签栏项列表。
   */
  private _setUpItems(witItems: TabBarItemInterface[]) {
    for (let index = 0; index < witItems.length; index++) {
      witItems[index].index = index;
      witItems[index].id = this.generateId();
    }
  }
}
