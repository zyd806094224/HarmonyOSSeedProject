import { TabBarItemOptionsInterface, TabBarOptionsInterface } from "component";
import { ListTabItem } from "../model/ListTabItem";


@ComponentV2
export struct ListTabItemComponent{

  /**
   * 当前选中的Tab栏项目的索引。
   */
  @Param @Require currentItemIndex: number;
  /**
   * 选中的Tab栏项目的索引。
   */
  @Param @Require selectedItemIndex: number;
  /**
   * Tab栏的配置选项。
   */
  @Param @Require tabBarOptions: TabBarOptionsInterface;
  /**
   * 当前Tab栏项目的配置选项。
   */
  @Param @Require item: ListTabItem;

  /**
   * 计算属性，判断当前项目是否被选中。
   */
  @Computed
  private get isSelected(): boolean {
    return this.currentItemIndex === this.selectedItemIndex;
  }

  /**
   * 构建Tab栏项目的UI。
   */
  build() {
    Column() {
      Text(this.item.title)
        ._ItemExtend(this.isSelected, this.tabBarOptions.itemOptions)
        .alignSelf(TextAlign2ItemAlign(this.tabBarOptions.itemOptions.textAlign ?? TextAlign.Center))
        .onAreaChange((_, newArea) => {

        });
    }
    .justifyContent(FlexAlign.Center)
    .width(this.tabBarOptions.itemOptions.width)
    .height(this.tabBarOptions.itemOptions.height)
    .margin(this.tabBarOptions.itemOptions.margin)
    .animation({ duration: this.tabBarOptions.itemOptions.selectedFontColorAnimationDuration, curve: Curve.Linear })
    .backgroundColor(this.isSelected ? this.tabBarOptions.itemOptions.selectedBackgroundColor :
    this.tabBarOptions.itemOptions.backgroundColor)
    .border(this.isSelected ? this.tabBarOptions.itemOptions.selectedBorder : this.tabBarOptions.itemOptions.border);
  }
}

/**
 * 扩展Text组件，用于设置Tab栏项目文本的通用样式。
 */
@Extend(Text)
function _ItemExtend(isSelected: boolean, options: TabBarItemOptionsInterface) {
  .fontColor(isSelected ? options.selectedFontColor : options.fontColor)
  .font(isSelected ? options.selectedFont : options.font)
  .textAlign(options.textAlign)
  .maxLines(options.maxLines)
  // .animation({ duration: options.selectedFontColorAnimationDuration, curve: Curve.Linear })
}

/**
 * 将TextAlign转换为Alignment。
 * @param textAlign - TextAlign枚举值。
 * @returns 对应的Alignment枚举值。
 */
function TextAlign2ItemAlign(textAlign: TextAlign): ItemAlign {
  switch (textAlign) {
    case TextAlign.Start:
      return ItemAlign.Start;
    case TextAlign.Center:
      return ItemAlign.Center;
    case TextAlign.End:
      return ItemAlign.End;
    default:
      return ItemAlign.Center;
  }
}