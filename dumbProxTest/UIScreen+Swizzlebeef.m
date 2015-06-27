//
// Created by spawrks on 6/26/15.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "UIScreen+Swizzlebeef.h"
#import <objc/runtime.h>


@implementation UIScreen (Swizzlebeef)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

//        SEL originalSelector = @selector(handleEvent:withNewEvent:);
        SEL originalSelector = @selector(initWithDisplay:);
        SEL swizzledSelector = @selector(xxx_method:);


        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
                class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                    swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

//- (id)xxx_method:(id)arg selector:(SEL)arg2 {
//    NSLog(@"HEY STUFF HAPPENED: %@", self);
//    return [self xxx_method:arg selector:arg2];
//
//}

- (id)xxx_method:(id)arg {
    NSLog(@"HEY STUFF HAPPENED: %@", self);
    return [self xxx_method:arg];

}

//- (id)xxx_method {
//    return [self xxx_method];
//    NSLog(@"_setProxmityState: %@", self);
//}

//- (void)xxx_method {
//    [self xxx_method];
//    NSLog(@"_setProxmityState: %@", self);
//}

//handleEvent:(struct __GSEvent { }*)arg1 withNewEvent:(id)arg2;
//- (BOOL)xxx_method:(struct __GSEvent { }*)arg1 withNewEvent:(id)arg2 {
//    NSLog(@"_setProxmityState: %@", self);
//    return NO;//[self xxx_method:arg1 withNewEvent:arg2];
//}
@end