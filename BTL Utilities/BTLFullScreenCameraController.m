//
//  BTLFullScreenCameraController.m
//
//  Created by P. Mark Anderson on 8/6/2009.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import "BTLFullScreenCameraController.h"
#include <QuartzCore/QuartzCore.h>

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

- (UIImage*)dumpOverlayViewToImage {
	UIGraphicsBeginImageContext(self.cameraOverlayView.bounds.size);
	[self.cameraOverlayView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage {
	UIImage *overlayImage = [self dumpOverlayViewToImage];	
	CGPoint topCorner = CGPointMake(0, 0);
	CGSize targetSize = CGSizeMake(320, 480);	
	CGRect scaledRect = CGRectZero;
	scaledRect.origin = CGPointMake(0.0,0.0);
	scaledRect.size.width  = 320;
	scaledRect.size.height = 480;
	
	UIGraphicsBeginImageContext(targetSize);	
	[baseImage drawInRect:scaledRect];
	[overlayImage drawAtPoint:topCorner];	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return result;	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *baseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (baseImage) {
		UIImage *compositeImage = [self addOverlayToBaseImage:baseImage];
		UIImageWriteToSavedPhotosAlbum(compositeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	}
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info {
	NSLog(@"Done saving image to photo album");
	[self writeImageToDocuments:image];
}

- (void)writeImageToDocuments:(UIImage*)image {
	NSData *png = UIImagePNGRepresentation(image);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSError *error = nil;
	[png writeToFile:[documentsDirectory stringByAppendingPathComponent:@"image.png"] options:NSAtomicWrite error:&error];
	NSLog(@"Done saving image.png to documents directory");
}


@end
