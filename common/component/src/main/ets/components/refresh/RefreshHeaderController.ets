import { DEFAULT_HEADER_REFRESH_OPTIONS, RefreshHeaderOptions } from './RefreshControlOptions';
import { RefreshState } from './RefreshState';
import { RefreshController } from './RefreshController';


/**
 * RefreshHeader刷新控制器
 */
@ObservedV2
export class RefreshHeaderController extends RefreshController<RefreshHeaderOptions> {
  /**
   * 记录上次刷新的时间
   * @type {number}
   */
  @Trace public lastRefreshTime: number = Date.now();

  /**
   * 构造函数，初始化头部刷新控制器
   * @param options 头部刷新控件的配置选项，默认使用 DEFAULT_HEADER_REFRESH_OPTIONS
   */
  constructor(options: RefreshHeaderOptions = DEFAULT_HEADER_REFRESH_OPTIONS()) {
    super(options)
  }

  /**
   * 结束刷新
   */
  public endRefreshing(): void {
    animateTo({
      duration: this.options.tipsDisplayDuration,
      curve: Curve.EaseOut,
      delay: 150,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.didEndTips()
      }
    }, () => {
      this.dragOffset = this.options.tipsHeight
      this.state = RefreshState.Done
    })
  }

  /*
   * 结束提示
   */
  private didEndTips(): void {
    animateTo({
      duration: this.options.bounceAnimationDuration,
      curve: Curve.EaseOut,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.dragOffset = 0;
        this.state = RefreshState.Inactive
      }
    }, () => {
      this.dragOffset = 0;
    })
  }


  /**
   * 监听状态变化，更新上次刷新时间
   * @param monitor 状态监控对象
   */
  @Monitor('state')
  private onLastRefreshTimeChange(monitor: IMonitor): void {
    const value = monitor.value<RefreshState>();
    if (value === undefined) {
      return
    }
    // 只有从完成状态到初始状态时才更新时间
    if (value.before === RefreshState.Done && value.now === RefreshState.Inactive) {
      this.lastRefreshTime = Date.now()
    }
  }
}


