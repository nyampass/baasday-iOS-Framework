//
//  BDItem.h
//  baasday
//

#import <Foundation/Foundation.h>
#import "BDObject.h"
#import "BDListResult.h"
#import "BDQuery.h"

@class BDItem;

typedef void (^BDItemResultBlock)(BDItem *object, NSError *error);

/**
 * @brief baasdayサーバ上に保存される汎用的なオブジェクトです。
 *
 * 任意のフィールドを持ち、複数のコレクションに分けてアイテムを保存できます。
 */
@interface BDItem : BDObject

/**
 * @brief コレクション名
 */
@property (readonly) NSString* collectionName;

/**
 * @brief 指定されたコレクションにアイテムを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * コレクションが存在しない場合は自動的に作成されます。
 * @param collectionName コレクション名
 * @param values アイテムが持つ値
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 追加したアイテム
 */
+ (BDItem *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error;

/**
 * @brief 指定されたコレクションにアイテムを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * コレクションが存在しない場合は自動的に作成されます。
 * @param collectionName コレクション名
 * @param values アイテムが持つ値
 * @return 追加したアイテム
 */
+ (BDItem *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;

/**
 * @brief 指定されたコレクションにアイテムを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * コレクションが存在しない場合は自動的に作成されます。
 * @param collectionName コレクション名
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 追加したアイテム
 */
+ (BDItem *)createWithCollectionName:(NSString *)collectionName error:(NSError **)error;

/**
 * @brief 指定されたコレクションにアイテムを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * コレクションが存在しない場合は自動的に作成されます。
 * @param collectionName コレクション名
 * @return 追加したアイテム
 */
+ (BDItem *)createWithCollectionName:(NSString *)collectionName;

/**
 * @brief 指定されたコレクションにアイテムを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * コレクションが存在しない場合は自動的に作成されます。
 * @param collectionName コレクション名
 * @param values アイテムが持つ値
 * @param block 追加が完了したか、失敗したときに呼び出されます
 * @return 追加したアイテム
 */
+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values block:(BDItemResultBlock)block;

/**
 * @brief 指定されたコレクションにアイテムを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * コレクションが存在しない場合は自動的に作成されます。
 * @param collectionName コレクション名
 * @param block 追加が完了したか、失敗したときに呼び出されます
 * @return 追加したアイテム
 */
+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName block:(BDItemResultBlock)block;

/**
 * @brief 指定されたコレクション内の指定されたIDを持つアイテムを取得します。
 * @param collectionName コレクション名
 * @param id ID
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return アイテム
 */
+ (BDItem *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id erorr:(NSError **)error;

/**
 * @brief 指定されたコレクション内の指定されたIDを持つアイテムを取得します。
 * @param collectionName コレクション名
 * @param id ID
 * @return アイテム
 */
+ (BDItem *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id;

/**
 * @brief 指定されたコレクション内の指定されたIDを持つアイテムを取得します。
 * @param collectionName コレクション名
 * @param id ID
 * @param block 取得が完了したか、失敗したときに呼び出されます
 * @return アイテム
 */
+ (void)fetchInBackgroundWithCollectionName:(NSString *)collectionName id:(NSString *)id block:(BDItemResultBlock)block;

/**
 * @brief 指定されたコレクション内のアイテムを取得します。
 *
 * 最大取得件数を指定しない場合や101以上を指定した場合は、最大で100件返します。
 * @param collectionName コレクション名
 * @param query 抽出条件
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error;

/**
 * @brief 指定されたコレクション内のアイテムを取得します。
 *
 * 最大取得件数を指定しない場合や101以上を指定した場合は、最大で100件返します。
 * @param collectionName コレクション名
 * @param query 抽出条件
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query;

/**
 * @brief 指定されたコレクション内のアイテムを取得します。
 *
 * アイテムは最大で100件返します。
 * @param collectionName コレクション名
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName error:(NSError **)error;

/**
 * @brief 指定されたコレクション内のアイテムを取得します。
 *
 * アイテムは最大で100件返します。
 * @param collectionName コレクション名
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWIthCollectionName:(NSString *)collectionName;

/**
 * @brief 指定されたコレクション内のアイテムを取得します。
 *
 * 最大取得件数を指定しない場合や101以上を指定した場合は、最大で100件返します。
 * @param collectionName コレクション名
 * @param query 抽出条件
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName query:(BDQuery *)query block:(BDListResultBlock)block;

/**
 * @brief 指定されたコレクション内のアイテムを取得します。
 *
 * アイテムは最大で100件返します。
 * @param collectionName コレクション名
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName block:(BDListResultBlock)block;

@end
