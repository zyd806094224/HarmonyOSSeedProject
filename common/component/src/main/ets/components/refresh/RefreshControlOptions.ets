import { RefreshDataInto, RefreshDataState } from './RefreshDataState'
import { RefreshState } from './RefreshState'

/**
 * 刷新控制器配置接口
 * 用于配置刷新控件的行为和外观
 */
export interface RefreshControlOptions {
  /**
   * 刷新后是否恢复原状
   * @type {boolean}
   */
  isRestoreAfterRefresh: boolean
  /**
   * 刷新控件的高度
   * @type {number}
   */
  height: number
  /**
   * 提示的高度
   * @type {number}
   */
  tipsHeight: number
  /**
   * 刷新控件的高度
   * @type {number}
   */
  refreshHeight: number
  /**
   * 动画持续时间（毫秒）
   * @type {number}
   */
  bounceAnimationDuration: number
  /**
   * 提示显示时间（毫秒）
   * @type {number}
   */
  tipsDisplayDuration: number
  /**
   * 文本字体配置
   * @type {Font}
   */
  textFont: Font
  /**
   * 文本颜色
   * @type {ResourceColor}
   */
  textColor: ResourceColor
  /**
   * 刷新图标的颜色，可以是颜色值或资源路径
   * @type {number | string}
   */
  refreshColor: number | string
  /**
   * 背景颜色
   * @type {ResourceColor}
   */
  backgroundColor: ResourceColor
  /**
   * 根据刷新状态返回提示文本的函数
   * @param state 当前的刷新状态
   * @param dataInfo 可选的数据状态
   * @returns 提示文本
   */
  stateTips: (state: RefreshState, dataInfo?: RefreshDataInto) => string
}

/**
 * 继承自 RefreshControlOptions 的头部刷新控件配置接口
 */
export interface RefreshHeaderOptions extends RefreshControlOptions {}

/**
 * 继承自 RefreshControlOptions 的底部刷新控件配置接口
 */
export interface RefreshFooterOptions extends RefreshControlOptions {}

/**
 * 默认的头部刷新配置
 */
export const DEFAULT_HEADER_REFRESH_OPTIONS: () => RefreshHeaderOptions = () => {
  return _createRefreshOptions(50, defaultHeaderStateTips)
};

/**
 * 默认的底部刷新配置
 */
export const DEFAULT_FOOTER_REFRESH_OPTIONS: () => RefreshHeaderOptions = () => {
  return _createRefreshOptions(44, defaultFooterStateTips)
};

/**
 * 创建刷新控件配置的辅助函数
 * @param height 刷新控件的高度
 * @param stateTips 根据刷新状态返回对应提示文本的函数
 * @returns 刷新控件的配置
 */
function _createRefreshOptions<T extends RefreshControlOptions>(
  height: number,
  stateTips: (state: RefreshState, dataInfo?: RefreshDataInto) => string
): T {
  // 创建默认的刷新控件配置
  const options: RefreshControlOptions = {
    isRestoreAfterRefresh: true,
    height: height,
    tipsHeight: 44,
    refreshHeight: 30,
    bounceAnimationDuration: 150,
    tipsDisplayDuration: 1000,
    textFont: { size: 14, weight: FontWeight.Regular },
    textColor: '#999999',
    refreshColor: '#999999',
    backgroundColor: '#FFFFFF',
    stateTips: stateTips
  };
  return options as T
}

/**
 * 根据刷新状态返回普通的头部标题文本
 * @param state 当前的刷新状态
 * @param dataInfo 可选的数据状态
 * @returns 对应状态的标题文本
 */
export function defaultHeaderStateTips(state: RefreshState, dataInfo?: RefreshDataInto): string {
  // 根据不同的刷新状态返回对应的提示文本
  switch (state) {
    case RefreshState.Drag:
      return '下拉可以刷新';
    case RefreshState.OverDrag:
      return '释放立即刷新';
    case RefreshState.Refresh:
      return '正在刷新...';
    case RefreshState.Done:
      if (dataInfo === undefined) {
        return '刷新成功';
      }
      if (dataInfo.message !== undefined && dataInfo.message.trim() !== '') {
        return dataInfo.message;
      }
      switch (dataInfo.state) {
        case RefreshDataState.Upgrade:
          return '刷新成功';
        case RefreshDataState.Latest:
          return '已经是最新数据';
        case RefreshDataState.Error:
          return '刷新失败';
        default:
          return ''
      }
    default:
      return ''
  }
}

/**
 * 根据刷新状态返回普通的底部标题文本
 * 如果没有更多数据可加载，则显示特定的结束文本
 * @param state 当前的刷新状态
 * @param dataInfo 可选的数据状态
 * @returns 对应状态的标题文本或结束文本
 */
export function defaultFooterStateTips(state: RefreshState, dataInfo?: RefreshDataInto): string {
  // 如果没有更多数据可加载，直接返回特定的结束文本
  if (dataInfo !== undefined && dataInfo.state === RefreshDataState.NoMore && state !== RefreshState.Inactive) {
    return '已经全部加载完毕';
  }

  // 根据不同的刷新状态返回对应的提示文本
  switch (state) {
    case RefreshState.Drag:
      return '上拉加载更多';
    case RefreshState.OverDrag:
      return '释放立即加载';
    case RefreshState.Refresh:
      return '正在加载更多数据...';
    case RefreshState.Done:
      if (dataInfo === undefined) {
        return '加载成功';
      }
      if (dataInfo.message !== undefined && dataInfo.message.trim() !== '') {
        return dataInfo.message;
      }
      switch (dataInfo.state) {
        case RefreshDataState.Upgrade:
          return '加载成功';
        case RefreshDataState.Error:
          return '加载失败';
        default:
          return ''
      }
    default:
      return ''
  }
}
