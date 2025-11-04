import { HMRouterMgr } from '@hadss/hmrouter';
import { CommonConstants, FooterTab, MainTabModel, RouterUrl } from 'component';
import { MainConstants } from '../common/MainConstants';
import { promptAction } from '@kit.ArkUI';


/**
 * 主页底部Tab实现
 */
@Component
export struct MainBottomTab {
  /**
   * 当前显示页面的路由地址
   */
  @StorageLink('currentPage') currentPage: string = MainConstants.MAIN_TABS_ARRAY[0]
  /**
   * tab数据
   */
  private tabList: FooterTab[] = new MainTabModel().getTabList();

  /**
   * 创建视图
   */
  build() {
    Column() {
      // 分割线
      Divider()
        .color($r('app.color.app_tab_line_color'))
        .width(CommonConstants.MATCH_PARENT)
        .height($r('app.float.size_1'))
      // Tab实现
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        ForEach(this.tabList, (item: FooterTab, index: number) => {
          Button({ type: ButtonType.Normal }) {
            this.TabContent(item)
          }.width('33.33%') // 三个Tab数量的比例计算
          .height(CommonConstants.MATCH_PARENT)
          .backgroundColor($r('app.color.app_tab_background_color'))
          .onClick(() => {

            let targetPage: string | undefined = MainConstants.MAIN_TABS_ARRAY[index];

            if (targetPage) {
              let pathStack = HMRouterMgr.getPathStack(MainConstants.MAIN_NAVIGATION_ID);
              let index: Array<number> | undefined = pathStack?.getIndexByName(targetPage);
              // 路由栈存在该页面
              if (index && index.length > 0) {
                pathStack?.moveToTop(targetPage, false);
              } else {
                // 路由栈不存在该页面则新建页面
                HMRouterMgr.push({
                  navigationId: MainConstants.MAIN_NAVIGATION_ID,
                  pageUrl: targetPage,
                  animator: false
                }, {
                  onLost() {
                    promptAction.showToast({
                      message: $r('app.string.page_not_found')
                    });
                  }
                });
              }
            }
          })
        })
      }.height($r('app.float.size_50'))
    }
  }

  /**
   * Tab内容
   * @param item Tab数据
   */
  @Builder
  TabContent(item: FooterTab) {
    Column() {
      Image(this.currentPage === item.getPath() ? item.getIconSelected() : item.getIcon())
        .width($r('app.float.size_20'))
        .height($r('app.float.size_20'))
      Text(item.getName())
        .margin({ top: $r('app.float.size_4') })
        .fontSize($r('app.float.size_12'))
        .fontColor(this.currentPage === item.getPath() ? $r('app.color.app_tab_text_select_color') :
        $r('app.color.app_tab_text_default_color'))
    }.justifyContent(FlexAlign.SpaceAround)
  }
}