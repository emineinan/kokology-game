import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';

export class StressSensor {
  private static heartRate: number = 0;

  static async requestPermission(context: common.Context): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      let data = await atManager.requestPermissionsFromUser(context, ['ohos.permission.HEALTH_DATA_HEALTH_RATE_READ']);
      if (data.authResults[0] === 0) {
        return true;
      }
    } catch (err) {
      console.error(`Permission request failed: ${JSON.stringify(err)}`);
    }
    return false;
  }

  static startMonitoring() {
    try {
      sensor.on(sensor.SensorId.HEART_RATE, (data) => {
        this.heartRate = data.heartRate;
        console.info(`Heart rate data: ${this.heartRate}`);
      }, { interval: 1000000000 }); // 1 second
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`Failed to start heart rate monitoring. Code: ${e.code}, message: ${e.message}`);
    }
  }

  static stopMonitoring() {
    try {
      sensor.off(sensor.SensorId.HEART_RATE);
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`Failed to stop heart rate monitoring. Code: ${e.code}, message: ${e.message}`);
    }
  }

  static getIsStressed(): boolean {
    // Very simple logic: if heart rate > 80, we consider it "excited/stressed" for the demo
    return this.heartRate > 80;
  }
}
