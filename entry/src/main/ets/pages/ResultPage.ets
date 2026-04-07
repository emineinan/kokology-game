import ResultModel from '../model/ResultModel';
import { ResultParam } from '../model/ResultParam';
import { category_names } from '../util/Categories';
import { ResultViewModel } from '../viewmodel/ResultViewModel';
import { HapticFeedback } from '../util/HapticFeedback';
import { HistoryStore, HistoryItem } from '../util/HistoryStore';

@Component
export struct ResultPage {
  @Consume('pageStack') pageStack: NavPathStack;
  private viewModel: ResultViewModel = new ResultViewModel();
  @State answers: string[] = [];
  @State category: number = 0;
  @State finalResult: string = '';
  private scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.result_title'))
          .fontColor($r('app.color.primary_text'))
          .fontSize($r('app.float.title_font_size'))
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 20 })

        Text(category_names[this.category])
          .fontColor($r('app.color.secondary_text'))
          .fontSize($r('app.float.subtitle_font_size'))
          .margin({ top: 8 })

        Scroll(this.scroller) {
          Column() {
            Text(this.finalResult)
              .fontColor($r('app.color.body_text'))
              .fontSize($r('app.float.body_font_size'))
              .margin({ top: 12, bottom: 20 })
              .width('85%')
              .textAlign(TextAlign.Center)

            Button($r('app.string.go_home'))
              .onClick(() => {
                HapticFeedback.playClick();
                this.pageStack.clear();
                this.pageStack.pushPathByName('HomePage', null);
              })
              .width('70%')
              .height($r('app.float.button_height'))
              .fontSize($r('app.float.button_font_size'))
              .backgroundColor($r('app.color.btn_success'))
              .fontColor(Color.White)
              .margin({ bottom: 20 })
          }
          .width('100%')
        }
        .layoutWeight(1)
        .margin({ top: 10 })
        .scrollBar(BarState.Off)
        .focusable(true)
        .defaultFocus(true)
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_black'))
    }
    .onReady(async (ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      const data = ctx.pathInfo.param as ResultParam;
      if (!data) return;

      this.answers = data.answers;
      this.category = data.category;

      let countA = this.answers.filter(a => a === 'A').length;
      let countB = this.answers.filter(a => a === 'B').length;

      let resultModel: ResultModel;
      switch (this.category) {
        case 0: resultModel = this.viewModel.getkokologyResultCategory1(); break;
        case 1: resultModel = this.viewModel.getkokologyResultCategory2(); break;
        case 2: resultModel = this.viewModel.getkokologyResultCategory3(); break;
        case 3: resultModel = this.viewModel.getkokologyResultCategory4(); break;
        case 4: resultModel = this.viewModel.getkokologyResultCategory5(); break;
        case 5: resultModel = this.viewModel.getkokologyResultCategory6(); break;
        default: resultModel = new ResultModel();
      }

      this.finalResult = (countA > countB) ? resultModel.resultA : resultModel.resultB;

      // Archive the result
      const historyItem: HistoryItem = {
        id: Date.now().toString(),
        category: this.category,
        result: this.finalResult,
        timestamp: Date.now()
      };
      await HistoryStore.addHistory(getContext(this), historyItem);
    })
    .hideBackButton(true)
  }
}
