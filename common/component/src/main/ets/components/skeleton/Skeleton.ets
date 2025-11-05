/**
 * 自定义动画配置接口，用于定义骨架屏的动画效果。
 */
export interface SkeletonCustomAnimation {
  /**
   * 线性渐变配置。
   */
  linearGradient?: LinearGradient;

  /**
   * 动画参数配置。
   */
  animationParams?: AnimateParam;

  /**
   * 动画回调函数。
   */
  callback?: () => void;
}

/**
 * 骨架屏组件，用于在数据加载时显示占位动画。
 */
@ComponentV2
export struct Skeleton {
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
  @Param customAnimation?: SkeletonCustomAnimation = undefined;
  /**
   * 线性渐变颜色数组。
   */
  @Local private linearColors: [ResourceColor, number][] =
    [[this.animateColor, 0], [this.baseColor, 0.22], [this.baseColor, 0.48]];

  /**
   * 组件即将出现时的生命周期方法。
   */
  aboutToAppear(): void {
    if (this.animated && this.customAnimation === undefined) {
      this.linearColors = [[this.animateColor, 0], [this.baseColor, 0.22], [this.baseColor, 0.48]];
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
          .linearGradient(this.animated ?
            (this.customAnimation?.linearGradient ? this.customAnimation.linearGradient : {
              direction: GradientDirection.Right,
              repeating: false,
              colors: this.linearColors,
            }) : undefined)
          .onAppear(() => {
            if (this.animated) {
              animateTo(this.customAnimation?.animationParams ? this.customAnimation.animationParams : {
                duration: this.duration,
                iterations: -1,
                curve: Curve.Ease,
                playMode: PlayMode.Alternate
              }, () => {
                if (this.customAnimation?.callback) {
                  this.customAnimation.callback();
                  return;
                }
                this.linearColors = [[this.baseColor, 0.63], [this.baseColor, 0.74], [this.animateColor, 1]];
              });
            }
          });
      });
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start);
  }
}
