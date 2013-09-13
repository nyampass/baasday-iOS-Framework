//
//  BDQuery.h
//  baasday
//

#import <Foundation/Foundation.h>

/**
 * @brief ソート順を指定するときのフィールドの情報を表すクラスです。
 */
@interface BDFieldOrder : NSObject

/**
 * @brief フィールド名
 */
@property (nonatomic, assign) NSString *field;

/**
 * @brief 降順かどうか
 *
 * 降順の場合はYES、昇順の場合はNO
 */
@property (nonatomic, assign) BOOL descending;

/**
 * @brief フィールド名と降順かどうかでインスタンスを初期化します。
 * @param field フィールド名
 * @param descending 降順かどうか。降順の場合はYES、昇順の場合はNO
 * @return 初期化したインスタンス
 */
- (id)initWithField:(NSString *)field descending:(BOOL)descending;

/**
 * @brief フィールド名でインスタンスを初期化します。順序は昇順です。
 * @param field フィールド名
 * @return 初期化したインスタンス
 */
- (id)initWithField:(NSString *)field;

@end

/**
 * @brief 複数のオブジェクトを取得するときの抽出条件を表すクラスです。
 */
@interface BDQuery : NSObject

/**
 * @brief フィルタ
 *
 * このディクショナリに含まれるキーに対応する値を持つオブジェクトだけが返されるようになります。
 * 特別なキーを持つディクショナリをフィルタの値として指定すると、特別な条件でフィルタリングができます($gtなら値より大きいものなど)。
 */
@property (nonatomic, assign) NSDictionary *filter;

/**
 * @brief フィルタが設定されているかどうか
 *
 * 設定されている場合はYES、設定されてない場合はNO
 */
@property (readonly) BOOL hasFilter;

/**
 * @brief ソート順
 *
 * DBFieldOrderかNSStringを含むNSArrayです。
 */
@property (nonatomic, assign) NSArray *order;

/**
 * @brief ソート順が設定されているかどうか
 *
 * 設定されている場合はYES、設定されていない場合はNO
 */
@property (readonly) BOOL hasOrder;

/**
 * @brief 取得開始位置
 */
@property (nonatomic, assign) NSInteger skip;

/**
 * @brief 取得開始位置が設定されているかどうか
 *
 * 設定されている場合はYES、設定されていない場合はNO
 */
@property (readonly) BOOL hasSkip;

/**
 * @brief 最大取得件数
 * 
 * 101以上を指定しても最大で100件しか返されません。
 */
@property (nonatomic, assign) NSInteger limit;

/**
 * @brief 最大取得件数が設定されているかどうか
 *
 * 設定されている場合はYES、設定されていない場合はNO
 */
@property (readonly) BOOL hasLimit;

/**
 * @brief 最大待ち時間
 *
 * 最大待ち時間を設定すると、条件を満たすオブジェクトが存在しない場合に、条件を満たすオブジェクトが作成されるまで設定された秒数(最大で30秒)だけサーバが応答を保留します。これにより何度もリクエストしなくてもオブジェクトの作成をそれなりの精度で検出できます。サーバで応答が保留されている間は結果が返らないので、アプリケーションが停止しないように注意してください。
 */
@property (nonatomic, assign) NSInteger wait;

/**
 * @brief 最大待ち時間が設定されているかどうか
 *
 * 設定されている場合はYES、設定されていない場合はNO
 */
@property (readonly) BOOL hasWait;

@end
