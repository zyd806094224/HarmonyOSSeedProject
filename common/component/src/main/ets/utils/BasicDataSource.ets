@ObservedV2
export class BasicDataSource<T> implements IDataSource {
  // 存储数据变更监听器的数组。
  private _listeners: DataChangeListener[] = [];

  /**
   * 获取数据源的总项数。
   *
   * @returns 数据源的长度。
   */
  public totalCount(): number {
    throw new Error("Method not implemented.");
  }

  /**
   * 根据索引获取数据源中的单个数据项。
   *
   * @param index 索引位置。
   * @returns 索引处的数据项。
   */
  public getData(index: number): T | undefined {
    throw new Error("Method not implemented.");
  }

  /**
   * 重新加载数据源数据。
   * 将会通知所有监听器数据已重新加载。
   */
  public reloadData() {
    this.notifyDataReloaded();
  }

  // DataChangeListener 注册和注销方法

  /**
   * 注册一个数据变更监听器。
   * 如果监听器尚未注册，则将其添加到监听器数组中。
   *
   * @param listener 数据变更监听器。
   */
  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this._listeners.indexOf(listener) < 0) {
      this._listeners.push(listener);
    }
  }

  /**
   * 注销一个数据变更监听器。
   * 如果监听器已注册，则从监听器数组中移除。
   *
   * @param listener 数据变更监听器。
   */
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    let index = this._listeners.indexOf(listener);
    if (index > 0) {
      this._listeners.splice(index, 1);
    }
  }

  // DataChangeListener 通知方法

  /**
   * 通知所有监听器数据已重新加载。
   */
  public notifyDataReloaded(): void {
    // this._listeners.forEach(listener => listener.onDataReloaded());
    this.notifyDatasetChange([{ type: DataOperationType.RELOAD }]);
  }

  /**
   * 通知所有监听器数据项已添加。
   *
   * @param index 添加的数据项的索引。
   */
  public notifyDataAdd(index: number): void {
    // this._listeners.forEach(listener => listener.onDataAdd(index));
    this.notifyDatasetChange([{ type: DataOperationType.ADD, index: index, count: 1 }]);
  }

  /**
   * 通知所有监听器数据项已移动。
   *
   * @param from 起始索引。
   * @param to 目标索引。
   */
  public notifyDataMove(from: number, to: number): void {
    // this._listeners.forEach(listener => listener.onDataMove(from, to));
    this.notifyDatasetChange([{ type: DataOperationType.MOVE, index: { from: from, to: to } }]);
  }

  /**
   * 通知所有监听器数据项已删除。
   *
   * @param index 删除的数据项的索引。
   */
  public notifyDataDelete(index: number): void {
    // this._listeners.forEach(listener => listener.onDataDelete(index));
    this.notifyDatasetChange([{ type: DataOperationType.DELETE, index: index }]);
  }

  /**
   * 通知所有监听器数据项已变更。
   *
   * @param index 变更的数据项的索引。
   */
  public notifyDataChange(index: number): void {
    // this._listeners.forEach(listener => listener.onDataChange(index));
    this.notifyDatasetChange([{ type: DataOperationType.CHANGE, index: index }]);
  }

  /**
   * 通知所有监听器数据集已变更。
   *
   * @param dataOperations 数据变更操作的数组。
   */
  public notifyDatasetChange(dataOperations: DataOperation[]): void {
    this._listeners.forEach(listener => listener.onDatasetChange(dataOperations));
  }
}