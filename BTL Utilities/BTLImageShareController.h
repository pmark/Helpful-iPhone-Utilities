//
//  BTLImageShareController.h
//  Bubble
//
//  Created by P. Mark Anderson on 9/22/09.
//  Copyright 2009 Bordertown Labs. All rights reserved.
//

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
