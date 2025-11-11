import {
  AnyType,
  LazyDataSource,
  RefreshDataInto,
  RefreshDataState,
  RefreshFooterController,
  RefreshHeaderController
} from "component";
import { ListTabType } from "../enums/ListTabType";
import { CommonListBasicModel, CommonNewsAdModel, CommonNewsModel } from "../model/CommonListModel";


@ObservedV2
export class CommonListViewModel {
  /**
   * 数据源，用于存储和管理数据。
   * @type {LazyDataSource<CommonListBasicModel>}
   */
  readonly dataSource: LazyDataSource<CommonListBasicModel> = new LazyDataSource<CommonListBasicModel>();
  /**
   * 新闻类型。
   * @type {ListTabType}
   */
  readonly tabType: ListTabType
  /**
   * 刷新头部控制器，用于管理刷新头部的状态和事件
   * @type {RefreshHeaderController}
   */
  @Trace headerController: RefreshHeaderController = new RefreshHeaderController();
  /**
   * 刷新尾部控制器，用于管理刷新尾部的状态和事件
   * @type {RefreshFooterController}
   */
  @Trace footerController: RefreshFooterController = new RefreshFooterController();
  /**
   * 当前页码，用于分页加载新闻数据。
   * @private
   * @type {number}
   */
  private _page: number = 1
  /**
   * 广告数据，用于显示在新闻列表中。
   * @private
   * @type {CommonNewsAdModel}
   */
  private _adModel?: CommonNewsAdModel

  constructor(tabType: ListTabType) {
    this.tabType = tabType
    this.headerController.onRefresh = () => {
      return this.onRefresh();
    };
    this.footerController.onRefresh = () => {
      return this.onLoadMore();
    };
  }

  /**
   * 计算属性，判断数据源是否为空
   * @returns {boolean} 如果数据源中没有数据，则返回 true
   */
  @Computed
  get isEmpty(): boolean {
    return this.dataSource.totalCount() === 0;
  }


  /**
   * 刷新数据时调用的方法。
   * 重置页码，获取第一页的数据，并将数据添加到数据源中
   * @returns {Promise<RefreshDataInto>} 刷新结果的状态
   */
  private onRefresh(): Promise<RefreshDataInto> {
    return new Promise((resolve, _) => {
      Promise.all([
        this._requestAd().catch((error: AnyType) => {
          return undefined;
        }),
        this._request(1)
      ]).then((value) => {
        const adModel = value[0]
        const data = value[1]
        this._page = 1;
        this.dataSource.setData(data)
        this._adModel = undefined
        if (adModel !== undefined && !this.dataSource.insertData(adModel, adModel.index)) {
          this._adModel = adModel
        }
        this.footerController.resetDataState()
        resolve({ state: data.length > 0 ? RefreshDataState.Upgrade : RefreshDataState.Latest });
      }).catch((_: Error) => {
        resolve({ state: RefreshDataState.Error });
      });
    });
  }

  /**
   * 加载更多数据时调用的方法。
   * 获取下一页的数据，并将数据添加到数据源中。
   * @returns {Promise<RefreshDataInto>} 刷新结果的状态。
   */
  private onLoadMore(): Promise<RefreshDataInto> {
    return new Promise((resolve, _) => {
      this._request(this._page + 1).then(data => {
        this._page += 1;
        this.dataSource.pushData(data)
        if (this._adModel !== undefined && this.dataSource.insertData(this._adModel, this._adModel.index)) {
          this._adModel = undefined
        }
        resolve({ state: data.length > 0 ? RefreshDataState.Upgrade : RefreshDataState.NoMore });
      }).catch((_: Error) => {
        resolve({ state: RefreshDataState.Error });
      });
    });
  }

  private _request(page: number): Promise<CommonNewsModel[]> {
    // 模拟每页返回10条数据（可根据需要调整）
    const pageSize = 10;
    // 计算当前页数据的起始索引（用于生成不重复的id）
    const startIndex = (page - 1) * pageSize;

    // 模拟异步请求（如网络请求延迟）
    return new Promise((resolve) => {
      setTimeout(() => {
        // 生成测试数据数组
        const newsList: CommonNewsModel[] = [];
        for (let i = 0; i < pageSize; i++) {
          const index = startIndex + i;
          let commonNewsModel = new CommonNewsModel(`news_${index}`, `news_${index}`,
            `这是第${page}页第${i + 1}条新闻的概要内容，用于测试展示。这是一段模拟的新闻摘要文本。`, '')
          newsList.push(commonNewsModel);
        }
        resolve(newsList); // 返回生成的测试数据
      }, 500); // 模拟500ms网络延迟
    });
  }

  private _requestAd(): Promise<CommonNewsAdModel | undefined> {
    // 模拟异步请求（如网络请求延迟）
    return new Promise((resolve) => {
      setTimeout(() => {
        let commonNewsAdModel = new CommonNewsAdModel('1', 3, '')
        resolve(commonNewsAdModel); // 返回生成的测试数据
      }, 500); // 模拟500ms网络延迟
    });
  }
}