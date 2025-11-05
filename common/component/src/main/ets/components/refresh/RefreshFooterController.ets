import { DEFAULT_FOOTER_REFRESH_OPTIONS, RefreshFooterOptions } from './RefreshControlOptions'
import { RefreshDataState } from './RefreshDataState'
import { RefreshController } from './RefreshController'
import { RefreshState } from '../../../../../Index'

/**
 * RefreshFooter刷新控制器
 */
@ObservedV2
export class RefreshFooterController extends RefreshController<RefreshFooterOptions> {
  /**
   * 构造函数，初始化底部刷新控制器
   * @param options 底部刷新控件的配置选项，默认使用 DEFAULT_FOOTER_REFRESH_OPTIONS
   */
  constructor(options: RefreshFooterOptions = DEFAULT_FOOTER_REFRESH_OPTIONS()) {
    super(options)
  }

  /**
   * 更新移动距离
   * @param distance 拖动距离
   */
  onMoveUpdate(distance: number): void {
    if (this.dataInfo !== undefined && this.dataInfo.state === RefreshDataState.NoMore) {
      this.dragOffset = Math.max(distance, 0)
      this.isDragging = true
      this.state = RefreshState.Drag
    } else {
      super.onMoveUpdate(distance)
    }
  }
}