
@ComponentV2
export struct TestPage{

  build() {
    Column(){
      Text('one测试页面')
        .fontSize($r('app.float.size_12'))
        .fontColor(Color.White)
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.2f92ff'))
  }
}