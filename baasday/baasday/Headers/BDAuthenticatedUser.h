//
//  BDAuthenticatedUser.h
//  baasday
//

#import <Foundation/Foundation.h>
#import "BDUser.h"
#import "BDDevice.h"

@class BDAuthenticatedUser;

typedef void (^BDAuthenticatedUserResultBlock)(BDAuthenticatedUser *user, NSError *error);

/**
 * @brief 認証済みのユーザを表すクラスです。ユーザの作成と更新はこのクラスを用いて行います。
 *
 * createメソッドでユーザを作成し、authenticationKeyプロパティに設定されている認証キーをアプリケーションで保存してください。
 * 保存した認証キーを引数にしてBDBaasdayのsetUserAuthenticationKey:メソッドを呼び出せば、作成したユーザをfetchメソッドで取得できるようになります。
 */
@interface BDAuthenticatedUser : BDUser

/**
 * @brief 認証キー
 *
 * これは[user objectForKey:@"_authenticationKey"]と同じです。
 */
@property (readonly) NSString *authenticationKey;

/**
 * @brief BDBaasdayクラスに設定されている端末IDに対応した端末情報
 *
 * 端末情報がまだ保存されていない場合は空の端末情報を返します。
 */
@property (readonly) BDDevice *currentDevice;

/**
 * @brief ユーザを作成します。baasdayサーバへの登録は即時に行われます。
 * @param values ユーザが持つ値
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 作成したユーザ
 */
+ (BDAuthenticatedUser *)createWithValues:(NSDictionary *)values error:(NSError **)error;

/**
 * @brief ユーザを作成します。baasdayサーバへの登録は即時に行われます。
 * @param values ユーザが持つ値
 * @return 作成したユーザ
 */
+ (BDAuthenticatedUser *)createWithValues:(NSDictionary *)values;

/**
 * @brief ユーザを作成します。baasdayサーバへの登録は即時に行われます。
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 作成したユーザ
 */
+ (BDAuthenticatedUser *)createWithError:(NSError **)error;

/**
 * @brief ユーザを作成します。baasdayサーバへの登録は即時に行われます。
 * @return 作成したユーザ
 */
+ (BDAuthenticatedUser *)create;

/**
 * @brief ユーザを作成します。baasdayサーバへの登録は即時に行われます。
 * @param values ユーザが持つ値
 * @param block 作成が完了したか、失敗したときに呼び出されます
 */
+ (void)createInBackgroundWithValues:(NSDictionary *)values block:(BDAuthenticatedUserResultBlock)block;

/**
 * @brief ユーザを作成します。baasdayサーバへの登録は即時に行われます。
 * @param block 作成が完了したか、失敗したときに呼び出されます
 */
+ (void)createInBackground:(BDAuthenticatedUserResultBlock)block;

/**
 * @brief BDBaasdayクラスに設定されている認証キーをもとにユーザを取得します。
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得したユーザ
 */
+ (BDAuthenticatedUser *)fetchWithError:(NSError **)error;

/**
 * @brief BDBaasdayクラスに設定されている認証キーをもとにユーザを取得します。
 * @return 取得したユーザ
 */
+ (BDAuthenticatedUser *)fetch;

/**
 * @brief BDBaasdayクラスに設定されている認証キーをもとにユーザを取得します。
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchInBackground:(BDAuthenticatedUserResultBlock)block;

/**
 * @brief 端末情報を更新します。
 * @param device 端末情報
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 */
- (BOOL)updateDevice:(BDDevice *)device error:(NSError **)error;

/**
 * @brief 端末情報を更新します。
 * @param device 端末情報
 */
- (BOOL)updateDevice:(BDDevice *)device;

/**
 * @brief 端末情報を更新します。
 * @param device 端末情報
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
- (void)updateDeviceInBackground:(BDDevice *)device block:(void(^)(id object, NSError *error))block;

@end
