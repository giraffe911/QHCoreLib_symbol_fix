//
//  Foundation+QHCoreLib.m
//  QHCoreLib
//
//  Created by changtang on 2017/5/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "Foundation+QHCoreLib.h"

#import "QHMacros.h"
#import "QHUtil.h"
#import "QHDefaultValue.h"


QH_DUMMY_CLASS(FoudationQHCoreLib)


@implementation NSObject (QHCoreLib)

+ (instancetype)qh_cast:(id)obj
{
    return [self qh_cast:obj warnOnFailure:YES];
}

+ (instancetype)qh_cast:(id)obj warnOnFailure:(BOOL)warnOnFailure
{
    if (obj == nil) return nil;

    if ([obj isKindOfClass:self]) {
        return obj;
    }
    else {
        if (warnOnFailure == YES) {
            QHCoreLibWarn(@"cast %@{%@} to %@ failed\n%@",
                          NSStringFromClass([obj class]),
                          obj,
                          NSStringFromClass(self),
                          QHCallStackShort());
        }
        return nil;
    }
}

@end


@implementation NSArray (QHCoreLib)

- (NSArray *)qh_sliceFromStart:(NSUInteger)start length:(NSUInteger)length
{
    if (start >= self.count) {
        QHCoreLibWarn(@"start(%llu) is out of bound(%llu)\n%@",
                      (uint64_t)start, (uint64_t)self.count, QHCallStackShort());
        start = 0;
        length = 0;
    }

    if (start + length > self.count) {
        QHCoreLibWarn(@"length(%llu) is too long from start(%llu) for bound(%llu)\n%@",
                      (uint64_t)length, (uint64_t)start, (uint64_t)self.count, QHCallStackShort());
        length = self.count - start;
    }

    return [self subarrayWithRange:NSMakeRange(start, length)];
}

- (NSArray *)qh_filteredArrayWithBlock:(BOOL (^)(NSUInteger, id))block
{
    if (block) {
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];

        [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (block(idx, obj)) {
                [results qh_addObject:obj];
            }
        }];

        return [NSArray arrayWithArray:results];
    }
    else {
        QHCoreLibWarn(@"filtering array with nil block, just return an copy of self\n%@",
                      QHCallStackShort());
        return [NSArray arrayWithArray:self];
    }
}

- (NSArray *)qh_mappedArrayWithBlock:(id (^)(NSUInteger, id))block
{
        if (block) {
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];

        [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [results qh_addObject:block(idx, obj)];
        }];

        return [NSArray arrayWithArray:results];
    }
    else {
        QHCoreLibWarn(@"mapping array with nil block, just return an copy of self\n%@",
                      QHCallStackShort());
        return [NSArray arrayWithArray:self];
    }
}

- (id)qh_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    else {
        QHCoreLibWarn(@"index %llu is out of bound %llu\n%@",
                      (uint64_t)index, (uint64_t)self.count, QHCallStackShort());
        return nil;
    }
}


- (NSArray *)qh_objectsAtIndexes:(NSIndexSet *)indexes
{
    return [self objectsAtIndexes:[indexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        BOOL result = idx < self.count;
        if (result == NO) {
            QHCoreLibWarn(@"index %llu is out of bound %llu\n%@",
                          (uint64_t)index, (uint64_t)self.count, QHCallStackShort());
        }
        return result;
    }]];
}

@end

@implementation NSArray (QHCoreLibDefaultValue)

- (BOOL)qh_boolAtIndex:(NSUInteger)index
          defaultValue:(BOOL)defaultValue
{
    return QHBool([self qh_objectAtIndex:index], defaultValue);
}

- (NSInteger)qh_integerAtIndex:(NSUInteger)index
                  defaultValue:(NSInteger)defaultValue
{
    return QHInteger([self qh_objectAtIndex:index], defaultValue);
}

- (double)qh_doubleAtIndex:(NSUInteger)index
              defaultValue:(double)defaultValue
{
    return QHDouble([self qh_objectAtIndex:index], defaultValue);
}

- (NSString *)qh_stringAtIndex:(NSUInteger)index
                  defaultValue:(NSString *)defaultValue
{
    return QHString([self qh_objectAtIndex:index], defaultValue);
}

- (NSArray *)qh_arrayAtIndex:(NSUInteger)index
                defaultValue:(NSArray *)defaultValue
{
    return QHArray([self qh_objectAtIndex:index], defaultValue);
}

- (NSDictionary *)qh_dictionaryAtIndex:(NSUInteger)index
                          defaultValue:(NSDictionary *)defaultValue
{
    return QHDictionary([self qh_objectAtIndex:index], defaultValue);
}

@end

@implementation NSMutableArray (QQHouseUtil)

- (void)qh_addObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
    else {
        QHCoreLibWarn(@"add nil object to array\n%@", QHCallStackShort());
    }
}

- (void)qh_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        if (index > [self count]) {
            QHCoreLibWarn(@"insert at index(%llu) larger than self.count(%llu)\n%@",
                          (uint64_t)index, (uint64_t)self.count, QHCallStackShort());
            index = [self count];
        }
        [self insertObject:anObject atIndex:index];
    }
    else {
        QHCoreLibWarn(@"insert nil object to dictionary\n%@", QHCallStackShort());
    }
}

- (void)qh_removeObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
    else {
        QHCoreLibWarn(@"remove index(%llu) out of bound(%llu)\n%@",
                      (uint64_t)index, (uint64_t)self.count, QHCallStackShort());
    }
}

@end

@implementation NSDictionary (QHCoreLib)

- (NSDictionary *)qh_mappedDictionaryWithBlock:(id (^)(id key, id obj))block
{
    if (block) {
        __block NSMutableDictionary *results = [NSMutableDictionary dictionary];
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [results qh_setObject:block(key, obj) forKey:key];
        }];
        return results;
    }
    else {
        QHCoreLibWarn(@"mapping dictionary with nil block, just return an copy of self\n%@",
                      QHCallStackShort());
        return [NSDictionary dictionaryWithDictionary:self];
    }
}

@end

@implementation NSDictionary (QHCoreLibDefaultValue)

- (BOOL)qh_boolForKey:(id<NSCopying>)key
         defaultValue:(BOOL)defaultValue
{
    return QHBool([self objectForKey:key], defaultValue);
}

- (NSInteger)qh_integerForKey:(id<NSCopying>)key
                 defaultValue:(NSInteger)defaultValue
{
    return QHInteger([self objectForKey:key], defaultValue);
}

- (double)qh_doubleForKey:(id<NSCopying>)key
             defaultValue:(double)defaultValue
{
    return QHDouble([self objectForKey:key], defaultValue);
}

- (NSString *)qh_stringForKey:(id<NSCopying>)key
                 defaultValue:(NSString *)defaultValue
{
    return QHString([self objectForKey:key], defaultValue);
}

- (NSArray *)qh_arrayForKey:(id<NSCopying>)key
               defaultValue:(NSArray *)defaultValue
{
    return QHArray([self objectForKey:key], defaultValue);
}

- (NSDictionary *)qh_dictionaryForKey:(id<NSCopying>)key
                         defaultValue:(NSDictionary *)defaultValue
{
    return QHDictionary([self objectForKey:key], defaultValue);
}

@end

@implementation NSMutableDictionary (QHCoreLib)

- (void)qh_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
    else {
        QHCoreLibWarn(@"set object(%@) for key(%@) ignored\n%@",
                      anObject, aKey, QHCallStackShort());
    }
}

@end

@implementation NSMutableSet (QHCoreLib)

- (void)qh_addObject:(id)object
{
    if (object != nil) {
        [self addObject:object];
    }
    else {
        QHCoreLibWarn(@"add nil object to set: %@",
                      QHCallStackShort());
    }
}

@end

@implementation NSUserDefaults (QHCoreLib)

- (void)qh_setObject:(id)object forKey:(NSString *)key
{
    @try {
        [self setObject:object forKey:key];
    }
    @catch (NSException *exception) {
        QHCoreLibFatal(@"set object(%@) for key(%@) in %@ failed: %@\n%@",
                       object, key, self,
                       [exception qh_description],
                       [exception callStackSymbols]);
    }
    @finally {}
}

@end

@implementation NSException (QHCoreLib)

- (NSString *)qh_description
{
    return [NSString stringWithFormat:@"(%@, %@, %@, %@)",
            NSStringFromClass([self class]),
            self.name,
            self.reason,
            self.userInfo];
}

@end

@interface _QHError : NSError
@end
@implementation _QHError
- (NSString *)description
{
    return $(@"<QHError: %@, %zd, %@>", self.domain, self.code, self.localizedDescription);
}
@end

@implementation NSError (QHCoreLib)

+ (instancetype)qh_errorWithDomain:(NSErrorDomain)domain
                              code:(NSInteger)code
                           message:(NSString *)message
                              info:(NSDictionary *)info
                              file:(const char *)file
                              line:(int)line
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (QH_IS_DICTIONARY(info)) {
        [userInfo addEntriesFromDictionary:info];
    }
    
    if (userInfo[NSLocalizedDescriptionKey]) {
        NSString *fileName = [[[NSString alloc] initWithCString:file encoding:NSUTF8StringEncoding] lastPathComponent];
        userInfo[NSLocalizedDescriptionKey] = $(@"*%@:%d, %@", fileName, line, message);
    }
    
    return [_QHError errorWithDomain:domain
                                code:code
                            userInfo:userInfo];
}

@end
