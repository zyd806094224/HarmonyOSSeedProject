

/* 定义tab类型枚举 */
export enum ListTabType {
  OneList = 0,
  TwoList = 1
}


export function ListTabType2Title(tabType: ListTabType): string {
  switch (tabType) {
    case ListTabType.OneList:
      return "one";
    case ListTabType.TwoList:
      return "two";
    default:
      return '';
  }
}