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
	CGPoint startTouchPosition;
	UILabel *overlayLabel;
}

@property (nonatomic, retain) BTLFullScreenCameraController *camera;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UILabel *overlayLabel;
@property (assign) BOOL cameraMode;
@property (nonatomic) CGPoint startTouchPosition;

- (void)initCamera;
- (void)toggleAugmentedReality;
- (void)startCamera;
- (void)onSingleTap:(UITouch*)touch;
- (void)onDoubleTap:(UITouch*)touch;
- (void)onSwipeUp;
- (void)onSwipeDown;
- (void)onSwipeLeft;
- (void)onSwipeRight;
- (void)cameraWillTakePicture:(id)sender;
- (void)cameraDidTakePicture:(id)sender;

@end
