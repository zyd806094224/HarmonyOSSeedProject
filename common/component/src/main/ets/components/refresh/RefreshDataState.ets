/**
 * 刷新数据的状态枚举
 * 用于描述刷新操作后数据的不同状态
 */
export enum RefreshDataState {
  /**
   * 表示有新数据可用进行升级
   * @type {number}
   */
  Upgrade = 0,

  /**
   * 表示当前已经是最新数据
   * @type {number}
   */
  Latest = 1,

  /**
   * 表示没有更多数据可加载
   * @type {number}
   */
  NoMore = 2,

  /**
   * 表示在刷新或加载数据时发生错误
   * @type {number}
   */
  Error = 3,
}

/**
 * 刷新数据信息的接口定义
 * 这里是为了扩展后，方便以后添加刷新信息提供给UI刷新展示
 */
export interface RefreshDataInto {
  /**
   * 刷新数据的状态
   * @type {RefreshDataState}
   */
  state: RefreshDataState
  /**
   * 刷新数据的提示信息
   * @type {string}
   */
  message?: string
}