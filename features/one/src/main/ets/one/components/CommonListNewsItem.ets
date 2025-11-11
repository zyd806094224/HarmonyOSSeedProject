import { CommonNewsModel } from "../model/CommonListModel";
import { LengthMetrics } from "@kit.ArkUI";
import { SkeletonV2 } from "component";


@ComponentV2
export struct CommonListNewsItem{
  /**
   * 模型数据
   */
  @Param @Require model: CommonNewsModel;
  /**
   * 需要加载加载
   */
  @Local private needLoad: boolean = true
  /**
   * 是否开启动画
   */
  @Local private animated: boolean = true

  /**
   * 构建函数
   */
  build() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Start,
      space: { main: LengthMetrics.vp(10) }
    }) {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Stretch,
        space: { main: LengthMetrics.vp(10) }
      }) {
        Text(this.model.title)
          .fontSize(16)
          .lineHeight(22)
          .maxLines(2)
          .fontColor('#2d2d2d')
          .fontWeight(FontWeight.Regular)
          .fontStyle(FontStyle.Normal)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .flexShrink(1)
        Row({ space: 10 }) {
          Text('测试数据11111')
            .fontSize(12)
            .maxLines(1)
            .fontColor('#999999')
            .fontWeight(FontWeight.Regular)
            .fontStyle(FontStyle.Normal)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .flexShrink(1)

          Text('测试数据222222')
            .fontSize(12)
            .maxLines(1)
            .fontColor('#999999')
            .fontWeight(FontWeight.Regular)
            .fontStyle(FontStyle.Normal)
        }
        .justifyContent(FlexAlign.SpaceBetween)
      }.constraintSize({ minHeight: 73 }).flexGrow(1)

      Stack() {
        Image(this.model.img)
          .borderRadius(4)
          .flexGrow(1)
          .onComplete((event) => {
            this.needLoad = false
            this.animated = false
          })
          .onError(() => {
            this.animated = false
          })
        SkeletonV2({ lineHeight: '100%', lineRadius: 4, animated: this.animated })
          .width('100%')
          .visibility(this.needLoad ? Visibility.Visible : Visibility.Hidden)
      }.constraintSize({ minWidth: 112 }).width(112).height(73)
    }
    .padding(15)
    .width('100%')
  }

}