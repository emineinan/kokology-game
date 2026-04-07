import { category_names } from '../util/Categories';
import { HapticFeedback } from '../util/HapticFeedback';

@Component
export struct HomePage {
  private menuItems: Resource[] = [
    $r('sys.symbol.sun'),
    $r('sys.symbol.face'),
    $r('sys.symbol.heart'),
    $r('sys.symbol.leaf'),
    $r('sys.symbol.star'),
    $r('sys.symbol.eye')
  ];
  private categoryColors: Resource[] = [
    $r('app.color.category_1'),
    $r('app.color.category_2'),
    $r('app.color.category_3'),
    $r('app.color.category_4'),
    $r('app.color.category_5'),
    $r('app.color.category_6')
  ];
  @Consume('pageStack') pageStack: NavPathStack;
  private scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.app_name'))
          .fontColor($r('app.color.primary_text'))
          .fontSize($r('app.float.title_font_size'))
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 20 })

        List({ space: 12, scroller: this.scroller }) {
          ListItem() {
            Column() {
              Text($r('app.string.home_description'))
                .fontColor($r('app.color.secondary_text'))
                .fontSize($r('app.float.small_font_size'))
                .textAlign(TextAlign.Center)
                .width('100%')
                .padding({ left: 20, right: 20 })

              Button($r('app.string.view_history'))
                .height(30)
                .fontSize(10)
                .backgroundColor('#333333')
                .margin({ top: 10 })
                .onClick(() => {
                  HapticFeedback.playClick();
                  this.pageStack.pushPathByName('HistoryPage', null);
                })
            }
          }

          ForEach(this.menuItems, (item: Resource, index: number) => {
            ListItem() {
              Row() {
                SymbolGlyph(item)
                  .fontSize(24)
                  .fontColor(['#000000'])

                Text(category_names[index])
                  .fontColor('#000000')
                  .fontSize($r('app.float.button_font_size'))
                  .fontWeight(FontWeight.Medium)
                  .margin({ left: 10 })
              }
              .width('90%')
              .height($r('app.float.button_height'))
              .backgroundColor(this.categoryColors[index])
              .borderRadius(22)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                HapticFeedback.playClick();
                this.pageStack.pushPathByName('GamePage', index)
              })
            }
            .width('100%')
          })
        }
        .width('100%')
        .height('80%')
        .margin({ top: 10 })
        .edgeEffect(EdgeEffect.Fade)
        .focusable(true)
        .defaultFocus(true)
      }
      .backgroundColor($r('app.color.background_black'))
      .height('100%')
      .width('100%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
    .hideBackButton(true)
  }
}
