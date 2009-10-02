//
//  BTLImageShareController.h
//
//  Created by P. Mark Anderson on 9/22/09.
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

#ifdef BTL_INCLUDE_IMAGE_SHARING

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BTLImageShareController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UIImage *image;
	UIButton *imageButton;
	UIButton *thumbnailButton;
	id delegate;
}

@property (nonatomic,retain) UIImage *image;
@property (nonatomic,assign) id delegate;

- (void)hideThumbnail;
- (void)hideThumbnailAfterDelay:(CGFloat)delay;
- (void)showThumbnail:(UIImage *)newImage;
- (UIImage*)generateThumbnail:(UIImage*)source;
- (void)generateAndShowThumbnail:(UIImage*)source;
- (void)hidePreviewImage;

@end
#endif