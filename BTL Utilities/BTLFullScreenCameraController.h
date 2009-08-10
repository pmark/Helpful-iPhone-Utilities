//
//  BTLFullScreenCameraController.h
//  ViewThing1
//
//  Created by P. Mark Anderson on 8/6/2009.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTLFullScreenCameraController : UIImagePickerController {
}

+ (BOOL)isAvailable;
- (void)displayWithController:(UIViewController*)controller;
- (void)dismiss;
- (void)displayModalWithController:(UIViewController*)controller animated:(BOOL)animated;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;

@end
