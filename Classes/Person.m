//
//  Person.m
//  MCRnRExploration
//
//  Created by M君 on 02/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

static int logOrder = 0;

#pragma mark - Mechine
@interface Mechine : NSObject
@end
@implementation Mechine
- (void)MechineRun
{
    NSLog(@"Mecine Runing");
}
@end

#pragma mark - Animal
@interface Animal : NSObject
@end
@implementation Animal
- (void)run
{
    NSLog(@"Animal Runing");
}
@end

#pragma mark - Person
@implementation Person
-(instancetype)init
{
    self = [super init];
    if (self) {
        logOrder = 1;
    }
    return self;
}

-(void)eat {
    NSLog(@"Eating");
}
void dynamicallyResolvingMethodRun(id self, SEL _cmd)
{
    NSLog(@"Dynamically Rosolving Method Runing");
}
/** 消息发送，动态方法解析，分为实例方法和类方法 Start */
+(BOOL)resolveInstanceMethod:(SEL)sel//实例方法的动态方法解析，如果返回NO，则进入转发，返回YES重新进入lookUpImpOrForward:的Retry标签
{
    NSLog(@"%s recv %@, order:%d",__FUNCTION__,NSStringFromSelector(sel),logOrder);
    logOrder ++;
    if (sel == @selector(run)) {
        //指定新的IMP，并返回YES，而后重新执行方法的查找，但不会进入resolveInstanceMethod：方法，而是执行相关实现
        //链接文章，https://www.jianshu.com/p/d6097eade931（在objc-runtime-new.h的lookUpImpOrForward:中）
        //通过class_addMethod()来指定sel对应的IMP实现
//        class_addMethod([self class], sel, (IMP)dynamicallyResolvingMethodRun, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}
+(BOOL)resolveClassMethod:(SEL)sel//类方法的动态方法解析，如果返回NO，则进入转发，返回YES重新进入lookUpImpOrForward:的Retry标签
{
    NSLog(@"%s recv %@, order:%d",__FUNCTION__,NSStringFromSelector(sel),logOrder);
    logOrder ++;
#pragma clang diagnostic ignored "-Wundeclared-selector"//忽略方法未定义的警告，实际中不建议加，操作不当很容易忽略掉很重要的警告，仅作为调试手段就好
    if (sel == @selector(classMethod)) {
        //指定新的IMP，并返回YES，而后重新执行方法的查找，但不会进入resolveInstanceMethod：方法，而是执行相关实现
        //链接文章，https://www.jianshu.com/p/d6097eade931（在objc-runtime-new.h的lookUpImpOrForward:中）
        //通过class_addMethod()来指定sel对应的IMP实现
//        class_addMethod([self superclass], sel, (IMP)dynamicallyResolvingMethodRun, "v@:");
    }
    return [super resolveClassMethod:sel];
}
/** 消息发送，动态方法解析，分为实例方法和类方法 End */

/** 消息转发之一，备用接收者，实例方法能被这个方法接收到，但是类方法不行 Start */
-(id)forwardingTargetForSelector:(SEL)aSelector
{//把方法消息转发给指定的对象，即指定对象接收转发的aSelector消息
    NSLog(@"%s recv %@, order:%d",__FUNCTION__,NSStringFromSelector(aSelector),logOrder);
    logOrder ++;
    if (aSelector == @selector(run)
        || aSelector == @selector(classMethod)) {
        //返回一个实例对象，用来接收方法选择器对应的方法
//        return [Animal new];
    }
    return [super forwardingTargetForSelector:aSelector];
}
/** 消息转发之一，备用接收者，实例方法能被这个方法接收到，但是类方法不行 End */

/** 消息转发之二，消息重定向，依然是实例方法能进行，类方法没有 Start */
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector//获取函数的参数和返回值类型，如果返回nil，则runtime发出doesNotRecognizeSelector:
{
    NSLog(@"%s recv %@, order:%d",__FUNCTION__,NSStringFromSelector(aSelector),logOrder);
    logOrder ++;
    if (aSelector == @selector(run)
        || aSelector == @selector(classMethod)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];//返回方法签名，进入forwardInvocation:参数对应的TypeEncoding可以参考https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    }
    return [super methodSignatureForSelector:aSelector];
}
-(void)forwardInvocation:(NSInvocation *)anInvocation//完整的转发调用
{
    NSLog(@"%s recv %@, order:%d",__FUNCTION__,NSStringFromSelector(anInvocation.selector),logOrder);
    logOrder ++;
    if (anInvocation.selector == @selector(run)
        || anInvocation.selector == @selector(classMethod)) {
//        anInvocation.selector = NSSelectorFromString(@"MechineRun");
//        Mechine *forwardInvocation = [[Mechine alloc] init];
//        [anInvocation invokeWithTarget:forwardInvocation];
        [self doesNotRecognizeSelector:anInvocation.selector];
    }else {
        [super forwardInvocation:anInvocation];
    }
}
/** 消息转发之二，消息重定向，依然是实例方法能进行，类方法没有 End */
@end
