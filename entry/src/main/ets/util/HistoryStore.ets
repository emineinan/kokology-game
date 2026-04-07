import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export interface HistoryItem {
  id: string;
  category: number;
  result: string;
  timestamp: number;
}

export class HistoryStore {
  private static readonly PREF_NAME = 'kokology_history';
  private static readonly KEY_HISTORY = 'history_list';

  static async addHistory(context: common.Context, item: HistoryItem): Promise<void> {
    try {
      let pref = await preferences.getPreferences(context, this.PREF_NAME);
      let historyJson = await pref.get(this.KEY_HISTORY, '[]') as string;
      let historyList: HistoryItem[] = JSON.parse(historyJson);

      historyList.unshift(item); // Add to the beginning

      // Keep only last 20 results
      if (historyList.length > 20) {
        historyList = historyList.slice(0, 20);
      }

      await pref.put(this.KEY_HISTORY, JSON.stringify(historyList));
      await pref.flush();
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`Failed to add history. Code: ${e.code}, message: ${e.message}`);
    }
  }

  static async getHistory(context: common.Context): Promise<HistoryItem[]> {
    try {
      let pref = await preferences.getPreferences(context, this.PREF_NAME);
      let historyJson = await pref.get(this.KEY_HISTORY, '[]') as string;
      return JSON.parse(historyJson);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`Failed to get history. Code: ${e.code}, message: ${e.message}`);
      return [];
    }
  }

  static async clearHistory(context: common.Context): Promise<void> {
    try {
      let pref = await preferences.getPreferences(context, this.PREF_NAME);
      await pref.delete(this.KEY_HISTORY);
      await pref.flush();
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`Failed to clear history. Code: ${e.code}, message: ${e.message}`);
    }
  }
}
