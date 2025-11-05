import { TabBarItemOptionsInterface, TabBarOptionsInterface } from './TabBarOptions';
import { TabBarItemInterface } from './TabBarItem';
import { ReferenceTabBarInterface } from './ReferenceTabBarInterface';

/**
 * 定义Tab栏项目的组件，用于渲染单个Tab栏项目。
 */
@ComponentV2
export struct TabBarItemComponent {
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
  @Param @Require item: TabBarItemInterface;
  /**
   * 自定义Tab栏项目的构建函数。
   */
  @BuilderParam customItemBuilder?: (props: ReferenceTabBarInterface) => void;

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
    if (this.customItemBuilder !== undefined) {
      // 使用自定义构建函数构建Tab栏项目
      this.customItemBuilder({
        currentItemIndex: this.currentItemIndex,
        selectedItemIndex: this.selectedItemIndex,
        tabBarOptions: this.tabBarOptions,
        item: this.item
      });
    } else {
      // 使用默认构建方式构建Tab栏项目
      Text(this.item.title)
        .ItemTextCommonExtend(this.isSelected, this.tabBarOptions.itemOptions);
    }
  }
}

/**
 * 扩展Text组件，用于设置Tab栏项目文本的通用样式。
 */
@Extend(Text)
function ItemTextCommonExtend(isSelected: boolean, options: TabBarItemOptionsInterface) {
  .fontColor(isSelected ? options.selectedFontColor : options.fontColor)
  .animation({ duration: options.selectedFontColorAnimationDuration, curve: Curve.Linear })
  .font(isSelected ? options.selectedFont : options.font)
  .textAlign(options.textAlign)
  .backgroundColor(isSelected ? options.selectedBackgroundColor : options.backgroundColor)
  .border(isSelected ? options.selectedBorder : options.border)
  .margin(options.margin)
  .maxLines(options.maxLines)
  .width(options.width)
  .height(options.height);
}
