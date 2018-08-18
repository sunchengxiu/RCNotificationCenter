//
//  RCNotificationManager.h
//  RCNotificationCenter
//
//  Created by 孙承秀 on 2018/8/18.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCNotificationCenter : NSObject
+ (void)postNotificationName:(NSString *)name objectInfo:(NSDictionary *)objectInfo complement:(void (^)(id value))complement;
+ (void)addObserver:(id )observer name:(NSString *)name complement:(id (^)(id observer , NSDictionary *objectInfo))complement;
@end
