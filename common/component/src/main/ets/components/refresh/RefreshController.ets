import { RefreshControlOptions } from './RefreshControlOptions'
import { RefreshDataInto } from './RefreshDataState'
import { RefreshState } from './RefreshState'

/**
 * 基础刷新控制器
 */
@ObservedV2
export class RefreshController<Options extends RefreshControlOptions> {
  /**
   * 数据状态信息
   * @type {RefreshDataInto | undefined}
   */
  @Trace public dataInfo?: RefreshDataInto = undefined
  /**
   * 刷新状态
   * @type {RefreshState}
   */
  @Trace public state: RefreshState = RefreshState.Inactive
  /**
   * 刷新回调函数
   * @type {(() => Promise<RefreshDataInto>) | undefined}
   */
  @Trace public onRefresh?: () => Promise<RefreshDataInto | void>
  /**
   * 是否正在拖拽
   * @type {boolean}
   */
  @Trace public isDragging: boolean = false
  /**
   * 拖动距离
   * @type {number}
   */
  @Trace public dragOffset: number = 0

  /**
   * 构造函数，初始化控制器
   * @param options 刷新控件的配置选项
   */
  constructor(options: Options) {
    this._options = options
  }

  /**
   * 拖动百分比
   * @type {number}
   */
  @Computed
  public get dragPercent(): number {
    return Math.min(Math.max(this.dragOffset / this.options.height, 0), 1)
  }

  /**
   * 基础配置
   * 定义一个私有变量_options，用于存储配置选项
   * @type {Options}
   */
  private _options: Options

  /**
   * 基础配置
   * 创建一个公共的getter方法，用于获取当前的配置选
   * @type {Options}
   */
  public get options(): Options {
    // 返回私有变量_options，允许外部访问配置，但不允许直接修改
    return this._options
  }

  /**
   * 是否处于即将刷新或刷新状态
   * @returns {boolean} 是否处于即将刷新或刷新状态
   */
  @Computed
  public get isRefreshing(): boolean {
    return this.state === RefreshState.Refresh || this.state === RefreshState.OverDrag
  }

  /**
   * 是否处于不活跃状态
   * @returns {boolean} 是否处于不活跃状态
   */
  @Computed
  public get isInactive(): boolean {
    return this.state === RefreshState.Inactive
  }

  /**
   * 是否处于活跃状态
   * @returns {boolean} 是否处于活跃状态
   */
  @Computed
  public get isActive(): boolean {
    return this.state === RefreshState.Drag || this.state === RefreshState.OverDrag
  }

  /**
   * 获取状态提示文本
   * @returns {string} 状态提示文本
   */
  @Computed
  public get stateTips(): string {
    return this.options.stateTips(this.state, this.dataInfo)
  }

  /**
   * 更新移动距离
   * @param distance 拖动距离
   */
  public onMoveUpdate(distance: number): void {
    this.dragOffset = Math.max(distance, 0)
    this.isDragging = true
    if (this.state === RefreshState.Refresh) {
      return
    }
    if (distance < this.options.height) {
      this.state = RefreshState.Drag
    } else {
      this.state = RefreshState.OverDrag
    }
  }

  /**
   * 结束移动
   */
  public onMoveEnd(): void {
    if (this.state === RefreshState.OverDrag) {
      this.state = RefreshState.Refresh
      this.dragOffset = this.options.height
      this.onRefresh?.().then((dataInfo) => {
        if (dataInfo === undefined) {
          this.dataInfo = undefined
        } else {
          this.dataInfo = dataInfo as RefreshDataInto
        }
        this.endRefreshing()
      }).catch((_: Error) => {
        this.dataInfo = undefined
        this.endRefreshing()
      })
    } else {
      this._endRefreshing()
    }
    this.isDragging = false
  }

  /**
   * 开始刷新
   */
  public beginRefreshing(): void {
    if (this.isRefreshing) {
      return
    }
    this.state = RefreshState.Refresh
    this.dragOffset = this.options.height
    this.onRefresh?.().then((dataInfo) => {
      if (dataInfo === undefined) {
        this.dataInfo = undefined
      } else {
        this.dataInfo = dataInfo as RefreshDataInto
      }
      this.endRefreshing()
    }).catch((_: Error) => {
      this.dataInfo = undefined
      this.endRefreshing()
    })
  }

  /**
   * 结束刷新
   */
  public endRefreshing(): void {
    this.dragOffset = this.options.tipsHeight
    this.state = RefreshState.Done
    animateTo({
      duration: this.options.bounceAnimationDuration,
      curve: Curve.EaseOut,
      delay: 150,
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
   * 重置数据状态
   */
  resetDataState(): void {
    this.dataInfo = undefined
  }

  /**
   * 结束刷新
   */
  private _endRefreshing(): void {
    animateTo({
      duration: this.options.bounceAnimationDuration, onFinish: () => {
        this.dragOffset = 0;
        this.state = RefreshState.Inactive
      }
    }, () => {
      this.dragOffset = 0;
    })
  }
}

