//
//  RCNotificationCenter.m
//  RCNotificationCenter
//
//  Created by 孙承秀 on 2018/8/18.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "RCNotificationCenter.h"
#import <objc/runtime.h>
#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(weak##type) strong##type = weak##type
#define LOCK() dispatch_semaphore_wait([RCNotificationCenter defaultCenter].semLock, DISPATCH_TIME_FOREVER);
#define UNLOCK() dispatch_semaphore_signal([RCNotificationCenter defaultCenter].semLock);
static void *BlockKey = "BlockKey";
static void *NameKey = "NameKey";
@interface RCNotificationCenter()

/**
 弱引用字典(已经注册过通知的)
 */
@property(nonatomic , strong)NSMapTable *mapTable;
/**
 锁
 */
@property(nonatomic , strong)dispatch_semaphore_t semLock;

@end
static RCNotificationCenter *center = nil;
@implementation RCNotificationCenter
#pragma mark - 单例
+ (instancetype)defaultCenter{
    return [[self alloc] init];
}
-(instancetype)init{
    static dispatch_once_t onceToken;
    WeakSelf(self);
    dispatch_once(&onceToken, ^{
        StrongSelf(self);
        center = [super init];
        strongself.mapTable = [NSMapTable mapTableWithKeyOptions:(NSPointerFunctionsStrongMemory) valueOptions:NSPointerFunctionsWeakMemory];
        strongself.semLock = dispatch_semaphore_create(1);
    });
    return center;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [super allocWithZone:zone];
    });
    return center;
}

-(id)copyWithZone:(NSZone __unused*)zone{
    return center;
}
- (id)mutableCopyWithZone:(NSZone __unused*)zone{
    return center;
}
+ (void)postNotificationName:(NSString *)name objectInfo:(NSDictionary *)objectInfo complement:(void (^)(id value))complement{
    __block id value = nil;
    LOCK();
    NSArray<NSString *> *keys = [[RCNotificationCenter defaultCenter].mapTable keyEnumerator].allObjects;
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:name]) {
            id observer = [[RCNotificationCenter defaultCenter].mapTable objectForKey:obj];
            id (^block)(id observer , NSDictionary *objectInfo) = objc_getAssociatedObject(observer, BlockKey);
            if (block) {
                value = block(observer , objectInfo);
                complement(value);
            }
        }
    }];
    UNLOCK();
}
+ (void)addObserver:(id )observer name:(NSString *)name complement:(id (^)(id observer , NSDictionary *objectInfo))complement{
    LOCK();

    objc_setAssociatedObject(observer, BlockKey, complement, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, NameKey, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *key = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%p",observer],name];
    [[RCNotificationCenter defaultCenter].mapTable setObject:observer forKey:key];
    UNLOCK();
}
@end
