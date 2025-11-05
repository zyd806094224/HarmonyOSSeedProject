import { WindowUtils } from '../../utils/WindowUtils';
import { window } from '@kit.ArkUI';
import { SafeAreaControlSpace } from './SafeAreaControl.type';

/**
 * 安全区控制器组件，用于处理窗口的安全区域。
 */
@ComponentV2
export struct SafeAreaControl {
  /**
   * 顶部安全区高度。
   */
  @Local topHeight: number = 0;
  /**
   * 底部安全区高度。
   */
  @Local bottomHeight: number = 0;
  /**
   * 左侧安全区宽度。
   */
  @Local leftWidth: number = 0;
  /**
   * 右侧安全区宽度。
   */
  @Local rightWidth: number = 0;
  /**
   * 内容构建器，用于定义组件的内容。
   */
  @BuilderParam contentBuilder: () => void;
  /**
   * 内容的内边距。
   */
  @Param contentPadding: Padding | Length = 0;
  /**
   * 控制器的背景颜色。
   */
  @Param controlBackgroundColor: ResourceColor = Color.Transparent;
  /**
   * 安全区的自定义空间配置。
   */
  @Param space: SafeAreaControlSpace | undefined = undefined;

  /**
   * 组件即将出现时的生命周期方法，用于获取窗口的避免区域。
   */
  aboutToAppear(): void {
    WindowUtils.getWindowAvoidArea().then((res: window.AvoidArea) => {
      this.topHeight = this.space?.top ?? px2vp(res.topRect.height);
      this.bottomHeight = this.space?.bottom ?? px2vp(res.bottomRect.height);
      this.leftWidth = this.space?.left ?? px2vp(res.leftRect.width);
      this.rightWidth = this.space?.right ?? px2vp(res.rightRect.width);
    });
  }

  /**
   * 监听 `space` 参数的变化，更新安全区的尺寸。
   * @param monitor 监控对象。
   */
  @Monitor('space')
  onSpaceChange(monitor: IMonitor) {
    const value = monitor.value<SafeAreaControlSpace>();
    this.topHeight = value?.now.top || this.topHeight;
    this.bottomHeight = value?.now.bottom || this.bottomHeight;
    this.leftWidth = value?.now.left || this.leftWidth;
    this.rightWidth = value?.now.right || this.rightWidth;
  }

  /**
   * 构建组件的UI结构。
   */
  build() {
    Column() {
      if (this.topHeight) {
        Row().width('100%').height(this.topHeight);
      }

      Row() {
        if (this.leftWidth) {
          Column().width(this.leftWidth).height('100%');
        }
        Column() {
          this.contentBuilder();
        }.height('100%').layoutWeight(1).padding(this.contentPadding);

        if (this.rightWidth) {
          Column().width(this.rightWidth).height('100%');
        }
      }.width('100%').layoutWeight(1);

      if (this.bottomHeight) {
        Row().width('100%').height(this.bottomHeight);
      }
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
    .backgroundColor(this.controlBackgroundColor);
  }
}
