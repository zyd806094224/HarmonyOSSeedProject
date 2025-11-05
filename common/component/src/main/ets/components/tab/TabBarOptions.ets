/**
 * 定义Tab栏项目配置接口，用于定制Tab栏项目的外观和行为。
 */
export interface TabBarItemOptionsInterface {
  /**
   * 最大行数。
   */
  maxLines?: number;

  /**
   * 字体样式，用于定义Tab栏项目的文本字体。
   */
  font: Font;

  /**
   * 选中时的字体样式。如果未提供，则使用默认的`font`属性值。
   */
  selectedFont?: Font;

  /**
   * 字体颜色，用于定义Tab栏项目的文本颜色。
   */
  fontColor: ResourceColor;

  /**
   * 选中时的字体颜色。如果未提供，则使用默认的`fontColor`属性值。
   */
  selectedFontColor?: ResourceColor;

  /**
   * 选中时字体颜色变化的动画持续时间（毫秒）。用于平滑过渡字体颜色的变化。
   */
  selectedFontColorAnimationDuration: number;

  /**
   * 文本对齐方式，用于控制Tab栏项目中文本的对齐方式。
   */
  textAlign?: TextAlign;

  /**
   * 背景颜色，用于定义Tab栏项目的背景颜色。
   */
  backgroundColor?: ResourceColor;

  /**
   * 选中时的背景颜色。如果未提供，则使用默认的`backgroundColor`属性值。
   */
  selectedBackgroundColor?: ResourceColor;

  /**
   * 宽度，用于定义Tab栏项目的宽度。
   */
  width?: Length;

  /**
   * 高度，用于定义Tab栏项目的高度。
   */
  height?: Length;

  /**
   * 边框样式，用于定义Tab栏项目的边框。
   */
  border?: BorderOptions;

  /**
   * 选中时的边框样式。如果未提供，则使用默认的`border`属性值。
   */
  selectedBorder?: BorderOptions;

  /**
   * 外边距，用于定义Tab栏项目的外边距。
   */
  margin?: Margin;

  /**
   * 动画持续时间（毫秒），用于定义Tab栏项目在状态变化时的动画持续时间。
   */
  animationDuration?: number;
}

/**
 * 实现Tab栏项目配置接口的具体类，提供默认配置值。
 */
@ObservedV2
export class TabBarItemOptions implements TabBarItemOptionsInterface {
  /**
   * 默认最大行数为1。
   */
  @Trace
  public maxLines?: number = 1;
  /**
   * 默认字体样式，大小为15px，常规粗细，正常样式。
   */
  @Trace
  public font: Font = { size: 15, weight: FontWeight.Regular, style: FontStyle.Normal };
  /**
   * 选中时的字体样式，默认与非选中状态相同。
   */
  @Trace
  public selectedFont?: Font = { size: 15, weight: FontWeight.Regular, style: FontStyle.Normal };
  /**
   * 默认字体颜色为黑色。
   */
  @Trace
  public fontColor: ResourceColor = Color.Black;
  /**
   * 选中时的字体颜色为蓝色。
   */
  @Trace
  public selectedFontColor: ResourceColor = Color.Blue;
  /**
   * 选中时字体颜色变化的动画持续时间为200毫秒。
   */
  @Trace
  public selectedFontColorAnimationDuration: number = 200;
  /**
   * 默认文本对齐方式为居中对齐。
   */
  @Trace
  public textAlign?: TextAlign = TextAlign.Center;
  /**
   * 默认背景颜色为透明。
   */
  @Trace
  public backgroundColor: ResourceColor = Color.Transparent;
  /**
   * 选中时的背景颜色为透明。
   */
  @Trace
  public selectedBackgroundColor: ResourceColor = Color.Transparent;
  /**
   * 宽度未指定，默认为自适应。
   */
  @Trace
  public width?: Length;
  /**
   * 高度未指定，默认为自适应。
   */
  @Trace
  public height?: Length;
  /**
   * 默认边框样式为无边框（半径、宽度为0，颜色为白色）。
   */
  @Trace
  public border?: BorderOptions = { radius: 0, width: 0, color: Color.White };
  /**
   * 选中时的边框样式默认与非选中状态相同。
   */
  @Trace
  public selectedBorder?: BorderOptions = { radius: 0, width: 0, color: Color.White };
  /**
   * 默认外边距为0。
   */
  @Trace
  public margin?: Padding = {
    left: 0,
    right: 0,
    top: 0,
    bottom: 0
  };
  /**
   * 状态变化时的动画持续时间为300毫秒。
   */
  @Trace
  public animationDuration?: number = 300;
}

/**
 * 定义Tab栏指示器的配置接口，用于定制指示器的外观和行为。
 */
export interface TabBarIndicatorOptionsInterface {
  /**
   * 指示器的宽度。
   */
  width?: number;

  /**
   * 指示器的高度。
   */
  height?: number;

  /**
   * 指示器的边框样式。
   */
  border?: BorderOptions;

  /**
   * 指示器的外边距。
   */
  margin?: Margin;

  /**
   * 指示器的颜色。
   */
  color?: ResourceColor;

  /**
   * 指示器的位置，可选值为 `Top`、`Center`、`Bottom`。
   */
  position: IndicatorPosition;

  /**
   * 指示器的动画类型，可选值为 `Linear`、`Linkage`。
   */
  animationType?: IndicatorAnimationType;

  /**
   * 指示器动画的持续时间（毫秒）。
   */
  animationDuration?: number;

  /**
   * 指示器的宽度是否与Tab栏项目相同。
   */
  isSameWidthWithItem?: boolean;

  /**
   * 指示器的高度是否与Tab栏项目相同。
   */
  isSameHeightWithItem?: boolean;

  /**
   * 是否隐藏指示器。
   */
  isHide?: boolean;
}

/**
 * 实现Tab栏指示器配置接口的具体类，提供默认配置值。
 */
@ObservedV2
export class TabBarIndicatorOptions implements TabBarIndicatorOptionsInterface {
  /**
   * 默认指示器宽度为20。
   */
  @Trace
  public width?: number = 20;
  /**
   * 默认指示器高度为4。
   */
  @Trace
  public height?: number = 4;
  /**
   * 默认指示器边框样式，半径为2。
   */
  @Trace
  public border?: BorderOptions = { radius: 2 };
  /**
   * 默认指示器外边距，顶部为10，其他方向为0。
   */
  @Trace
  public margin?: Padding = {
    left: 0,
    right: 0,
    top: 10,
    bottom: 0
  };
  /**
   * 默认指示器颜色为蓝色。
   */
  @Trace
  public color?: ResourceColor = Color.Blue;
  /**
   * 默认指示器位置为底部。
   */
  @Trace
  public position: IndicatorPosition = IndicatorPosition.Bottom;
  /**
   * 默认指示器动画类型为线性。
   */
  @Trace
  public animationType?: IndicatorAnimationType = IndicatorAnimationType.Linear;
  /**
   * 默认指示器动画持续时间为300毫秒。
   */
  @Trace
  public animationDuration?: number = 300;
  /**
   * 默认指示器宽度不与Tab栏项目相同。
   */
  @Trace
  public isSameWidthWithItem?: boolean = false;
  /**
   * 默认指示器高度不与Tab栏项目相同。
   */
  @Trace
  public isSameHeightWithItem?: boolean = false;
  /**
   * 默认指示器不隐藏。
   */
  @Trace
  public isHide?: boolean = false;
}


/**
 * 定义Tab栏左右项目的配置接口，用于定制左右项目的外观和行为。
 */
export interface TabBarLeftRightItemOptionsInterface {
  /**
   * 是否固定显示左右项目。
   */
  isFixed?: boolean;

  /**
   * 左右项目的高度是否与Tab栏相同。
   */
  isSameHeightWithTabBar?: boolean;

  /**
   * 是否隐藏左右项目。
   */
  isHide?: boolean;
}

/**
 * 实现Tab栏左右项目配置接口的具体类，提供默认配置值。
 */
@ObservedV2
export class TabBarLeftRightItemOptions implements TabBarLeftRightItemOptionsInterface {
  /**
   * 默认左右项目固定显示。
   */
  @Trace
  public isFixed?: boolean = true;
  /**
   * 默认左右项目的高度与Tab栏相同。
   */
  @Trace
  public isSameHeightWithTabBar?: boolean = true;
  /**
   * 默认不隐藏左右项目。
   */
  @Trace
  public isHide?: boolean = false;
}

/**
 * 定义Tab栏的配置接口，用于定制Tab栏的外观和行为。
 */
export interface TabBarOptionsInterface {
  /**
   * Tab栏项目的配置选项。
   */
  itemOptions: TabBarItemOptionsInterface;

  /**
   * Tab栏项目之间的间距。
   */
  itemSpace?: string | number;

  /**
   * 所有Tab栏项目的布局位置。
   */
  itemAlign?: Alignment;

  /**
   * Tab栏项目的分布类型，可选值为 `None`、`SpaceBetween`、`SpaceAround`、`SpaceEvenly`。
   */
  itemDistributionType: TabBarItemDistributionType;

  /**
   * Tab栏项目的垂直对齐方式。
   */
  verticalAlign?: VerticalAlign;

  /**
   * 指示器的配置选项。
   */
  indicatorOptions: TabBarIndicatorOptionsInterface;

  /**
   * Tab栏是否可滚动，可选值为 `Horizontal`、`Vertical`。
   */
  scrollable?: ScrollDirection;

  /**
   * 左侧项目的配置选项。
   */
  leftItemOptions: TabBarLeftRightItemOptionsInterface;

  /**
   * 右侧项目的配置选项。
   */
  rightItemOptions: TabBarLeftRightItemOptionsInterface;

  /**
   * 滚动效果，可选值为 `Spring`、`None`。
   */
  edgeEffect?: EdgeEffect;

  /**
   * Tab栏的背景颜色。
   */
  backgroundColor?: ResourceColor;

  /**
   * Tab栏内容的外边距。
   */
  contentMargin?: Margin;

  /**
   * Tab栏的边框样式。
   */
  border?: BorderOptions;

  /**
   * Tab栏宽度是否填充父容器。
   */
  isWidthFillParent?: boolean;

  /**
   * 当宽度变化时，是否滚动到当前索引位置。
   */
  shouldScrollToCurrentIndexWhenWidthChanged?: boolean;

  /**
   * 使Tab栏项目尽量滚动到中间位置的偏移量。
   */
  optimizeOffsetX?: number;

  /**
   * Tab栏动画的持续时间（毫秒）。
   */
  tabsAnimationDuration: number;

  /**
   * Tab栏内容是否可滚动。
   */
  tabContentScrollable: boolean;

  /**
   * 是否启用回收机制。
   */
  enableRecycling: boolean;

  /**
   * 缓存的Tab栏项目数量。
   */
  cachedCount: number;

  /**
   * 是否禁用滑动。
   */
  disableSwipe: boolean;

  /**
   * 是否显示箭头，以及箭头的样式和方向。
   */
  displayArrow: [ArrowStyle | boolean, boolean];
}

/**
 * 实现Tab栏配置接口的具体类，提供默认配置值。
 */
@ObservedV2
export class TabBarOptions implements TabBarOptionsInterface {
  /**
   * 默认Tab栏项目的配置选项。
   */
  @Trace
  public itemOptions: TabBarItemOptions = new TabBarItemOptions();
  /**
   * 默认Tab栏项目之间的间距为20。
   */
  @Trace
  public itemSpace?: string | number = 20;
  /**
   * 默认所有Tab栏项目的布局位置为居中对齐。
   */
  @Trace
  public itemAlign?: Alignment = Alignment.Center;
  /**
   * 默认Tab栏项目的分布类型为None。
   */
  @Trace
  public itemDistributionType: TabBarItemDistributionType = TabBarItemDistributionType.None;
  /**
   * 默认Tab栏项目的垂直对齐方式为顶部对齐。
   */
  @Trace
  public verticalAlign?: VerticalAlign = VerticalAlign.Top;
  /**
   * 默认指示器的配置选项。
   */
  @Trace
  public indicatorOptions: TabBarIndicatorOptions = new TabBarIndicatorOptions();
  /**
   * 默认Tab栏可水平滚动。
   */
  @Trace
  public scrollable?: ScrollDirection = ScrollDirection.Horizontal;
  /**
   * 默认左侧项目的配置选项。
   */
  @Trace
  public leftItemOptions: TabBarLeftRightItemOptions = new TabBarLeftRightItemOptions();
  /**
   * 默认右侧项目的配置选项。
   */
  @Trace
  public rightItemOptions: TabBarLeftRightItemOptions = new TabBarLeftRightItemOptions();
  /**
   * 默认滚动效果为弹簧效果。
   */
  @Trace
  public edgeEffect?: EdgeEffect = EdgeEffect.Spring;
  /**
   * 默认Tab栏的背景颜色为白色。
   */
  @Trace
  public backgroundColor?: ResourceColor = Color.White;
  /**
   * 默认Tab栏内容的外边距为0。
   */
  @Trace
  public contentMargin?: Margin = {
    left: 0,
    right: 0,
    top: 0,
    bottom: 0
  };
  /**
   * 默认Tab栏没有边框样式。
   */
  @Trace
  public border?: BorderOptions = undefined;
  /**
   * 默认Tab栏宽度填充父容器。
   */
  @Trace
  public isWidthFillParent?: boolean = true;
  /**
   * 默认当宽度变化时，滚动到当前索引位置。
   */
  @Trace
  public shouldScrollToCurrentIndexWhenWidthChanged?: boolean = true;
  /**
   * 默认使Tab栏项目尽量滚动到中间位置的偏移量为120。
   */
  @Trace
  public optimizeOffsetX?: number = 120;
  /**
   * 默认Tab栏动画的持续时间为300毫秒。
   */
  @Trace
  public tabsAnimationDuration: number = 300;
  /**
   * 默认Tab栏内容可滚动。
   */
  @Trace
  public tabContentScrollable: boolean = true;
  /**
   * 默认不启用回收机制。
   */
  @Trace
  public enableRecycling: boolean = false;
  /**
   * 默认缓存的Tab栏项目数量为1。
   */
  @Trace
  public cachedCount: number = 1;
  /**
   * 默认不禁用滑动。
   */
  @Trace
  public disableSwipe: boolean = false;
  /**
   * 默认不显示箭头。
   */
  @Trace
  public displayArrow: [ArrowStyle | boolean, boolean] = [false, false];
}

/**
 * 定义指示器的位置枚举。
 */
export enum IndicatorPosition {
  /**
   * 指示器位于顶部。
   */
  Top,

  /**
   * 指示器位于中间。
   */
  Center,

  /**
   * 指示器位于底部。
   */
  Bottom
}

/**
 * 定义指示器的动画类型枚举。
 */
export enum IndicatorAnimationType {
  /**
   * 线性动画，指示器平滑移动。
   */
  Linear,

  /**
   * 关联动画，指示器与选项卡项联动移动。
   */
  Linkage
}

/**
 * 定义Tab栏项目分布类型的枚举。
 */
export enum TabBarItemDistributionType {
  /**
   * 不进行任何分布处理。
   */
  None,

  /**
   * 项目之间均匀分布，两端不留空隙。
   */
  SpaceBetween,

  /**
   * 项目之间均匀分布，两端留有空隙。
   */
  SpaceAround,

  /**
   * 项目之间均匀分布，每个项目之间的间距相等。
   */
  SpaceEvenly
}

/**
 * 将标签栏项目分布类型转换为Flex布局对齐方式
 *
 * 此函数的作用是映射TabBarItemDistributionType枚举值到FlexAlign枚举值
 * 它用于在标签栏组件中，根据不同的项目分布策略，设置Flex布局的对齐方式
 *
 * @param fromType 标签栏项目分布类型，决定了Flex布局的对齐策略
 * @returns 返回对应的Flex布局对齐方式
 */
export function TabBarItemDistributionType2FlexAlign(fromType: TabBarItemDistributionType): FlexAlign {
  switch (fromType) {
    case TabBarItemDistributionType.None:
      // 当分布类型为None时，项目将对齐到Flex布局的起始端
      return FlexAlign.Start
    case TabBarItemDistributionType.SpaceBetween:
      // 当分布类型为SpaceBetween时，项目将在Flex布局中均匀分布，两端对齐
      return FlexAlign.SpaceBetween
    case TabBarItemDistributionType.SpaceAround:
      // 当分布类型为SpaceAround时，项目将在Flex布局中均匀分布，每个项目两侧的间隔相等
      return FlexAlign.SpaceAround
    case TabBarItemDistributionType.SpaceEvenly:
      // 当分布类型为SpaceEvenly时，项目将在Flex布局中均匀分布，包括两端的间隔
      return FlexAlign.SpaceEvenly
    default:
    // 默认情况下，项目将对齐到Flex布局的起始端
      return FlexAlign.Start
  }
}

/**
 * 将指示器位置转换为对齐方式
 *
 * 此函数的作用是映射IndicatorPosition枚举值到Alignment枚举值
 * 它用于在标签栏组件中，根据指示器的位置，设置指示器的对齐方式
 *
 * @param fromPosition 指示器位置，决定了指示器的对齐方式
 * @returns 返回对应的对齐方式
 */
export function IndicatorPosition2Align(fromPosition: IndicatorPosition): Alignment {
  switch (fromPosition) {
    case IndicatorPosition.Top:
      return Alignment.TopStart
    case IndicatorPosition.Center:
      return Alignment.Start
    case IndicatorPosition.Bottom:
      return Alignment.BottomStart
  }
}