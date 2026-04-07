import { HistoryPage } from './HistoryPage';
import { GamePage } from './GamePage';
import { HomePage } from './HomePage';
import { ResultPage } from './ResultPage';

@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();

  @Builder
  Pages(name: string) {
    if (name === 'HomePage') {
      HomePage()
    } else if (name === 'GamePage') {
      GamePage()
    } else if (name === 'ResultPage') {
      ResultPage()
    } else if (name === 'HistoryPage') {
      HistoryPage()
    }
  }

  build() {
    Navigation(this.pageStack)
      .mode(NavigationMode.Stack)
      .navDestination(this.Pages)
      .hideNavBar(true)
      .onAppear(() => {
        if (this.pageStack.getAllPathName().length === 0) {
          this.pageStack.pushPathByName('HomePage', null);
        }
      })
  }
}
