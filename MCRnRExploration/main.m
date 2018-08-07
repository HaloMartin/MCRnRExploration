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
#import "Person+Engineer.h"//分类，演示动态添加属性


#pragma mark - main
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p = [[Person alloc] init];
        NSLog(@"Number Of Failure:%d",p->_isIvar);//访问声明称public的成员变量，需要使用->，而访问属性使用的是‘.’
        [p eat];
        printf("/*************************************************************************************************************************/\n");
        
/********************************************************************************/
        
        /** Runtime修改属性值 Start */
//        //默认Person对象的初始值：name：HelloWorld，gender：0，age：28
//        NSLog(@"Before modified, name:%@, gender:%zd, age:%zd, privateMember:%@",p.name,p.gender,p.age,object_getIvar(p, class_getInstanceVariable([p class], "_privateMember")));
//        unsigned int count = 0;
//        Ivar *vars = class_copyIvarList([p class], &count);//获取所有的属性，包括私有
//        for (int i = 0; i < count; i ++) {
//            Ivar var = vars[i];
//            NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(var)];
//            NSLog(@"Ivar %@, type:%s",propertyName,ivar_getTypeEncoding(var));
//            if ([propertyName isEqualToString:@"_name"]) {
//                object_setIvar(p, var, @"TestModified");
//            }else if ([propertyName isEqualToString:@"_gender"]) {
//                [p setValue:@1 forKey:@"_gender"];
////                object_setIvar(p, var, @1);//属性类型为NSUInteger时，使用object_setIvar设置的值有异常
//            }else if ([propertyName isEqualToString:@"_age"]) {
//                [p setValue:@21 forKey:@"_age"];
//            }else if ([propertyName isEqualToString:@"_privateMember"]) {
//                object_setIvar(p, var, @"privateMemberModified");
//            }
//        }
//        free(vars);
//        NSLog(@"After modified, name:%@, gender:%zd, age:%zd，privateMember:%@",p.name,p.gender,p.age,object_getIvar(p, class_getInstanceVariable([p class], "_privateMember")));
//#if 0 //打开可以查看日志来查看valueForKey：部分调用过程
//        NSLog(@"privateMember:%@", [p valueForKey:@"_privateMember"]);
//#endif
        /** Runtime修改属性值 End */
        
/********************************************************************************/
        
        /** Runtime消息传递和转发机制Demo Start */
//        extern void instrumentObjcMessageSends(BOOL);
//        instrumentObjcMessageSends(YES);
//        [p performSelector:@selector(run)];//模仿一个不存在的实例方法消息
////        [Person performSelector:@selector(classMethod)];//模仿一个不存在的类方法消息
//        instrumentObjcMessageSends(NO);
        /** Runtime消息传递和转发机制Demo End */
        
/********************************************************************************/
        
//        /** Runtime应用，类别添加属性 Start */
//        //代码中在分类里添加了属性，添加了对象关联，但是没有成员变量
//        //如果不使用属性，则需要设置一个静态的在对象内唯一的常量作为key
//        //我在源码中利用的是属性的getter方法的唯一性作为key，@selector(<getter>)
//        //网上的博文中有提到使用static变量，但是这会全局占用一个，不推荐
//        p.job = @"Repairing";
//        [p repairMechine];
//        NSLog(@"Dynamically add property:job, %@",p.job);
//        /** Runtime应用，类别添加属性 End */
        
/********************************************************************************/
        
        /** Runtime应用，动态添加方法 Start */
//        [p addMethod:@selector(dyncMethod)];//动态添加方法
//        [p performSelector:@selector(dyncMethod)];
//        [p addMethod:@selector(eat)];//动态添加方法不能覆盖实例方法实现，但是可以覆盖父类的方法实现
//        [p performSelector:@selector(eat)];
//        class_replaceMethod(p.class, @selector(eat), (IMP)dynamicallyAddMethodImp, "v@:");//如果方法存在则替换，不存在则添加
//        method_setImplementation(class_getInstanceMethod(p.class, @selector(eat)), (IMP)dynamicallyAddMethodImp);//方法存在时，使用该方法替换原来的实现IMP，会返回旧的实现IMP
        /** Runtime应用，动态添加方法 End */
        
/********************************************************************************/
        
//        /** Runtime应用，交换方法的实现，可以交换同一个类的，也可以替换不同类的 Start */
//        NSLog(@"Before exchange implementation, exchangeImplementationA return:%@, exchangeImplementationB return:%@",[p exchangeImplementationA], [p exchangeImplementationB]);
//        Method impA = class_getInstanceMethod([p class], @selector(exchangeImplementationA));
//        Method impB = class_getInstanceMethod([p class], @selector(exchangeImplementationB));
//        method_exchangeImplementations(impA, impB);//交换方法的实现
//        NSLog(@"After exchange implementation, exchangeImplementationA return:%@, exchangeImplementationB return:%@",[p exchangeImplementationA], [p exchangeImplementationB]);
//        //
//        /** 实际应用技术Method Swizzling，主要使用了几个方法：
//         1. class_getInstanceMethod()
//         2. class_addMethod()
//         3. class_replaceMethod()
//         4. method_exchangeImplementations()
//         需要注意，使用时需要满足几个要求：
//         1. 应该总是在+(void)load中执行；
//         2. 保证多线程，即使用dispatch_once
//         3. 交换的实现调用原实现注意不能产生死循环（出于安全角度，还是要调用）
//         */
//        /** Runtime应用，交换方法的实现，可以交换同一个类的，也可以替换不同类的 End */
        
/********************************************************************************/
        
//        /** Runtime应用，归档解档 Start */
//        //类Person需要实现NSCoding协议，包含两个required方法；如果成员变量包含是其他类的成员，则其他类也要实现该协议
//        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:p];
//        NSLog(@"Person archivedData:%@", archivedData);
//        Person *anotherPerson = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
//        NSLog(@"Person unarchive to anotherPerson");
//        unsigned int count = 0;
//        Ivar *varList = class_copyIvarList(anotherPerson.class, &count);
//        for (int i = 0; i < count; i ++) {
//            Ivar var = varList[i];
//            NSLog(@"%s:%@",ivar_getName(var), [anotherPerson valueForKey:[NSString stringWithUTF8String:ivar_getName(var)]]);
//        }
//        free(varList);
//        /** Runtime应用，归档解档 End */
        
/********************************************************************************/
        
//        /** Runtime应用，字典转模型 Start */
//        NSDictionary *dict = @{@"name":@"FromDict",@"gender":@1,@"age":@25,@"privateMember":@"pMember",@"job":@"Transfer",@"book":@{@"name":@"BookName",@"author":@"Dictionary"}};
//        Person *anotherPerson = [Person modelWithDictionary:dict];
//        unsigned int count = 0;
//        objc_property_t *propertyList = class_copyPropertyList(anotherPerson.class, &count);
//        for (int i = 0; i < count; i ++) {
//            objc_property_t property = propertyList[i];
//            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
//            if ([propertyName isEqualToString:@"book"]) {
//                id cls = [anotherPerson valueForKey:propertyName];
//                NSLog(@"%@(%@,%@)",propertyName,[cls valueForKey:@"name"],[cls valueForKey:@"author"]);
//            }else {
//                NSLog(@"%@ %@",propertyName,[anotherPerson valueForKey:propertyName]);
//            }
//        }
//        free(propertyList);
//        NSLog(@"Person dict2Model name:%@, gender:%zd, age:%zd, privateMember:%@,job:%@,book:%@",anotherPerson.name,anotherPerson.gender,anotherPerson.age,[anotherPerson valueForKey:@"privateMember"],anotherPerson.job,[anotherPerson valueForKey:@"book"]);
//        //privateMember和book是私有属性，需要使用KVO方式取值
//        /** Runtime应用，字典转模型 End */
        
/********************************************************************************/
        
        printf("/*************************************************************************************************************************/\n");
        {//获取成员变量列表
            unsigned int count = 0;
            Ivar *varList = class_copyIvarList([p class], &count);
            for (int i = 0; i < count; i ++) {
                Ivar var = varList[i];
                NSLog(@"Ivar %s, type:%s",ivar_getName(var),ivar_getTypeEncoding(var));
            }
            free(varList);
        }
        {//获取属性列表
            unsigned int count = 0;
            objc_property_t *propertyList = class_copyPropertyList([p class], &count);
            for (int i = 0; i < count; i ++) {
                objc_property_t property = propertyList[i];
                NSLog(@"objc_property_t %s, type:%s",property_getName(property),property_getAttributes(property));
            }
            free(propertyList);
        }
        {//获取方法列表，不包括类方法
            unsigned int insMethodCount = 0;
            Method *insMethodList = class_copyMethodList([p class], &insMethodCount);
            for (int i = 0; i < insMethodCount; i ++) {
                Method method = insMethodList[i];
                struct objc_method_description *methodDescription = method_getDescription(method);
                NSLog(@"Instance Method %@, attributes:%s",NSStringFromSelector(method_getName(method)), methodDescription->types);
            }
            free(insMethodList);
        }
        {//获取方法列表，不包括实例方法
            unsigned int clsMethodCount = 0;
            Method *clsMethodList = class_copyMethodList(object_getClass([p class]), &clsMethodCount);
            for (int i = 0; i < clsMethodCount; i ++) {
                Method method = clsMethodList[i];
                struct objc_method_description *methodDescription = method_getDescription(method);
                NSLog(@"Class Method %@, attributes:%s",NSStringFromSelector(method_getName(method)), methodDescription->types);
            }
            free(clsMethodList);
        }
        {//获取协议列表
            unsigned int protocolCount = 0;
            Protocol * __unsafe_unretained *protocolList = class_copyProtocolList([p class], &protocolCount);
            for (int i = 0; i < protocolCount; i ++) {
                Protocol *protocol = protocolList[i];
                NSLog(@"Protocol %s",protocol_getName(protocol));
            }
            free(protocolList);
        }
#if 0
        {//获取所有加载的Class
            unsigned int clsCount = 0;
            Class *clsList = objc_copyClassList(&clsCount);
            for (int i = 0; i < clsCount; i ++) {
                Class cls = clsList[i];
                NSLog(@"Class %s,image:%s",class_getName(cls),class_getImageName(cls));
            }
        }
        {//获取所有加载的Objective-C框架和动态库的名称
            unsigned int imageCount = 0;
            const char *__unsafe_unretained * imageList = objc_copyImageNames(&imageCount);
            for (int i = 0; i < imageCount; i ++) {
                const char *image = imageList[i];
                NSLog(@"image:%s",image);
            }
            free(imageList);
        }
#endif
    }
    return 0;
}
