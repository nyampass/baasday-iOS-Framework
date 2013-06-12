//
//  BDUser.h
//  baasday
//

#import <Foundation/Foundation.h>
#import "BDObject.h"
#import "BDListResult.h"
#import "BDQuery.h"

@class BDUser;

typedef void (^BDUserResultBlock)(BDUser *user, NSError *error);

/**
 * @brief アプリケーションのユーザを表すオブジェクトです
 *
 * 任意のフィールドを持つことができます。
 * このクラスから更新を行うことはできません。更新する場合はAuthenticatedUserクラスを利用してください。
 */
@interface BDUser : BDObject

/**
 * @brief 指定されたIDを持つユーザを取得します。
 * @param id ID
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return ユーザ
 */
+ (BDUser *)fetchWithId:(NSString *)id error:(NSError **)error;

/**
 * @brief 指定されたIDを持つユーザを取得します。
 * @param id ID
 * @return ユーザ
 */
+ (BDUser *)fetchWithId:(NSString *)id;

/**
 * @brief 指定されたIDを持つユーザを取得します。
 * @param id ID
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchInBackgroundWithId:(NSString *)id block:(BDUserResultBlock)block;

/**
 * @brief ユーザを取得します
 *
 * 最大待ち時間は指定できません。最大取得件数を指定しない場合や101以上を指定した場合、最大で100件返します。
 * @param query 抽出条件
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query error:(NSError **)error;

/**
 * @brief ユーザを取得します
 *
 * 最大待ち時間は指定できません。最大取得件数を指定しない場合や101以上を指定した場合、最大で100件返します。
 * @param query 抽出条件
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query;

/**
 * @brief ユーザを取得します
 *
 * 最大で100件返します。
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithError:(NSError **)error;

/**
 * @brief ユーザを取得します
 *
 * 最大で100件返します。
 * @return 取得結果
 */
+ (BDListResult *)fetchAll;

/**
 * @brief ユーザを取得します
 *
 * 最大待ち時間は指定できません。最大取得件数を指定しない場合や101以上を指定した場合、最大で100件返します。
 * @param query 抽出条件
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchAllInBackgroundWithQuery:(BDQuery *)query block:(BDListResultBlock)block;

/**
 * @brief ユーザを取得します
 *
 * 最大で100件返します。
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchAllInBackground:(BDListResultBlock)block;

@end
