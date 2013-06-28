//
//  BDDevice.h
//  baasday
//

#import <Foundation/Foundation.h>
#import "BDBasicObject.h"

/**
 * @brief 端末情報を保持するクラスです。
 *
 * インスタンスはBDAuthenticatedUserクラスのcurrentDeviceプロパティで取得します。更新はBDAuthenticatedUserクラスのupdateDeviceメソッドを使用します。
 *
 * 端末情報の取得、更新を行う前にBDBaasdayクラスのsetDeviceIdメソッドで端末IDを設定する必要があります。まだ一度も端末情報を保存していない場合はgenerateDeviceIdメソッドで端末IDを生成し、それをBDBaasdayクラスに設定します。生成した端末IDはアプリケーション内に保存してください。二度目以降は保存した端末IDをBDBaasdayクラスに設定して使用します。
 */
@interface BDDevice : BDBasicObject

/**
 * @brief 端末IDを生成します。
 * @return 端末ID
 */
+ (NSString *)generateDeviceId;

/**
 * @brief Apple Push Notification Service用のデバイストークンを設定します。
 *
 * デバイストークンはUIApplicationクラスのregisterForRemoteNotificationTypes:メソッドおよびapplication:didRegisterForRemoteNotificationsWithDeviceToken:メソッドで取得します。
 */
- (void)setDeviceToken:(NSData *)deviceToken;

@end
