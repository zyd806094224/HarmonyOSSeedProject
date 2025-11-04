import { RouterUrl } from "component"

/**
 * 项目主入口相关的常量
 */
export class MainConstants {
  /**
   * 主页底部tab导航栏id
   */
  static readonly MAIN_NAVIGATION_ID = 'main_page_navigation_id'

  /**
   * 主页底部tab页面路由数组
   */
  static readonly MAIN_TABS_ARRAY = [
    RouterUrl.ONE_TAB_INDEX_PAGE,
    RouterUrl.TWO_TAB_INDEX_PAGE,
    RouterUrl.THREE_TAB_INDEX_PAGE,
    RouterUrl.FOUR_TAB_INDEX_PAGE
  ]
}