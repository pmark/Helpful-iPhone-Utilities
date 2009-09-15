//
//  BTLFullScreenCameraController.m
//
//  Created by P. Mark Anderson on 8/6/2009.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import "BTLFullScreenCameraController.h"

@implementation BTLFullScreenCameraController

- (id)init {
  if (self = [super init]) {
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.showsCameraControls = NO;
    self.navigationBarHidden = YES;
    self.toolbarHidden = YES;
    self.wantsFullScreenLayout = YES;
    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, 1.13f, 1.13f);    
  }
  return self;
}

+ (BOOL)isAvailable {
  return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)displayModalWithController:(UIViewController*)controller animated:(BOOL)animated {
  [controller presentModalViewController:self animated:YES];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
  [[self parentViewController] dismissModalViewControllerAnimated:animated];
}

- (void)takePicture {
	self.delegate = self;
	[super takePicture];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"took picture: %@", info);
}


@end
