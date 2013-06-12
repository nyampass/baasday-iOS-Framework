//
//  BDListResult.h
//  baasday
//

#import <Foundation/Foundation.h>

/**
 * @brief baasdayサーバから複数のオブジェクトを取得したときの結果を表すクラスです
 */
@interface BDListResult : NSObject

/**
 * @brief 取得したオブジェクトのリスト
 */
@property (readonly) NSArray *contents;

/**
 * @brief 抽出した結果の件数
 *
 * BDQueryに指定したフィルタを適用した件数で、取得開始位置と最大取得件数の影響は受けません。
 */
@property (readonly) NSInteger count;

@end

typedef void (^BDListResultBlock)(BDListResult *result, NSError *error);