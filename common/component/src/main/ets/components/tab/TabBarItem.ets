import { common } from '@kit.AbilityKit';

/**
 * 定义 TabBarItem 的基本属性。
 *
 * @interface TabBarItemInterface
 * @property {string} id - 由 TabBar 内部生成的唯一标识符，无需外部传入。
 * @property {number} index - 由 TabBar 内部生成的索引值，用于标识每个 TabBarItem 的位置，无需外部传入。
 * @property {string} title - 显示在 TabBarItem 上的标题文本。
 */
export interface TabBarItemInterface {
  /**
   * 唯一标识符，由 TabBar 内部生成，无需外部传入。
   */
  id: string;

  /**
   * 索引值，由 TabBar 内部生成，用于标识每个 TabBarItem 的位置，无需外部传入。
   */
  index: number;

  /**
   * 显示在 TabBarItem 上的标题文本。
   */
  title: string;
}

/**
 * 实现 TabBarItemInterface 接口，用于创建和管理单个 TabBarItem。
 *
 * @class TabBarItem
 * @implements {TabBarItemInterface}
 */
@ObservedV2
export class TabBarItem implements TabBarItemInterface {
  /**
   * 唯一标识符，默认为空字符串，由 TabBar 内部设置。
   */
  @Trace
  id: string = '';
  /**
   * 索引值，默认为0，由 TabBar 内部设置。
   */
  @Trace
  index: number = 0;
  /**
   * 标题文本。
   */
  @Trace
  title: string;

  /**
   * 构造函数，初始化 TabBarItem 实例。
   *
   * @param {string | Resource} title - 标题可以是字符串或资源对象。
   */
  constructor(title: string | Resource) {
    if (typeof title === 'string') {
      this.title = title;
    } else {
      this.title = this.getStringFromResource(title);
    }
  }

  /**
   * 从资源对象中获取字符串。
   *
   * @private
   * @param {Resource} source - 资源对象。
   * @returns {string} 解析后的字符串。
   */
  private getStringFromResource(source: Resource): string {
    const context = getContext(this) as common.UIAbilityContext;
    return context.resourceManager.getStringSync(source.id);
  }
}

/**
 * 用于在 @Builder 中引用传递参数的接口。
 * 按引用传递参数时，传递的参数可以是状态变量，且状态变量的改变会引起 @Builder 方法内的 UI 刷新。
 * (https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-builder-0000001524176981-V2)
 *
 * @interface ReferenceTabBarItemInterface
 * @property {number} currentItemIndex - 当前显示的 TabBarItem 的索引。
 * @property {number} selectedItemIndex - 用户选中的 TabBarItem 的索引。
 * @property {TabBarItemInterface} item - 当前的 TabBarItem 对象。
 */
export interface ReferenceTabBarItemInterface {
  /**
   * 当前显示的 TabBarItem 的索引。
   */
  currentItemIndex: number;

  /**
   * 用户选中的 TabBarItem 的索引。
   */
  selectedItemIndex: number;

  /**
   * 当前的 TabBarItem 对象。
   */
  item: TabBarItemInterface;
}
