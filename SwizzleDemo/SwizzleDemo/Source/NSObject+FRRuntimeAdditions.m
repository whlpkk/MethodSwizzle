//
//  NSObject+FRRuntimeAdditions.m
//  SwizzleDemo
//
//  Created by YZK on 2023/1/16.
//

#import "NSObject+FRRuntimeAdditions.h"

void class_swizzleMethod(Class class, SEL originalSEL, SEL replacementSEL)
{
    //class_getInstanceMethod()，如果子类没有实现相应的方法，则会返回父类的方法。
    Method originMethod = class_getInstanceMethod(class, originalSEL);
    NSCAssert(NULL != originMethod,
              @"Selector %@ not found in %@ methods of class %@.",
              NSStringFromSelector(originalSEL),
              class_isMetaClass(class) ? @"class" : @"instance",
              class);
    
    Method replaceMethod = class_getInstanceMethod(class, replacementSEL);
    NSCAssert(NULL != replaceMethod,
              @"Selector %@ not found in %@ methods of class %@.",
              NSStringFromSelector(replacementSEL),
              class_isMetaClass(class) ? @"class" : @"instance",
              class);
    
    //class_addMethod() 判断originalSEL是否在子类中实现，如果只是继承了父类的方法，没有重写，那么直接调用method_exchangeImplementations，则会交换父类中的方法和当前的实现方法。此时如果用父类调用originalSEL，因为方法已经与子类中调换，所以父类中找不到相应的实现，会抛出异常unrecognized selector.
    //当class_addMethod() 返回YES时，说明子类未实现此方法(根据SEL判断)，此时class_addMethod会添加（名字为originalSEL，实现为replaceMethod）的方法。此时在将replacementSEL的实现替换为originMethod的实现即可。
    //当class_addMethod() 返回NO时，说明子类中有该实现方法，此时直接调用method_exchangeImplementations交换两个方法的实现即可。
    //注：如果在子类中实现此方法了，即使只是单纯的调用super，一样算重写了父类的方法，所以class_addMethod() 会返回NO。
    
    //可用BaseClass实验
    if(class_addMethod(class, originalSEL, method_getImplementation(replaceMethod),method_getTypeEncoding(replaceMethod)))
    {
        class_replaceMethod(class,replacementSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}

//有时为了避免方法命名冲突和参数 _cmd 被篡改，也会使用下面这种『静态方法版本』的 Method Swizzle。CaptainHook 中的宏定义也是采用这种方式，比较推荐：
BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMP *store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}



@implementation NSObject (FRRuntimeAdditions)

// 第一种方式hook，优点用法简单。缺点：可能方法命名冲突、修改了_cmd参数。
+ (void)swizzleInstanceMethod:(SEL)originalSEL with:(SEL)replacementSEL
{
    class_swizzleMethod(self, originalSEL, replacementSEL);
}

+ (void)swizzleClassMethod:(SEL)originalSEL with:(SEL)replacementSEL
{
    //类方法实际上是储存在类对象的类(即元类)中，即类方法相当于元类的实例方法,所以只需要把元类传入，其他逻辑和交互实例方法一样。
    Class metaClass = object_getClass(self);
    class_swizzleMethod(metaClass, originalSEL, replacementSEL);
}
// 用法如下：
//+ (void)load {
//    [self swizzleInstanceMethod:@selector(pointInside:withEvent:)
//                           with:@selector(yzk_pointInside:withEvent:)];
//}


// 第二种方式hook，优点就是避免了第一种的缺点。缺点：用法稍显复杂。
+ (BOOL)swizzleInstanceMethod:(SEL)original with:(IMP)replacement store:(IMP *)store {
    return class_swizzleMethodAndStore(self, original, replacement, store);
}

+ (BOOL)swizzleClassMethod:(SEL)original with:(IMP)replacement store:(IMP *)store {
    Class metaClass = object_getClass(self);
    return class_swizzleMethodAndStore(metaClass, original, replacement, store);
}
// 用法如下：
//static void MethodSwizzle(id self, SEL _cmd, id arg1);
//static void (*MethodOriginal)(id self, SEL _cmd, id arg1);
//
//static void MethodSwizzle(id self, SEL _cmd, id arg1) {
//    // do custom work
//    MethodOriginal(self, _cmd, arg1);
//}
//+ (void)load {
//    [self swizzle:@selector(originalMethod:) with:(IMP)MethodSwizzle store:(IMP *)&MethodOriginal];
//}

@end



