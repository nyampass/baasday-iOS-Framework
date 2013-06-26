//
//  BDBaasday.h
//  baasday
//

#import <Foundation/Foundation.h>

/**
 * @brief アプリケーション内でのbaasdayの設定を保持するクラスです
 *
 * 最初にsetApplicationId:apiKey:でアプリケーションIDとAPIキーを設定する必要があります。
 * 以前に作成したユーザを取得したり、ユーザを更新する場合はsetUserAuthenticationKey:でユーザの認証キーを設定します。認証キーはユーザの作成時に取得できるので、アプリケーションないで別途保存しておく必要があります。
 */
@interface BDBaasday : NSObject

/**
 * @brief アプリケーションIDとAPIキーを設定します。
 * @param applicationId アプリケーションID
 * @param apiKey APIキー
 */
+ (void)setApplicationId:(NSString *)applicationId apiKey:(NSString *)apiKey;

/**
 * @brief 設定されているアプリケーションIDを返します。
 * @return アプリケーションID
 */
+ (NSString *)applicationId;

/**
 * @brief 設定されているAPIキーを返します。
 * @return APIキー
 */
+ (NSString *)apiKey;

/**
 * @brief baasday SDKのバージョンを返します。
 * @return SDKのバージョン
 */
+ (NSString *)version;

/**
 * @brief ユーザの認証キーを設定します。
 * @param key ユーザの認証キー
 */
+ (void)setUserAuthenticationKey:(NSString *)key;

/**
 * @brief 設定されているユーザの認証キーを返します。
 * @return ユーザの認証キー
 */
+ (NSString *)userAuthenticationKey;

/**
 * @brief 端末IDを設定します。
 *
 * 端末IDはBDDeviceクラスのgenerateDeviceIdで生成します
 * @param deviceId 端末ID
 */
+ (void)setDeviceId:(NSString *)deviceId;

/**
 * @brief 設定されている端末IDを返します。
 * @return 端末ID
 */
+ (NSString *)deviceId;

/**
 * @brief baasday Web APIのURLを返します。
 * @return baasday Web APIのURL
 */
+ (NSString *)apiURLRoot;

/**
 * @brief baasday Web APIのURLを設定します。通常は変更する必要はありません。
 * @param apiURLRoot baasday Web APIのURL
 */
+ (void)setAPIURLRoot:(NSString *)apiURLRoot;

@end
