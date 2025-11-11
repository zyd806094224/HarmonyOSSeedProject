
/**
 * 列表类型
 */
export enum CommonListType {
  /**
   * 新闻
   */
  News = 0,
  /**
   * 广告
   */
  Ad = 1
}

/**
 * 列表基础数据模型
 */
export class CommonListBasicModel {
  /**
   * 获取唯一标识
   */
  getIdentify(): string {
    return '';
  }

  /**
   * 获取新闻类型
   */
  getNewsType(): CommonListType {
    return CommonListType.News;
  }
}

/**
 * 新闻列表数据模型
 */
export class CommonNewsModel extends CommonListBasicModel {
  /**
   * 新闻id
   */
  id: string

  /**
   * 标题
   */
  title: string
  /**
   * 概要
   */
  abstract: string
  /**
   * 图片
   */
  img: string

  constructor(id: string,  title: string, abstract: string, img: string) {
    super();
    this.id = id ?? '';
    this.title = title ?? '';
    this.abstract = abstract ?? '';
    this.img = img ?? '';
  }

  /**
   * 获取唯一标识
   */
  getIdentify(): string {
    return 'news:' + this.id;
  }

  /**
   * 获取列表类型
   */
  getNewsType(): CommonListType {
    return CommonListType.News;
  }
}

/**
 * 新闻广告数据模型
 */
export class CommonNewsAdModel extends CommonListBasicModel {
  /**
   * 唯一标识
   */
  id: string
  /**
   * 插入位置
   */
  index: number
  /**
   * 图片地址
   */
  imagePath: string

  /**
   * 构造函数
   * @param id 唯一标识
   * @param imagePath 图片地址
   */
  constructor(id: string,index: number, imagePath: string) {
    super();
    this.id = id ?? '';
    this.index = index ?? -1;
    this.imagePath = imagePath ?? '';
  }

  /**
   * 获取唯一标识
   */
  getIdentify(): string {
    return 'ad:' + this.id;
  }

  /**
   * 获取新闻类型
   */
  getNewsType(): CommonListType {
    return CommonListType.Ad;
  }
}