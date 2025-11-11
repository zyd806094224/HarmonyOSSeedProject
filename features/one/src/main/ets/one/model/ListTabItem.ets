import { TabBarItemInterface } from "component";
import { ListTabType, ListTabType2Title } from "../enums/ListTabType";


@ObservedV2
export class ListTabItem implements TabBarItemInterface {

  /**
   * 唯一标识
   */
  @Trace
  id: string = '';
  /**
   * 索引
   */
  @Trace
  index: number = 0;
  /**
   * 标题
   */
  @Trace
  title: string;
  /**
   * 新闻类型
   */
  readonly tabType: ListTabType


  constructor(tabType: ListTabType) {
    this.tabType = tabType;
    this.title = ListTabType2Title(tabType);
  }

  /**
   * 获取所有新闻tab项
   */
  static getAllListTabItems(): ListTabItem[] {
    return Object.keys(ListTabType)
      .filter(key =>!isNaN(Number(key)))// 只保留数字索引对应的枚举成员
      .map(key => Number(key).valueOf() as ListTabType)
      .map(tabType => new ListTabItem(tabType));
  }

}