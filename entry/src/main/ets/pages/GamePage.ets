import GameModel from '../model/GameModel';
import { ResultParam } from '../model/ResultParam';
import { category_names } from '../util/Categories';
import { GameViewModel } from '../viewmodel/GameViewModel';
import { HapticFeedback } from '../util/HapticFeedback';
import { StressSensor } from '../util/StressSensor';

@Component
export struct GamePage {
  @Consume('pageStack') pageStack: NavPathStack;
  private viewModel: GameViewModel = new GameViewModel();
  @State currentQuestionList: Array<GameModel> = [];
  @State currentIndex: number = 0;
  @State selectedAnswers: string[] = [];
  @State categoryIdTitle: number = 0;

  build() {
    NavDestination() {
      Column() {
        Text(category_names[this.categoryIdTitle])
          .fontColor($r('app.color.secondary_text'))
          .fontSize($r('app.float.subtitle_font_size'))
          .margin({ top: 20, bottom: 10 })
          .textAlign(TextAlign.Center)
          .width('90%')

        if (this.currentQuestionList.length > 0) {
          Scroll() {
            Column() {
              Text(`Q${this.currentIndex + 1}. ${this.currentQuestionList[this.currentIndex].question}`)
                .fontSize($r('app.float.body_font_size'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.body_text'))
                .margin({ bottom: 20 })
                .width('85%')
                .textAlign(TextAlign.Center)

              Button(this.currentQuestionList[this.currentIndex].optionA)
                .width('80%')
                .height($r('app.float.button_height'))
                .fontSize($r('app.float.button_font_size'))
                .backgroundColor($r('app.color.btn_primary'))
                .fontColor(Color.White)
                .margin({ bottom: 12 })
                .onClick(() => this.handleAnswer('A'))

              Button(this.currentQuestionList[this.currentIndex].optionB)
                .width('80%')
                .height($r('app.float.button_height'))
                .fontSize($r('app.float.button_font_size'))
                .backgroundColor($r('app.color.btn_success'))
                .fontColor(Color.White)
                .onClick(() => this.handleAnswer('B'))
            }
            .width('100%')
            .padding({ bottom: 20 })
          }
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        } else {
          Text($r('app.string.loading_questions'))
            .fontSize($r('app.float.body_font_size'))
            .fontColor(Color.Gray)
        }
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_black'))
    }
    .onReady(async (ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      const categoryId = ctx.pathInfo.param as number;
      this.categoryIdTitle = categoryId;

      this.loadQuestions(categoryId);

      const hasPermission = await StressSensor.requestPermission(getContext(this));
      if (hasPermission) {
        StressSensor.startMonitoring();
      }
    })
    .hideBackButton(true)
  }

  loadQuestions(categoryId: number) {
    switch (categoryId) {
      case 0: this.currentQuestionList = this.viewModel.getkokologyQuestionsCategory1(); break;
      case 1: this.currentQuestionList = this.viewModel.getkokologyQuestionsCategory2(); break;
      case 2: this.currentQuestionList = this.viewModel.getkokologyQuestionsCategory3(); break;
      case 3: this.currentQuestionList = this.viewModel.getkokologyQuestionsCategory4(); break;
      case 4: this.currentQuestionList = this.viewModel.getkokologyQuestionsCategory5(); break;
      case 5: this.currentQuestionList = this.viewModel.getkokologyQuestionsCategory6(); break;
    }
  }

  handleAnswer(option: string) {
    HapticFeedback.playClick();
    this.selectedAnswers.push(option);

    if (this.currentIndex < this.currentQuestionList.length - 1) {
      this.currentIndex++;
    } else {
      HapticFeedback.playSuccess();
      const paramObj: ResultParam = {
        answers: this.selectedAnswers,
        category: this.categoryIdTitle
      };
      this.pageStack.pushPathByName('ResultPage', paramObj);
    }
  }
}
