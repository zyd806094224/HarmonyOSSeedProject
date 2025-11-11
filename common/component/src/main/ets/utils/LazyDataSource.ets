import { BasicDataSource } from './BasicDataSource';
import { Logger } from './Logger';

/**
 * LazyDataSource 是一个用于管理数据源的类，它允许数据的懒加载和观察者模式的数据变更通知。
 * 它实现了IDataSource接口，提供了数据操作和事件通知的方法。
 *
 * @typeparam T 数据源中数据项的类型。
 */
@ObservedV2
export class LazyDataSource<T> extends BasicDataSource<T> {
  // 存储数据源的数据数组。
  @Trace
  private _data: T[] = [];
  // 刷新边界数据
  private _reloadBoundaryData: boolean = false

  /**
   * 构造函数，初始化数据源。
   *
   * @param initValue 初始数据数组，默认为空数组。
   * @param reloadBoundaryData 是否在数据变化时，重新加载刷新边界数据。默认为false。
   */
  public constructor(initValue: T[] = [], reloadBoundaryData: boolean = false) {
    super();
    this._data = [...initValue];
    this._reloadBoundaryData = reloadBoundaryData
  }


  // 接口定义的方法

  /**
   * 获取数据源的总项数。
   *
   * @returns 数据源的长度。
   */
  public totalCount(): number {
    return this._data.length;
  }

  /**
   * 设置数据源的数据。
   *
   * @param data 新的数据数组。
   */
  public setData(data: T[]): void {
    let oldLength = this._data.length
    this._data = [...data];
    let dataOperations: DataOperation[] = [];
    if (oldLength > 0) {
      dataOperations.push({ type: DataOperationType.DELETE, index: 0, count: oldLength })
    }
    if (data.length > 0) {
      dataOperations.push({ type: DataOperationType.ADD, index: 0, count: data.length })
    }
    dataOperations.push({ type: DataOperationType.RELOAD })
    super.notifyDatasetChange(dataOperations);
  }

  /**
   * 根据索引获取数据源中的单个数据项。
   *
   * @param index 索引位置。
   * @returns 索引处的数据项。
   */
  public getData(index: number): T | undefined;

  /**
   * 获取整个数据源数组。
   *
   * @returns 数据源数组。
   */
  public getData(): T[];

  /**
   * 根据索引或无参数获取数据源中的数据项或整个数据源数组。
   *
   * @param predicates 如果提供，则为索引；否则返回整个数组。
   * @returns 数据项或数据源数组。
   */
  public getData(predicates: number | void): (T | undefined) | T[] {
    if (typeof predicates === 'number') {
      if (predicates < this._data.length) {
        return this._data[predicates];
      }
      return undefined
    }
    return this._data;
  }

  /**
   * 根据数据项查找其在数据源中的索引。
   *
   * @param data 要查找的数据项。
   * @returns 数据项的索引，如果未找到则返回-1。
   */
  public getIndex(data: T): number;

  /**
   * 根据回调函数查找符合条件的数据项的索引。
   *
   * @param predicates 回调函数。
   * @returns 符合条件的数据项的索引，如果未找到则返回-1。
   */
  public getIndex(predicates: (data: T, index: number, obj: T[]) => boolean): number;

  /**
   * 根据数据项或回调函数查找索引。
   *
   * @param predicates 数据项或回调函数。
   * @returns 数据项的索引，如果未找到则返回-1。
   */
  public getIndex(predicates: T | ((data: T, index: number, obj: T[]) => boolean)): number {
    if (typeof predicates === 'function') {
      return this._data.findIndex(predicates as ((data: T, index: number, obj: T[]) => boolean));
    }
    return this._data.indexOf(predicates);
  }

  /**
   * 向数据源末尾添加单个数据项。
   *
   * @param data 要添加的数据项。
   */
  public pushData(data: T): void;

  /**
   * 向数据源末尾添加多个数据项。
   *
   * @param data 要添加的数据数组。
   */
  public pushData(data: T[]): void;

  /**
   * 向数据源末尾添加数据项或数据数组。
   * 如果是数组，则通知监听器数据集已变更。
   *
   * @param data 要添加的数据项或数据数组。
   */
  public pushData(data: T | T[]): void {
    let dataArray: T[] = [];
    if (data instanceof Array) {
      dataArray.push(...data)
    } else {
      dataArray.push(data)
    }
    if (dataArray.length > 0) {
      let start = this._data.length;
      this._data.push(...dataArray);
      let dataOperations: DataOperation[] = [];
      // 处理刷新边界数据
      if (this._reloadBoundaryData && start > 0) {
        dataOperations.push({ type: DataOperationType.CHANGE, index: start - 1 })
      }
      dataOperations.push({ type: DataOperationType.ADD, index: start, count: dataArray.length })
      super.notifyDatasetChange(dataOperations);
    }
  }

  /**
   * 在指定索引处插入单个数据项。
   *
   * @param data 要插入的数据项。
   * @param index 插入的位置索引。
   * @returns 是否插入成功。
   */
  public insertData(data: T, index: number): boolean;

  /**
   * 在指定索引处插入多个数据项。
   *
   * @param data 要插入的数据数组。
   * @param index 插入的位置索引。
   * @returns 是否插入成功。
   */
  public insertData(data: T[], index: number): boolean;

  /**
   * 在指定索引处插入数据项或数据数组。
   * 如果是数组，则通知监听器数据集已变更。
   *
   * @param data 要插入的数据项或数据数组。
   * @param index 插入的位置索引。
   * @returns 是否插入成功。
   */
  public insertData(data: T | T[], index: number = 0): boolean {
    if (index < 0 || index > this._data.length) {
      Logger.e('insertData:', `index: ${data} out of range`);
      return false;
    }
    let dataArray: T[] = [];
    if (data instanceof Array) {
      dataArray.push(...data)
    } else {
      dataArray.push(data)
    }
    if (dataArray.length > 0) {
      let oldLength = this._data.length
      this._data.splice(index, 0, ...dataArray);
      let dataOperations: DataOperation[] = [];
      dataOperations.push({ type: DataOperationType.ADD, index: index, count: dataArray.length })
      // 处理刷新边界数据
      if (this._reloadBoundaryData && oldLength > 0) {
        if (index === 0) {
          dataOperations.push({ type: DataOperationType.CHANGE, index: 1 })
        } else if (index === oldLength) {
          dataOperations.push({ type: DataOperationType.CHANGE, index: oldLength - 1 })
        }
      }
      super.notifyDatasetChange(dataOperations);
    }
    return true
  }

  /**
   * 删除指定索引处的数据项。
   *
   * @param index 要删除的数据项的索引。
   * @returns 是否删除成功。
   */
  public deleteData(index: number): boolean;

  /**
   * 删除指定数据项。
   *
   * @param data 要删除的数据项。
   * @returns 是否删除成功。
   */
  public deleteData(data: T): boolean;

  /**
   * 删除数据源中的数据项。
   * 可以根据索引或数据项本身进行删除，并通知监听器。
   *
   * @param predicates 要删除的数据项的索引或数据项本身。
   * @returns 是否删除成功。
   */
  public deleteData(predicates: T | number): boolean {
    let index = -1;
    if (typeof predicates === 'number') {
      if (predicates < 0 || predicates >= this._data.length) {
        Logger.e('deleteData:', `index: ${predicates} out of range`);
        return false;
      }
      index = predicates;
    } else {
      index = this.getIndex(predicates);
      if (index < 0) {
        Logger.e('deleteData:', `data: ${predicates} not found`)
        return false
      }
    }
    this._data.splice(index, 1);
    let dataOperations: DataOperation[] = [];
    dataOperations.push({ type: DataOperationType.DELETE, index: index })
    // 处理刷新边界数据
    if (this._reloadBoundaryData && this._data.length > 0) {
      if (index === 0) {
        dataOperations.push({ type: DataOperationType.CHANGE, index: 0 })
      } else if (index === this._data.length) {
        dataOperations.push({ type: DataOperationType.CHANGE, index: this._data.length - 1 })
      }
    }
    super.notifyDatasetChange(dataOperations);
    return true
  }

  /**
   * 修改指定索引处的数据项。
   *
   * @param index 要修改的数据项的索引。
   * @param newData 新的数据项。
   * @returns 是否修改成功。
   */
  public modifyData(index: number, newData: T): boolean;

  /**
   * 修改指定数据项。
   *
   * @param oldData 要修改的旧数据项。
   * @param newData 新的数据项。
   * @returns 是否修改成功。
   */
  public modifyData(oldData: T, newData: T): boolean;

  /**
   * 修改数据源中的数据项。
   * 根据索引或数据项本身定位，然后用新数据替换，并通知监听器。
   *
   * @param predicates 要修改的数据项的索引或数据项本身。
   * @param newData 新的数据项。
   * @returns 是否修改成功。
   */
  public modifyData(predicates: number | T, newData: T): boolean {
    let index = -1;
    if (typeof predicates === 'number') {
      if (predicates < 0 || predicates >= this._data.length) {
        Logger.e('modifyData:', `index: ${predicates} out of range`)
        return false
      }
      index = predicates;
    } else {
      index = this.getIndex(predicates);
      if (index < 0) {
        Logger.e('modifyData:', `oldData: ${predicates} not found`)
        return false
      }
    }
    this._data[index] = newData;
    super.notifyDataChange(index);
    return true
  }

  /**
   * 从数据源末尾移除并返回最后一项。
   * 通知监听器数据已删除。
   *
   * @returns 移除的数据项，如果数据源为空则返回undefined。
   */
  public popData(): T | undefined {
    if (this._data.length === 0) {
      return undefined;
    }
    let data = this._data.pop();
    let dataOperations: DataOperation[] = [];
    dataOperations.push({ type: DataOperationType.DELETE, index: this._data.length })
    // 处理刷新边界数据
    if (this._reloadBoundaryData && this._data.length > 0) {
      dataOperations.push({ type: DataOperationType.CHANGE, index: this._data.length - 1 })
    }
    super.notifyDatasetChange(dataOperations)
    return data;
  }

  /**
   * 从数据源头部移除并返回第一项。
   * 通知监听器数据已删除。
   *
   * @returns 移除的数据项，如果数据源为空则返回undefined。
   */
  public shiftData(): T | undefined {
    if (this._data.length === 0) {
      return undefined;
    }
    let data = this._data.shift();
    let dataOperations: DataOperation[] = [];
    dataOperations.push({ type: DataOperationType.DELETE, index: 0 })
    // 处理刷新边界数据
    if (this._reloadBoundaryData && this._data.length > 0) {
      dataOperations.push({ type: DataOperationType.CHANGE, index: 0 })
    }
    super.notifyDatasetChange(dataOperations)
    return data;
  }

  /**
   * 移动数据源中的数据项。
   * 从一个索引处移动到另一个索引处，并通知监听器。
   *
   * @param from 起始索引。
   * @param to 目标索引。
   * @returns 是否移动成功。
   */
  public moveData(from: number, to: number): boolean {
    if (from < 0 || from >= this._data.length || to < 0 || to >= this._data.length || from === to) {
      Logger.e('moveData:', `invalid index from: ${from} to: ${to}`)
      return false
    }
    let el_f = this._data[from];
    this._data[from] = this._data[to];
    this._data[to] = el_f;
    super.notifyDataMove(from, to);
    return true
  }
}
