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

#pragma mark - Book
@interface Book : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@end
@implementation Book
@end

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
@interface Person ()
@property (nonatomic, strong) NSString *privateMember;
@property (nonatomic, strong) Book *book;
@end
@implementation Person
@synthesize from=_from,to=_to;//@synthesize声明协议walkDelegate的属性from和to，生成相应的成员变量_from,_to，并生成对应的getter和setter方法,如果不使用关键词@synthesize进行修饰，则在使用的时候会因为缺少相应的方法而崩溃，提示unrecognized selector；可以手动添加属性实现代码来替代@synthesize
-(instancetype)init
{
    self = [super init];
    if (self) {
        logOrder = 1;
        _isIvar = 1;
        _name = @"HelloWorld";
        _gender = 0;
        _age = 28;
        _privateMember = @"privateMember";
        _book = [[Book alloc] init];
        _book.name = @"Beauty and Beast";
        _book.author = @"None";
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

#pragma mark - 动态添加方法
-(void)addMethod:(SEL)sel
{
    class_addMethod([self class], sel, (IMP)dynamicallyAddMethodImp, "v@:");
}
void dynamicallyAddMethodImp(id self, SEL _cmd)
{
    NSLog(@"Dynamically add method:%@ successfully", NSStringFromSelector(_cmd));
}

#pragma mark - 交换方法
-(NSString *)exchangeImplementationA
{
    return @"A";
}
-(NSString *)exchangeImplementationB
{
    return @"B";
}


#pragma mark - Runtime消息传递和转发机制
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

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{//归档
    unsigned int count = 0;
    Ivar *varList = class_copyIvarList(self.class, &count);
    for (int i = 0; i < count; i ++) {
        Ivar var = varList[i];
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(var)];
        [aCoder encodeObject:[self valueForKey:varName] forKey:varName];
    }
    free(varList);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{//解档
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *varList = class_copyIvarList(self.class, &count);
        for (int i = 0; i < count; i ++) {
            Ivar var = varList[i];
            NSString *varName = [NSString stringWithUTF8String:ivar_getName(var)];
            id value = [aDecoder decodeObjectForKey:varName];
            [self setValue:value forKey:varName];
        }
        free(varList);
    }
    return self;
}

#pragma mark - 字典转模型
+(instancetype)modelWithDictionary:(NSDictionary *)dict
{
    Person *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
//    unsigned int count = 0;
//    Ivar *varList = class_copyIvarList(self, &count);
//    for (int i = 0; i < count; i ++) {
//        Ivar var = varList[i];
//        NSString *varName = [NSString stringWithUTF8String:ivar_getName(var)];//成员变量名
//        NSString *propertyKey = [varName substringFromIndex:1];//属性变量名
//    }
//    free(varList);
    return model;
}


@end
