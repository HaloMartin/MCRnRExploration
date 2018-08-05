//
//  main.m
//  MCRnRExploration
//
//  Created by M君 on 02/08/2018.
//  Copyright © 2018 M君. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 为了看到OC代码转成C++代码，需要使用clang重新编译main.m
 * 步骤1,打开Terminal终端，cd到main.m所在目录
 * 步骤2，使用clang -rewrite-objc main.m 重新编译
 * 步骤3，在main.m的目录查看生成的文件，main.m对应的是main.cpp文件
 */
#import <objc/runtime.h>

/** @brief RnR表示的是 Runtime & RunLoop
 * 这个工程中的代码也都是与之相关的，主要是为了探索Runtime和RunLoop的应用，虽然相关文章看了一些，但是这个是第一次自己写代码的方式来记录
 */

#import "Person.h"


#pragma mark - main
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p = [[Person alloc] init];
        [p eat];
        extern void instrumentObjcMessageSends(BOOL);
        instrumentObjcMessageSends(YES);
        [p performSelector:@selector(run)];//模仿一个不存在的实例方法消息
//        [Person performSelector:@selector(classMethod)];//模仿一个不存在的类方法消息
        instrumentObjcMessageSends(NO);
    }
    return 0;
}
