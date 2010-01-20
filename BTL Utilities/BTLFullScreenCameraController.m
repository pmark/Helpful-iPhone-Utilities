//
//  BTLFullScreenCameraController.m
//
//  Created by P. Mark Anderson on 8/6/2009.
//  Copyright (c) 2009 Bordertown Labs, LLC.
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "BTLFullScreenCameraController.h"
#include <QuartzCore/QuartzCore.h>

#define CAMERA_SCALAR 1.12412 // scalar = (480 / (2048 / 480))

@implementation BTLFullScreenCameraController

@synthesize statusLabel, shadeOverlay, overlayController;

#ifdef BTL_INCLUDE_IMAGE_SHARING
@synthesize shareController;
#endif

- (id)init {
  if (self = [super init]) {
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.showsCameraControls = NO;
    self.navigationBarHidden = YES;
    self.toolbarHidden = YES;
    self.wantsFullScreenLayout = YES;
		self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, CAMERA_SCALAR, CAMERA_SCALAR);    		
		
		if ([self.overlayController respondsToSelector:@selector(initStatusMessage)]) {
			[self.overlayController performSelector:@selector(initStatusMessage)];
		} else {
			[self initStatusMessage];
		}		
  }
  return self;
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];	
	self.shadeOverlay = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay1.png"]] autorelease];
	self.shadeOverlay.alpha = 0.0f;
	[self.view addSubview:self.shadeOverlay];
}


+ (BOOL)isAvailable {
  return [self isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)displayModalWithController:(UIViewController*)controller animated:(BOOL)animated {
  [controller presentModalViewController:self animated:YES];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
  [self.overlayController dismissModalViewControllerAnimated:animated];
}

- (void)takePicture {
	if ([self.overlayController respondsToSelector:@selector(cameraWillTakePicture:)]) {
		[self.overlayController performSelector:@selector(cameraWillTakePicture:) withObject:self];
	}
	
	self.delegate = self;
	[self showStatusMessage:@"Taking photo..."];
	
#ifdef BTL_INCLUDE_IMAGE_SHARING
	if (self.shareController) {
		[self.shareController hideThumbnail];
	}
#endif
	
	[self showShadeOverlay];
	[super takePicture];
}

- (UIImage*)dumpOverlayViewToImage {
	CGSize imageSize = self.cameraOverlayView.bounds.size;
	UIGraphicsBeginImageContext(imageSize);
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
	
	CGFloat scaledX = 480 * baseImage.size.width / baseImage.size.height;
	CGFloat offsetX = (scaledX - 320) / -2;

	scaledRect.origin = CGPointMake(offsetX, 0.0);
	scaledRect.size.width  = scaledX;
	scaledRect.size.height = 480;
	
	UIGraphicsBeginImageContext(targetSize);	
	[baseImage drawInRect:scaledRect];	
	[overlayImage drawAtPoint:topCorner];	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return result;	
}

- (void)adjustLandscapePhoto:(UIImage*)image {
	// TODO: maybe use this for something
	NSLog(@"camera image: %f x %f", image.size.width, image.size.height);

	switch (image.imageOrientation) {
		case UIImageOrientationLeft:
		case UIImageOrientationRight:
			// portrait
			NSLog(@"portrait");
			break;
		default:
			// landscape
			NSLog(@"landscape");
			break;
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self showStatusMessage:@"Saving photo..."];
	UIImage *baseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (baseImage == nil) return;

	// save composite
	UIImage *compositeImage = [self addOverlayToBaseImage:baseImage];
	[self hideStatusMessage];
	[self hideShadeOverlay];

	if ([self.overlayController respondsToSelector:@selector(cameraDidTakePicture:)]) {
		[self.overlayController performSelector:@selector(cameraDidTakePicture:) withObject:self];
	}

	UIImageWriteToSavedPhotosAlbum(compositeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

#ifdef BTL_INCLUDE_IMAGE_SHARING
	// thumbnail
	if (self.shareController) {
		[self.shareController generateAndShowThumbnail:compositeImage];
		[self.shareController hideThumbnailAfterDelay:5.0f];
	}
#endif

}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info {
}

- (void)initStatusMessage {
	self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
	self.statusLabel.textAlignment = UITextAlignmentCenter;
	self.statusLabel.adjustsFontSizeToFitWidth = YES;
	self.statusLabel.backgroundColor = [UIColor clearColor];
	self.statusLabel.textColor = [UIColor whiteColor];
	self.statusLabel.shadowOffset = CGSizeMake(0, -1);  
	self.statusLabel.shadowColor = [UIColor blackColor];  
	self.statusLabel.hidden = YES;
	[self.view addSubview:self.statusLabel];	
}

- (void)showStatusMessage:(NSString*)message {
	if ([self.overlayController respondsToSelector:@selector(showStatusMessage:)]) {
		[self.overlayController performSelector:@selector(showStatusMessage) withObject:message];
	} else {
		self.statusLabel.text = message;
		self.statusLabel.hidden = NO;
		[self.view bringSubviewToFront:self.statusLabel];
	}
}

- (void)hideStatusMessage {
	if ([self.overlayController respondsToSelector:@selector(hideStatusMessage)]) {
		[self.overlayController performSelector:@selector(hideStatusMessage)];
	} else {
		self.statusLabel.hidden = YES;
	}
}

- (void)showShadeOverlay {
	[self animateShadeOverlay:0.82f];
}

- (void)hideShadeOverlay {
	[self animateShadeOverlay:0.0f];
}

- (void)animateShadeOverlay:(CGFloat)alpha {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.35f];
  self.shadeOverlay.alpha = alpha;
  [UIView commitAnimations];	
}

- (void)writeImageToDocuments:(UIImage*)image {
	NSData *png = UIImagePNGRepresentation(image);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSError *error = nil;
	[png writeToFile:[documentsDirectory stringByAppendingPathComponent:@"image.png"] options:NSAtomicWrite error:&error];
}

- (BOOL)canBecomeFirstResponder { return YES; }

- (void)dealloc {
	[overlayController release];
	[statusLabel release];
	[shadeOverlay release];
	
#ifdef BTL_INCLUDE_IMAGE_SHARING
	[shareController release];
#endif
  [super dealloc];
	
}


@end
