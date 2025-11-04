import { HMRouterPathCallback } from "@hadss/hmrouter"
import { promptAction } from "@kit.ArkUI"

/**
 * 公共的常量类
 */
export class CommonConstants {

  /**
   * 启动页的路由id
   */
  static readonly LAUNCHER_NAVIGATION_ID = 'seed_launcher_navigation_id'

  /**
   * 充满父容器
   */
  static readonly MATCH_PARENT = '100%'
  /**
   * 根据内容大小自适应
   */
  static readonly WRAP_CONTENT = 'wrap_content'

  /**
   * RelativeContainer父容器id
   */
  static readonly RELATIVE_PARENT_ID = "__container__"

  /**
   * 存储窗口避让区域数据
   */
  static readonly APP_STORAGE_WINDOW_AVOID_AREA = 'windowAvoidArea'

}

/**
 * 全局路由回调
 */
export const globalPathCallback: HMRouterPathCallback = {
  /**
   * 路由丢失时的回调
   */
  onLost: () => {
    promptAction.showToast({
      message: $r('app.string.page_not_found')
    })
  }
}