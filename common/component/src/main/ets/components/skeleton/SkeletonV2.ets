import { AnimatorOptions, AnimatorResult } from '@kit.ArkUI';
import { SkeletonUtils } from './SkeletonUtils';

/**
 * 自定义动画配置接口，用于定义骨架屏的动画效果。
 */
export interface SkeletonCustomAnimationV2 {
  /**
   * 线性渐变配置。
   */
  linearGradient?: LinearGradient;

  /**
   * 动画参数配置。
   */
  animatorOptions?: AnimatorOptions;

  /**
   * 动画回调函数。
   * @param progress 动画进度。
   */
  onFrame?: (progress: number) => void;

  /**
   * 动画取消回调函数。
   */
  onCancel?: () => void;

  /**
   * 动画结束回调函数。
   */
  onFinish?: () => void;

  /**
   * 动画重复回调函数。
   */
  onRepeat?: () => void;
}

/**
 * 骨架屏组件，用于在数据加载时显示占位动画。
 */
@ComponentV2
export struct SkeletonV2 {
  /**
   * 行数，默认为1。
   */
  @Param public lineCount: number = 1;
  /**
   * 每行的高度，默认为18。
   */
  @Param public lineHeight: Length = 18;
  /**
   * 最后一行的宽度，默认为100%。
   */
  @Param public lastLineWidth: Length = '100%';
  /**
   * 行间距，默认为10。
   */
  @Param public lineSpace: string | number = 10;
  /**
   * 行的圆角半径，默认为0。
   */
  @Param public lineRadius: Length | BorderRadiuses = 0;
  /**
   * 是否启用动画，默认为true。
   */
  @Param public animated: boolean = true;
  /**
   * 动画持续时间，默认为1400毫秒。
   */
  @Param public duration: number = 1400;
  /**
   * 基础颜色，默认为#f3f3f3。
   */
  @Param public baseColor: string = '#f3f3f3';
  /**
   * 动画颜色，默认为#e3e3e3。
   */
  @Param public animateColor: string = '#e3e3e3';
  /**
   * 自定义动画配置。
   */
  @Param customAnimation?: SkeletonCustomAnimationV2 = undefined
  /**
   * 线性渐变颜色数组。
   */
  @Local private _linearColors: [string, number][] =
    [[this.animateColor, 0], [this.baseColor, 0.22], [this.baseColor, 0.48]];
  /**
   * 标记组件是否已出现。
   */
  @Local private _isAppear: boolean = false
  /**
   * 标记组件是否已初始化。
   */
  private _hasInit: boolean = false;
  /**
   * 动画实例。
   */
  private _animator?: AnimatorResult

  /**
   * 获取线性渐变配置。
   */
  @Computed
  private get _linearGradient(): LinearGradient | undefined {
    if (!this.animated) {
      return undefined
    }
    return this.customAnimation?.linearGradient || {
      direction: GradientDirection.Right,
      repeating: false,
      colors: this._linearColors,
    };
  }

  /**
   * 计算是否需要启动动画。
   */
  @Computed
  private get _startAnimation(): boolean {
    return this.animated && this._isAppear
  }

  /**
   * 组件即将出现时的生命周期方法。
   */
  aboutToAppear(): void {
  }

  /**
   * 组件即将消失时的生命周期方法。
   */
  aboutToDisappear(): void {
    if (this._animator !== undefined) {
      this._animator.cancel()
      this._animator = undefined
    }
  }

  /**
   * 构建组件的UI结构。
   */
  build() {
    Column({ space: this.lineSpace }) {
      ForEach(new Array(this.lineCount).fill(1), (_: number, index: number) => {
        Row()
          .width(index === this.lineCount - 1 ? this.lastLineWidth : '100%')
          .height(this.lineHeight)
          .borderRadius(this.lineRadius)
          .backgroundColor(this.animated ? this.animateColor : this.baseColor)
          .linearGradient(this._linearGradient)
          .onAppear(() => {
            this._isAppear = true
          })
          .onDisAppear(() => {
            this._isAppear = false
          });
      });
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start);
  }

  /**
   * 获取动画参数配置。
   */
  private _getAnimatorOptions(): AnimatorOptions {
    return this.customAnimation?.animatorOptions || {
      duration: this.duration,
      easing: "ease",
      delay: 0,
      fill: "none",
      direction: "alternate",
      iterations: -1,
      begin: 0,
      end: 1
    }
  }

  /**
   * 监听属性的变化。
   */
  @Monitor('_startAnimation')
  private _onStartAnimationChange(monitor: IMonitor) {
    const value = monitor.value<boolean>();
    if (value !== undefined) {
      if (value.now) {
        if (this._animator !== undefined) {
          this._animator.reset(this._getAnimatorOptions())
        } else {
          this._animator = this.getUIContext().createAnimator(this._getAnimatorOptions())
          this._animator.onFrame = (progress) => {
            if (this.customAnimation?.onFrame) {
              this.customAnimation.onFrame(progress);
              return;
            }

            // 根据进度动态设置线性渐变颜色
            this._linearColors = SkeletonUtils.interpolateColors(
              [[this.animateColor, 0], [this.baseColor, 0.22], [this.baseColor, 0.48]],
              [[this.baseColor, 0.63], [this.baseColor, 0.74], [this.animateColor, 1]],
              progress
            )
          }
          // 取消或者结束 恢复初始化状态
          this._animator.onCancel = () => {
            if (this.customAnimation?.onCancel) {
              this.customAnimation.onCancel();
              return;
            }
            this._linearColors = [[this.animateColor, 0], [this.baseColor, 0.22], [this.baseColor, 0.48]]
          }
          this._animator.onFinish = () => {
            if (this.customAnimation?.onFinish) {
              this.customAnimation.onFinish();
              return;
            }
            this._linearColors = [[this.animateColor, 0], [this.baseColor, 0.22], [this.baseColor, 0.48]]
          }
          this._animator.onRepeat = () => {
            if (this.customAnimation?.onRepeat) {
              this.customAnimation.onRepeat();
            }
          }
        }
        this._animator.play()
      } else {
        if (this._animator !== undefined) {
          this._animator.cancel()
        }
      }
    }
  }
}