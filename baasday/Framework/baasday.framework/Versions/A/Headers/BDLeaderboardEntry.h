//
//  BDLeaderboardEntry.h
//  baasday
//

#import <Foundation/Foundation.h>
#import "BDObject.h"
#import "BDListResult.h"
#import "BDQuery.h"

@class BDLeaderboardEntry;

typedef void (^BDLeaderboardEntryResultBlock)(BDLeaderboardEntry *entry, NSError *error);

/**
 * @brief baasdayサーバ上に保存されるスコアランキングのエントリーです。
 *
 * スコアと任意のフィールドを持ち、複数のスコアランキングを作成することができます。
 * スコアは整数のみが許容され、値の大きいものが上位になります。少数を扱う場合はアプリケーションで変換してください(小数点以下3桁まで使う場合は1000倍する等)。値の小さいものを上位にする場合は-1をかけてください。
 */
@interface BDLeaderboardEntry : BDObject

/**
 * @brief スコアランキング名
 */
@property (nonatomic) NSString* leaderboardName;

/**
 * @brief スコア
 *
 * これは[entry integerForKey:@"_score"]と同じです。
 */
@property (readonly) NSInteger score;

/**
 * @brief このエントリーのスコアランキング内での順位
 *
 * これは[entry integerForKey:@"_rank"]と同じです。
 * 同一スコアの場合は同じ順位になります。
 */
@property (readonly) NSUInteger rank;

/**
 * @brief このエントリーのスコアランキング内での順番
 *
 * これは[entry integerForKey:@"_order"]と同じです。
 * 同一スコアの場合は先に登録されたものが上位になります。
 */
@property (readonly) NSUInteger order;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param values エントリーが持つ値。"_score"フィールドにスコアが設定されている必要があります
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 追加したエントリー
 */
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values error:(NSError **)error;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param values エントリーが持つ値。"_score"フィールドにスコアが設定されている必要があります
 * @return 追加したエントリー
 */
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param score スコア
 * @param values エントリーが持つ値
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 追加したエントリー
 */
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values error:(NSError **)error;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param score スコア
 * @param values エントリーが持つ値
 * @return 追加したエントリー
 */
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param score スコア
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 追加したエントリー
 */
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score error:(NSError **)error;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param score スコア
 * @return 追加したエントリー
 */
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param values エントリーが持つ値。"_score"フィールドにスコアが設定されている必要があります
 * @param block 追加が完了したか、失敗したときに呼び出されます
 */
+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values block:(BDLeaderboardEntryResultBlock)block;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param score スコア
 * @param values エントリーが持つ値。"_score"フィールドにスコアが設定されている必要があります
 * @param block 追加が完了したか、失敗したときに呼び出されます
 */
+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values block:(BDLeaderboardEntryResultBlock)block;

/**
 * @brief 指定されたスコアランキングにエントリーを追加します。baasdayサーバへの追加は即時に行われます。
 *
 * スコアランキングが存在しない場合は自動的に作成されます。
 * @param leaderboardName スコアランキング名
 * @param score スコア
 * @param block 追加が完了したか、失敗したときに呼び出されます
 */
+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score block:(BDLeaderboardEntryResultBlock)block;

/**
 * @brief 指定されたスコアランキング内の指定されたIDを持つエントリーを取得します
 * @param leaderboardName スコアランキング名
 * @param id ID
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return エントリー
 */
+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id error:(NSError **)error;

/**
 * @brief 指定されたスコアランキング内の指定されたIDを持つエントリーを取得します
 * @param leaderboardName スコアランキング名
 * @param id ID
 * @return エントリー
 */
+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id;

/**
 * @brief 指定されたスコアランキング内の指定されたIDを持つエントリーを取得します
 * @param leaderboardName スコアランキング名
 * @param id ID
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchInBackgroundWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id block:(BDLeaderboardEntryResultBlock)block;

/**
 * @brief 指定されたスコアランキング内のエントリーを取得します
 *
 * フィルタとソート順と最大待ち時間は指定できません。ソート順はスコアの大きい順です。最大取得件数を指定しない場合や101以上を指定した場合、最大で100件返します。
 * @param leaderboardName スコアランキング名
 * @param query 抽出条件。取得開始位置と最大取得件数だけが有効です
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query error:(NSError **)error;

/**
 * @brief 指定されたスコアランキング内のエントリーを取得します
 *
 * フィルタとソート順と最大待ち時間は指定できません。ソート順はスコアの大きい順です。最大取得件数を指定しない場合や101以上を指定した場合、最大で100件返します。
 * @param leaderboardName スコアランキング名
 * @param query 抽出条件。取得開始位置と最大取得件数だけが有効です
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query;


/**
 * @brief 指定されたスコアランキング内のエントリーを取得します
 *
 * スコアの大きい順に最大で100件返します。
 * @param leaderboardName スコアランキング名
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName error:(NSError **)error;

/**
 * @brief 指定されたスコアランキング内のエントリーを取得します
 *
 * スコアの大きい順に最大で100件返します。
 * @param leaderboardName スコアランキング名
 * @return 取得結果
 */
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName;

/**
 * @brief 指定されたスコアランキング内のエントリーを取得します
 *
 * フィルタとソート順と最大待ち時間は指定できません。ソート順はスコアの大きい順です。最大取得件数を指定しない場合や101以上を指定した場合、最大で100件返します。
 * @param leaderboardName スコアランキング名
 * @param query 抽出条件。取得開始位置と最大取得件数だけが有効です
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query block:(BDListResultBlock)block;

/**
 * @brief 指定されたスコアランキング内のエントリーを取得します
 *
 * スコアの大きい順に最大で100件返します。
 * @param leaderboardName スコアランキング名
 * @param block 取得が完了したか、失敗したときに呼び出されます
 */
+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName block:(BDListResultBlock)block;

@end
