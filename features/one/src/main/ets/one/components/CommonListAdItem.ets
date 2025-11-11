import { SkeletonV2 } from "component"
import { CommonNewsAdModel } from "../model/CommonListModel"


@ComponentV2
export struct CommonListAdItem{

  /**
   * 广告数据
   */
  @Param @Require model: CommonNewsAdModel
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
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Stretch,
    }) {
      Stack() {
        Image(this.model.imagePath)
          .aspectRatio(345.0 / 146.0)
          .width('100%')
          .flexGrow(1)
          .onComplete((event) => {
            this.needLoad = false
            this.animated = false
          })
          .onError(() => {
            this.animated = false
          })
        SkeletonV2({ lineHeight: '100%', animated: this.animated })
          .flexGrow(1)
          .aspectRatio(345.0 / 146.0)
          .width('100%')
          .visibility(this.needLoad ? Visibility.Visible : Visibility.Hidden)
      }
    }.width('100%').padding(15)
  }
}