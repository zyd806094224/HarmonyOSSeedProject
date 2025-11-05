import { RefreshDataState } from './RefreshDataState';
import { RefreshFooterController } from './RefreshFooterController';
import { RefreshState } from './RefreshState';

/**
 * 定义一个组件，用于展示列表的底部视图，包括加载更多和没有更多数据的状态
 */
@ComponentV2
export struct RefreshFooter {
  /**
   * 底部刷新控制器
   * @type {RefreshFooterController}
   */
  @Param @Require controller: RefreshFooterController;

  /**
   * 计算属性，判断是否结束加载更多
   * @returns {boolean} 是否结束加载更多
   */
  @Computed
  private get isFinished(): boolean {
    // 根据数据状态判断是否结束
    if (this.controller.dataInfo !== undefined) {
      return this.controller.dataInfo.state === RefreshDataState.NoMore;
    }
    return false;
  }

  /**
   * 构建组件的主要结构，包含底部显示视图
   */
  build() {
    // 创建一个水平布局，元素之间有10px间距
    Row({ space: 10 }) {
      // 如果没有结束，则根据刷新状态显示不同的图标
      if (!this.isFinished) {
        // 根据刷新状态显示不同的图标
        if (this.controller.state === RefreshState.Refresh) {
          // 显示加载中的图标
          Image($r("app.media.refresh_pull_loading_icon"))
            .width(20)
            .aspectRatio(1);
        } else if (this.controller.state !== RefreshState.Done) {
          // 显示上下拉图标，并根据状态旋转
          Image($r("app.media.refresh_down_icon"))
            .width(10)
            .height(20)
            .rotate({
              angle: this.controller.state === RefreshState.OverDrag ? 0 : 180,
            })
            .animation({
              duration: 400
            });
        }
      }

      // 显示文本信息，使用控制器配置的字体和颜色
      Text(this.controller.stateTips)
        .font(this.controller.options.textFont)
        .fontColor(this.controller.options.textColor);
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(this.controller.options.height);
  }
}
