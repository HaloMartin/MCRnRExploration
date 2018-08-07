//
//  Person+Engineer.m
//  MCRnRExploration
//
//  Created by M君 on 06/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import "Person+Engineer.h"
#import <objc/message.h>

@implementation NSArray (BeyondBoundsException)

-(id)OoR_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self OoR_objectAtIndex:index];//因为已经交换了实现，所以为了不陷入死循环，必须调用的是OoR_objectAtIndex:
}

@end


//虽然添加了关联，但还是没有对应的成员变量的
@implementation Person (Engineer)

#if 1
@dynamic job;//在分类中使用@dynamic声明属性，需要用户自己实现setter和getter方法，这样可以暂时去掉警告，但是没有没有实现则使用'.'语法会崩溃
//在分类中使用对象关联，给属性job添加setter和getter方法
- (void)setJob:(NSString *)job
{
    objc_setAssociatedObject(self, @selector(job), job, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)job
{
    return objc_getAssociatedObject(self, @selector(job));
}
#endif

- (void)repairMechine
{
    NSLog(@"Repairing Mechine");
}

@end
