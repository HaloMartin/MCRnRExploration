//
//  NSObject+Person.h
//  MCRnRExploration
//
//  Created by M君 on 02/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 创建Person，试验Runtime的消息转发机制
 * 该类中之声明了一个eat方法，其他的方法都需要通过消息转发机制来支持，否则会执行doesNotRecognizeSelector:提示unrecognized selector后崩溃
 */
#pragma mark - Person
@interface Person : NSObject

-(void)eat;

@end

