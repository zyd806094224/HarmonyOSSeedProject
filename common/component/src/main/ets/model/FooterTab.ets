import { RouterUrl } from "../RouterUrl";

/**
 * 主页的底部tab数据
 */
export class MainTabModel {
  private tabList: FooterTab[] = [];

  /**
   * 构造方法
   */
  constructor() {
    this.tabList = [
      new FooterTab(
        'one',
        RouterUrl.ONE_TAB_INDEX_PAGE,
        $r("app.media.icon_tab_news_unselect"),
        $r('app.media.icon_tab_news_selected'),
        null
      ),
      new FooterTab(
        'two',
        RouterUrl.TWO_TAB_INDEX_PAGE,
        $r("app.media.icon_tab_find_unselect"),
        $r("app.media.icon_tab_find_select"),
        null
      ),
      new FooterTab(
        'three',
        RouterUrl.THREE_TAB_INDEX_PAGE,
        $r("app.media.icon_tab_fund_unselect"),
        $r("app.media.icon_tab_fund_select"),
        null
      ),
      new FooterTab(
        'four',
        RouterUrl.FOUR_TAB_INDEX_PAGE,
        $r("app.media.icon_tab_mine_unselect"),
        $r("app.media.icon_tab_mine_select"),
        null
      )
    ];
  }

  /**
   * @returns 获取底部tab数据
   */
  getTabList(): FooterTab[] {
    return this.tabList;
  }
}

export class FooterTab {
  private name: string;
  private path: string;
  private icon: Resource | string;
  private iconSelected: Resource | null;
  private selectAnimation: string | null;

  /**
   * 构造方法
   * @param name tab名称
   * @param path 路由路径
   * @param icon tab的图标/路径
   * @param iconSelected 选中的tab图标
   * @param animationPath 选中动画路径
   */
  constructor(name: string, path: string, icon: Resource | string, iconSelected: Resource | null,
    animationPath: string | null) {
    this.name = name;
    this.path = path;
    this.icon = icon;
    this.iconSelected = iconSelected;
    this.selectAnimation = animationPath;
  }

  /**
   * @returns 选中动画路径
   */
  getAnimation(): string | null {
    return this.selectAnimation;
  }

  /**
   * @returns 页面路由地址
   */
  getPath(): string {
    return this.path;
  }

  /**
   * @returns 返回Tab名称
   */
  getName(): string {
    return this.name;
  }

  /**
   * @returns 获取图片资源
   */
  getIcon(): Resource | string {
    return this.icon;
  }

  /**
   * @returns 获取选中的图片资源
   */
  getIconSelected(): Resource | null {
    return this.iconSelected;
  }
}