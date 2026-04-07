import { category_names } from '../util/Categories';
import { HistoryStore, HistoryItem } from '../util/HistoryStore';
import { HapticFeedback } from '../util/HapticFeedback';

@Component
export struct HistoryPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State historyList: HistoryItem[] = [];
  private scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.history_title'))
          .fontColor($r('app.color.primary_text'))
          .fontSize($r('app.float.title_font_size'))
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 20, bottom: 10 })

        if (this.historyList.length > 0) {
          List({ space: 10, scroller: this.scroller }) {
            ForEach(this.historyList, (item: HistoryItem) => {
              ListItem() {
                Column() {
                  Text(category_names[item.category])
                    .fontColor($r('app.color.secondary_text'))
                    .fontSize($r('app.float.subtitle_font_size'))
                    .fontWeight(FontWeight.Bold)

                  Text(item.result)
                    .fontColor($r('app.color.body_text'))
                    .fontSize($r('app.float.small_font_size'))
                    .margin({ top: 4 })
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(new Date(item.timestamp).toLocaleDateString())
                    .fontColor(Color.Gray)
                    .fontSize(10)
                    .margin({ top: 4 })
                    .alignSelf(ItemAlign.End)
                }
                .width('90%')
                .padding(12)
                .backgroundColor('#1A1A1A')
                .borderRadius(16)
              }
              .width('100%')
            })

            ListItem() {
              Button($r('app.string.clear_history'))
                .onClick(async () => {
                  HapticFeedback.playClick();
                  await HistoryStore.clearHistory(getContext(this));
                  this.historyList = [];
                })
                .width('60%')
                .height($r('app.float.button_height'))
                .fontSize($r('app.float.small_font_size'))
                .backgroundColor(Color.Red)
                .margin({ top: 10, bottom: 20 })
            }
            .width('100%')
          }
          .width('100%')
          .height('80%')
          .scrollBar(BarState.Off)
          .focusable(true)
          .defaultFocus(true)
        } else {
          Column() {
             Text($r('app.string.no_history'))
               .fontColor(Color.Gray)
               .fontSize($r('app.float.body_font_size'))
               .margin({ top: 40 })

             Button($r('app.string.go_home'))
               .onClick(() => {
                 this.pageStack.pop();
               })
               .margin({ top: 20 })
               .height($r('app.float.button_height'))
               .backgroundColor($r('app.color.btn_success'))
          }
          .width('100%')
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_black'))
    }
    .onReady(async (ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      this.historyList = await HistoryStore.getHistory(getContext(this));
    })
  }
}
