import { TabBarItemInterface } from './TabBarItem';
import { TabBarOptionsInterface } from './TabBarOptions';

/*
 * 用于在Builder之间进行引用传递
 */
export interface ReferenceTabBarInterface {
  /**
   * 当前选中的Tab栏项目的索引。
   */
  currentItemIndex: number;

  /**
   * 选中的Tab栏项目的索引。
   */
  selectedItemIndex: number;

  /**
   * Tab栏的配置选项。
   */
  tabBarOptions: TabBarOptionsInterface;

  /**
   * 当前Tab栏项目的配置选项。
   */
  item: TabBarItemInterface;
}

/**
 * 用于在Builder之间进行引用传递
 */
export interface ReferenceTabBarIndicatorInterface {
  /**
   * 下一个Tab栏项目的索引。
   */
  nextItemIndex: number;

  /**
   * 选中的Tab栏项目的索引。
   */
  selectedItemIndex: number;

  /**
   * Tab栏的配置选项。
   */
  tabBarOptions: TabBarOptionsInterface;

  /**
   * 变动的指示器宽度。
   */
  indicatorWidth: number;

  /**
   * 变动的指示器高度。
   */
  indicatorHeight: number;
}