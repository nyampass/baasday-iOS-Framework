//
//  BDBasicObject.h
//  baasday
//

#import <Foundation/Foundation.h>

@interface BDBasicObject : NSObject

/**
 * @brief 全てのフィールドの値
 */
@property (readonly) NSDictionary *values;

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

@end
