//
//  BTLImageShareController.m
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

#import "BTLImageShareController.h"
#import <QuartzCore/QuartzCore.h>

#define THUMBNAIL_WIDTH 50
#define THUMBNAIL_HEIGHT 75
#define THUMBNAIL_FRAME_WIDTH 50
#define THUMBNAIL_FRAME_HEIGHT 75
#define THUMBNAIL_FRAME_OFFSET_X 0
#define THUMBNAIL_FRAME_OFFSET_Y 0

@implementation BTLImageShareController

@synthesize image, delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
	thumbnailButton.frame = CGRectMake(self.view.frame.size.width - THUMBNAIL_FRAME_WIDTH - 10, 
																		 self.view.frame.size.height - THUMBNAIL_FRAME_HEIGHT - 10, 
																		 THUMBNAIL_FRAME_WIDTH, THUMBNAIL_FRAME_HEIGHT);
	[thumbnailButton addTarget:self action:@selector(thumbnailTapped:) forControlEvents:UIControlEventTouchUpInside];
	thumbnailButton.hidden = YES;
	[self.view addSubview:thumbnailButton];

	imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	imageButton.frame = CGRectMake(0, 0, 320, 480);
	[imageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
	imageButton.hidden = NO;
	imageButton.alpha = 0.0f;
	[self.view addSubview:imageButton];
}

- (void)thumbnailTapped:(id)sender {
	if ([self.delegate respondsToSelector:@selector(thumbnailTapped:)]) {
		[self.delegate thumbnailTapped:self];
	}
	
	[self hideThumbnail];

	// fade in full screen image
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [UIView setAnimationDuration:0.66f];
  imageButton.alpha = 1.0f;	
  [UIView commitAnimations];	

	[self.view bringSubviewToFront:imageButton];
}

- (void)imageTapped:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
																													 delegate: self 
																									cancelButtonTitle: @"Cancel" 
																						 destructiveButtonTitle: NULL 
																									otherButtonTitles: @"Email Photo", @"Go Back", NULL];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;																							
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self emailPhoto];
			break;
		case 1:
			[self hidePreviewImage];
			if ([self.delegate respondsToSelector:@selector(previewClosed:)]) {
				[self.delegate previewClosed:self];
			}
			break;
		default:
			break;
	}
}

- (void)emailPhoto {
	if (![MFMailComposeViewController canSendMail]) {
		UIAlertView *cantMailAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh..."
																														message:@"Sorry, this device is not able to send e-mail" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[cantMailAlert show]; 
		[cantMailAlert release]; 
		return;
	}

	MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	
	NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
	[mailController addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"image"];
	
	NSString *emailBody = @"";
	NSString *emailSubject = @"";
	[mailController setMessageBody:emailBody isHTML:NO];	
	[mailController setSubject:emailSubject];
	mailController.mailComposeDelegate = self;
	[self presentModalViewController:mailController animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)hidePreviewImage {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [UIView setAnimationDuration:0.66f];
  imageButton.alpha = 0.0f;	
  [UIView commitAnimations];	
}

- (UIImage*)generateThumbnail:(UIImage*)source {
	CGRect scaledRect = CGRectZero;
	scaledRect.size.width  = THUMBNAIL_WIDTH;
	scaledRect.size.height = THUMBNAIL_HEIGHT;
	scaledRect.origin = CGPointMake(THUMBNAIL_FRAME_OFFSET_X, THUMBNAIL_FRAME_OFFSET_Y);
	CGSize targetSize = CGSizeMake(THUMBNAIL_FRAME_WIDTH, THUMBNAIL_FRAME_HEIGHT);	
	
	UIGraphicsBeginImageContext(targetSize);
	[source drawInRect:scaledRect];
	
	// draw a simple thumbnail border
	CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.07f); 
  CGContextStrokeRectWithWidth(context, scaledRect, 5.0f);	
	
	UIImage* thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	return thumbnailImage;
}

- (void)showThumbnail:(UIImage *)newImage {
	[thumbnailButton setImage:newImage forState:UIControlStateNormal];
	thumbnailButton.alpha = 0.0f;
	thumbnailButton.hidden = NO;	

  CGAffineTransform preTransform = CGAffineTransformMakeScale(0.1f, 0.1f);
  thumbnailButton.transform = preTransform;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

  [UIView setAnimationDuration:0.3f];
  thumbnailButton.alpha = 1.0f;
	
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
  thumbnailButton.transform = transform;
	
  [UIView commitAnimations];	
}

- (void)generateAndShowThumbnail:(UIImage*)newImage {
	if (newImage != nil && newImage != self.image) {
		self.image = newImage;
		[imageButton setImage:newImage forState:UIControlStateNormal];
	}

	UIImage *thumb = [self generateThumbnail:self.image];
	[self showThumbnail:thumb];
}

- (void)hideThumbnail {
	if (thumbnailButton.hidden || thumbnailButton.alpha == 0.0f) return;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

  [UIView setAnimationDuration:0.3f];
  thumbnailButton.alpha = 0.0f;
	
	CGAffineTransform transform = CGAffineTransformMakeScale(0.01f, 0.01f);
  thumbnailButton.transform = transform;

  [UIView commitAnimations];	
}

- (void)hideThumbnailAfterDelay:(CGFloat)delay {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(hideThumbnail) withObject:self afterDelay:delay];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[image release];
	[imageButton release];
	[thumbnailButton release];
	[delegate release];
	[super dealloc];
}


@end
#endif