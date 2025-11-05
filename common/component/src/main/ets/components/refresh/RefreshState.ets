/**
 * 刷新状态枚举
 * 用于描述下拉刷新控件的不同状态
 */
export enum RefreshState {
  /**
   * 初始状态，无刷新操作进行
   * @type {number}
   */
  Inactive = 0,

  /**
   * 正在拖动下拉刷新控件，但尚未达到触发刷新的程度
   * @type {number}
   */
  Drag = 1,

  /**
   * 已超过触发刷新的阈值，但尚未释放拖动
   * @type {number}
   */
  OverDrag = 2,

  /**
   * 刷新操作正在进行中
   * @type {number}
   */
  Refresh = 3,

  /**
   * 刷新操作已完成
   * @type {number}
   */
  Done = 4
}
