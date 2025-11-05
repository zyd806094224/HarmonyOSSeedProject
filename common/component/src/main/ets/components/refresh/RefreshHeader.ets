import { RefreshHeaderController } from './RefreshHeaderController';
import { Logger } from '../../utils/Logger';
import { RefreshState } from './RefreshState';
import { CanvasUtil } from './CanvasUtil';

/**
 * HeaderView组件，用于显示刷新头部视图
 * 提供刷新状态、加载图标状态、文本和上次刷新时间等参数
 */
@ComponentV2
export struct RefreshHeader {
  /**
   * Header刷新控制器
   * @type {RefreshHeaderController}
   */
  @Param @Require controller: RefreshHeaderController;
  /**
   * 创建一个CanvasRenderingContext2D对象，用于绘制加载图标
   */
  private canvas: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true));

  /**
   * 计算属性，获取上次刷新时间的格式化字符串
   * @returns {string} 格式化的上次刷新时间字符串
   */
  @Computed
  private get refreshTimeText(): string {
    return this.convertTimeToYMD(this.controller.lastRefreshTime);
  }

  /**
   * 构建HeaderView的UI
   * 根据刷新状态和加载图标状态显示不同的视图
   * 包含刷新图标和文本信息的布局
   */
  build() {
    // 创建一个水平布局，元素之间有10px间距
    Row({ space: 10 }) {
      // 根据刷新状态显示不同的图标
      if (this.controller.state === RefreshState.Refresh) {
        // 显示加载中的图标
        // Image($r("app.media.refresh_pull_loading_icon"))
        //   .width(20)
        //   .aspectRatio(1);
        LoadingProgress()
          .width(CanvasUtil.getWidth(this.controller.options.refreshHeight))
          .height(this.controller.options.refreshHeight)
          .color(this.controller.options.textColor)
      } else if (this.controller.state !== RefreshState.Done) {
        // 显示上下拉图标，并根据状态旋转
        Canvas(this.canvas)
          .width(this.controller.options.refreshHeight)
          .height(this.controller.options.refreshHeight)
          .onReady(() => {
            CanvasUtil.initSatelliteCanvas(this.canvas, this.controller.options.refreshHeight,
              this.controller.options.refreshColor)
          })
        // Image($r("app.media.refresh_down_icon"))
        //   .width(10)
        //   .height(20)
        //   .rotate({
        //     angle: this.controller.state === RefreshState.OverDrag ? 180 : 0,
        //   })
        //   .animation({
        //     duration: 400
        //   });
      }
      // 显示文本信息和上次更新时间
      Column({ space: 5 }) {
        // 显示当前刷新状态的提示文本
        Text(this.controller.stateTips)
          .font(this.controller.options.textFont)
          .fontColor(this.controller.options.textColor);
        if ((this.controller.state !== RefreshState.Done)) {
          // 显示上次更新的时间
          Text(`上次更新: ${this.refreshTimeText}`)
            .font(this.controller.options.textFont)
            .fontColor(this.controller.options.textColor);
        }
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(this.controller.options.height);
  }

  /**
   * 监听刷新状态的变化，并根据状态更新加载图标和文本信息
   * @param monitor 监听器对象，用于获取刷新状态的变化
   */
  @Monitor('controller.dragPercent')
  private onDragPercentChange(monitor: IMonitor): void {
    const value = monitor.value<number>()
    if (value !== undefined) {
      CanvasUtil.drawSatelliteCanvas(this.canvas, this.controller.options.refreshHeight, value.now)
    }
  }

  /**
   * 将时间戳转换为年月日格式的字符串
   * @param timestamp 时间戳
   * @returns 转换后的年月日格式字符串，如果转换失败则返回'--'
   */
  private convertTimeToYMD(timestamp: number): string {
    try {
      // 确保时间戳是有效的数字
      timestamp = Number(timestamp);
      if (isNaN(timestamp) || !isFinite(timestamp)) {
        throw new Error('Invalid timestamp');
      }

      // 创建日期对象
      const date = new Date(timestamp);
      if (isNaN(date.getTime()) || date.getTime() < 0 || date.getTime() > Number.MAX_SAFE_INTEGER) {
        throw new Error('Failed to create valid Date object for the given timestamp:' + timestamp);
      }

      // 获取年、月、日、时、分并格式化
      const year = date.getUTCFullYear();
      const month = String(date.getUTCMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hour = String(date.getHours()).padStart(2, '0');
      const minute = String(date.getMinutes()).padStart(2, '0');

      // 返回格式化的日期字符串
      return `${month}-${day} ${hour}:${minute}`;
    } catch (error) {
      // 记录错误日志并返回默认值
      Logger.e('HeaderView', `Error converting timestamp to YMD format: ${error.message}`);
      return '--'; // 返回默认值
    }
  }
}
