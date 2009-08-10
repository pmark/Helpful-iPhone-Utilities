//
//  Example.h
//  ExampleEditor
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//


@interface Example : NSObject {
  NSString *title;
  NSString *controllerClass;
}

- (id)initWithTitle:(NSString *)newTitle 
            controllerClass:(NSString *)newControllerClass;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *controllerClass;

@end