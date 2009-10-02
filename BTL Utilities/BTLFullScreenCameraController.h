//
//  BTLFullScreenCameraController.h
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
    
#import <UIKit/UIKit.h>

// See HelpfulUtilities_Prefix.pch
#ifdef BTL_INCLUDE_IMAGE_SHARING
	#import "BTLImageShareController.h"
#endif


@interface BTLFullScreenCameraController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	UIViewController *overlayController;
	UILabel *statusLabel;
	UIImageView *shadeOverlay;
	
#ifdef BTL_INCLUDE_IMAGE_SHARING
	BTLImageShareController *shareController;
#endif

}

@property (nonatomic, retain) UIViewController *overlayController;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIImageView *shadeOverlay;

#ifdef BTL_INCLUDE_IMAGE_SHARING
	@property (nonatomic, retain) BTLImageShareController *shareController;
#endif

+ (BOOL)isAvailable;
- (void)displayModalWithController:(UIViewController*)controller animated:(BOOL)animated;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;
- (void)takePicture;
- (void)writeImageToDocuments:(UIImage*)image;
- (void)initStatusMessage;
- (void)showStatusMessage:(NSString*)message;
- (void)hideStatusMessage;
- (void)showShadeOverlay;
- (void)hideShadeOverlay;
- (void)animateShadeOverlay:(CGFloat)alpha;

@end
