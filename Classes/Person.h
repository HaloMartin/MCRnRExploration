//
//  NSObject+Person.h
//  MCRnRExploration
//
//  Created by M君 on 02/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol walkDelegate <NSObject>
@property (nonatomic, strong) NSString *from;//协议中可以声明属性
@property (nonatomic, strong) NSString *to;//
@end

/** 创建Person，试验Runtime的消息转发机制
 * 该类中之声明了一个eat方法，其他的方法都需要通过消息转发机制来支持，否则会执行doesNotRecognizeSelector:提示unrecognized selector后崩溃
 */
#pragma mark - Person
@interface Person : NSObject<NSCoding,walkDelegate>
{
    @public//默认是protected，需要使用public外部才能访问
    int _isIvar;//成员变量
}

@property (nonatomic, strong) NSString *name;//名字
@property (nonatomic, assign) NSUInteger gender;//性别
@property (nonatomic, assign) NSUInteger age;//年龄

+(instancetype)modelWithDictionary:(NSDictionary *)dict;

-(void)eat;

-(void)addMethod:(SEL)sel;

-(NSString *)exchangeImplementationA;
-(NSString *)exchangeImplementationB;

@end

