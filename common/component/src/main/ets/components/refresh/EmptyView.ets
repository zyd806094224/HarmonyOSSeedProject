import { CanvasUtil } from './CanvasUtil';

/**
 * 定义空视图的状态接口，包含图标、消息文本、字体大小和颜色等属性
 */
export interface EmptyViewStatus {
  /**
   * 图标资源路径
   * @type {ResourceStr}
   */
  icon: ResourceStr;

  /**
   * 消息文本
   * @type {string}
   */
  message: string;

  /**
   * 字体大小，可以是数字、字符串或资源引用
   * @type {number | string | Resource}
   */
  fontSize: number | string | Resource;

  /**
   * 字体颜色
   * @type {ResourceColor}
   */
  fontColor: ResourceColor;

  /**
   * 是否显示加载动画
   * @type {boolean}
   */
  showLoadingAnimator: boolean
}

/**
 * 定义无数据状态的空视图配置
 */
export const EMPTY_VIEW_NODATA: EmptyViewStatus = {
  icon: $r("app.media.refresh_status_noData_icon"),
  message: '暂无内容',
  fontSize: 16,
  fontColor: '#929194',
  showLoadingAnimator: false
};

/**
 * 定义加载中状态的空视图配置
 */
export const EMPTY_VIEW_LOADING: EmptyViewStatus = {
  icon: $r("app.media.refresh_status_loading_icon"),
  message: '加载中...',
  fontSize: 16,
  fontColor: '#929194',
  showLoadingAnimator: true
};

/**
 * 定义网络错误状态的空视图配置
 */
export const EMPTY_VIEW_NETWORK_ERROR: EmptyViewStatus = {
  icon: $r("app.media.refresh_status_network_error_icon"),
  message: '无网络点击重新加载',
  fontSize: 16,
  fontColor: '#929194',
  showLoadingAnimator: false
};

/**
 * 定义空视图组件，用于展示不同状态下的空视图
 */
@ComponentV2
export struct EmptyView {
  /**
   * 空状态配置
   * @type {EmptyViewStatus}
   */
  @Param @Require status: EmptyViewStatus;
  /**
   * 点击事件回调
   * @type {() => void}
   */
  @Event onTapped?: () => void;
  /**
   * 配置触摸行为模式
   * @type {HitTestMode}
   */
  @Param hitTestMode: HitTestMode = HitTestMode.Default;

  build() {
    // 布局空视图，包含图标和文本，点击可触发事件
    Column() {
      Column({ space: 24 }) {
        // 显示图标，默认使用无数据状态的图标
        Image(this.status.icon || $r("app.media.refresh_status_noData_icon"))
          .objectFit(ImageFit.Auto)
          .width(220)
          .height(230);
        Row({ space: 10 }) {
          if (this.status.showLoadingAnimator) {
            LoadingProgress()
              .width(CanvasUtil.getWidth(24))
              .height(24)
              .color(this.status.fontColor || '#929194')
          }
          // 显示消息文本，默认使用“暂无内容”
          Text(this.status.message || '暂无内容')
            .fontSize(this.status.fontSize || 16)
            .fontColor(this.status.fontColor || '#929194')
            .textAlign(TextAlign.Center);
        }
      }
      .onClick((_) => {
        // 触发点击事件回调
        this.onTapped && this.onTapped();
      });
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .hitTestBehavior(this.hitTestMode)
    .width('100%')
    .height('100%');
  }
}
