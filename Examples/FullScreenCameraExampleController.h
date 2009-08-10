//
//  FullScreenCameraExampleController.h
//  HelpfulUtilities
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLFullScreenCameraController.h"
#import "MBProgressHUD.h"


@interface FullScreenCameraExampleController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  BTLFullScreenCameraController *camera;
  UIView *overlayView;
  BOOL cameraMode;
}

@property (nonatomic, retain) BTLFullScreenCameraController *camera;
@property (nonatomic, retain) UIView *overlayView;
@property (assign) BOOL cameraMode;

-(void)initCamera;
-(void)toggleAugmentedReality;
-(void)startCamera;

@end
