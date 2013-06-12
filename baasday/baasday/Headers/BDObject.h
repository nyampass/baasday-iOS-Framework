//
//  BDObject.h
//  baasday
//

#import <Foundation/Foundation.h>

/**
 * @brief baasdayサーバ上に保存されるオブジェクトの共通の基底クラスです。フィールドの値の取得、baasday上のデータの更新、削除の機能を提供します。
 *
 * フィールドの値はNSNumber(数値/ブール)、NSString(文字列)、NSDate(日付)、NSArray、NSDictionary、nilで表されます。
 */
@interface BDObject : NSObject

/**
 * @brief 全てのフィールドの値
 */
@property (readonly) NSDictionary *values;

/**
 * @brief ID
 *
 * これは[object integerForKey:@"_id"]と同じです。
 */
@property (readonly) NSString *id;

/**
 * @brief 作成日時
 *
 * これは(NSDate *) [object objectForKey:@"_createdAt"]と同じです。
 */
@property (readonly) NSDate *createdAt;

/**
 * @brief 更新日時
 *
 * これは(NSDate *) [object objectForKey:@"_updatedAt"]と同じです。
 */
@property (readonly) NSDate *updatedAt;

/**
 * @brief 指定されたフィールドの値を返します
 * @param key フィールド名
 * @return フィールドの値。フィールドが存在しない場合はnil
 */
- (id)objectForKey:(NSString *)key;

/**
 * @brief 指定されたフィールドの値を返します
 * @param keyPath フィールド名。入れ子になったフィールドの値をドットで繋げて指定できます
 * @return フィールドの値。フィールドが存在しない場合はnil
 */
- (id)objectForKeyPath:(NSString *)keyPath;

/**
 * @brief 指定されたフィールドの値を返します
 * @param key フィールド名
 * @return フィールドの値。フィールドが存在しない場合はnil
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/**
 * @brief 指定されたフィールドが存在するかどうかを返します
 * @param key フィールド名
 * @return フィールドが存在する場合はYES、存在しない場合はNO
 */
- (BOOL)containsKey:(NSString *)key;

/**
 * @brief 指定されたフィールドが値としてnilを持つかどうかを返します
 * @param key フィールド名
 * @return フィールドが存在し、値がnilの場合はture、それ以外はfalse
 */
- (BOOL)isNil:(NSString *)key;

/**
 * @brief 指定されたフィールドの値を整数として返します
 * @param key フィールド名
 * @return フィールドの値。フィールドが存在しない場合は0
 */
- (NSInteger)integerForKey:(NSString *)key;

/**
 * @brief 指定されたフィールドの値を整数として返します
 * @param keyPath フィールド名。入れ子になったフィールドの値をドットで繋げて指定できます
 * @return フィールドの値。フィールドが存在しない場合は0
 */
- (NSInteger)integerForKeyPath:(NSString *)keyPath;

/**
 * @brief 指定されたフィールドの値を数値として返します
 * @param key フィールド名
 * @return フィールドの値。フィールドが存在しない場合は0
 */
- (double)doubleForKey:(NSString *)key;

/**
 * @brief 指定されたフィールドの値を数値として返します
 * @param keyPath フィールド名。入れ子になったフィールドの値をドットで繋げて指定できます
 * @return フィールドの値。フィールドが存在しない場合は0
 */
- (double)doubleForKeyPath:(NSString *)keyPath;

/**
 * @brief 指定されたフィールドの値をブール値として返します
 * @param key フィールド名
 * @return フィールドの値。フィールドが存在しない場合はNO
 */
- (BOOL)boolForKey:(NSString *)key;

/**
 * @brief 指定されたフィールドの値をブール値として返します
 * @param keyPath フィールド名。入れ子になったフィールドの値をドットで繋げて指定できます
 * @return フィールドの値。フィールドが存在しない場合はNO
 */
- (BOOL)boolForKeyPath:(NSString *)keyPath;

/**
 * @brief このオブジェクトを更新します。baasdsayサーバへの反映は即時に行われます。
 *
 * valuesに含まれるフィールドを対応する値で更新します。
 * 特別なキーを持つディクショナリをフィールドの値として指定すると、そのフィールドに対して特別な更新を行えます($incなら数値の増加など)。
 * @param values 更新するフィールドと値
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 更新が成功した場合はYES、それ以外はNO
 */
- (BOOL)update:(NSDictionary *)values error:(NSError **)error;

/**
 * @brief このオブジェクトを更新します。baasdayサーバへの反映は即時に行われます。
 *
 * valuesに含まれるフィールドを対応する値で更新します。
 * 特別なキーを持つディクショナリをフィールドの値として指定すると、そのフィールドに対して特別な更新を行えます($incなら数値の増加など)。
 * @param values 更新するフィールドと値
 * @return 更新が成功した場合はYES、それ以外はNO
 */
- (BOOL)update:(NSDictionary *)values;

/**
 * @brief このオブジェクトを更新します。baasdayサーバへの反映は即時に行われます。
 *
 * valuesに含まれるフィールドを対応する値で更新します。
 * 特別なキーを持つディクショナリをフィールドの値として指定すると、そのフィールドに対して特別な更新を行えます($incなら数値の増加など)。
 * @param values 更新するフィールドと値
 * @param block 更新が完了したか、失敗したときに呼び出されます
 */
- (void)updateInBackground:(NSDictionary *)values block:(void(^)(id object, NSError *error))block;

/**
 * @brief このオブジェクトをbaasdayサーバ上から削除します。
 * @param error エラーが発生した場合この引数が指す場所に格納されます
 * @return 削除が成功した場合はYES、それ以外はNO
 */
- (BOOL)deleteWithError:(NSError **)error;

/**
 * @brief このオブジェクトをbaasdayサーバ上から削除します。
 * @return 削除が成功した場合はYES
 */
- (BOOL)delete;

/**
 * @brief このオブジェクトをbaasdayサーバ上から削除します。
 * @param block 削除が完了したか、失敗したときに呼び出されます
 */
- (void)deleteInBackground:(void(^)(id object, NSError *error))block;

@end
