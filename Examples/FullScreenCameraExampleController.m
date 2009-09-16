//
//  FullScreenCameraExampleController.m
//  HelpfulUtilities
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import "FullScreenCameraExampleController.h"

// horizontal onSwipe
#define HORIZ_SWIPE_DRAG_MIN 180
#define VERT_SWIPE_DRAG_MAX 100

// vertical onSwipe
#define HORIZ_SWIPE_DRAG_MAX 100
#define VERT_SWIPE_DRAG_MIN 250


@implementation FullScreenCameraExampleController

@synthesize camera, cameraMode, overlayView, overlayLabel, startTouchPosition;


- (void)loadView {  
  self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  self.overlayView.backgroundColor = [UIColor clearColor];
  self.overlayView.opaque = NO;
  self.overlayView.alpha = 0.5f;
  
  self.overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  self.overlayLabel.text = @"Starting camera...";
  self.overlayLabel.textAlignment = UITextAlignmentCenter;
  self.overlayLabel.adjustsFontSizeToFitWidth = YES;
  self.overlayLabel.textColor = [UIColor redColor];
  self.overlayLabel.shadowOffset = CGSizeMake(0, -1);  
  self.overlayLabel.shadowColor = [UIColor blackColor];  
  [self.overlayView addSubview:self.overlayLabel];
  
  self.view = self.overlayView;
}

- (void) viewDidAppear:(BOOL)animated { 
  [self initCamera];
  [self startCamera];
	self.overlayLabel.text = @"Tap to take a picture.";
}

- (void) initCamera {  
  if ([BTLFullScreenCameraController isAvailable]) {  
    NSLog(@"Initializing camera.");
    BTLFullScreenCameraController *tmpCamera = [[BTLFullScreenCameraController alloc] init];
    self.camera = tmpCamera;
    [tmpCamera release];
    [self.camera.view setBackgroundColor:[UIColor blueColor]];
    [self.camera setCameraOverlayView:self.overlayView];
  } else {
    NSLog(@"Camera not available.");
  }
}

- (void)startCamera {
	// TODO: figure out why simply setting the view is not working
	// since the modal view is not as desirable
	
	// This isn't working but should:
	//self.view = self.camera.view;
	
	// Modal view always works, but it's harder to work with.
  [self.camera displayModalWithController:self animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // if landscape, put in camera mode
  switch (interfaceOrientation) {
    case UIInterfaceOrientationLandscapeLeft: 
    case UIInterfaceOrientationLandscapeRight: 
      [self toggleAugmentedReality];
      break;
  }
  
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)toggleAugmentedReality {
  if ([BTLFullScreenCameraController isAvailable]) {  
    self.cameraMode = !self.cameraMode;
    if (self.cameraMode == YES) {
      NSLog(@"Setting view to camera");
      if (!self.camera) { [self initCamera]; }
      
      [self startCamera];
      
    } else {
      NSLog(@"Setting view to overlay");
      // TODO: figure out why the non-modal camera view is not working
      //self.view = self.overlayView;      
      [self.camera dismissModalViewControllerAnimated:YES];
      self.camera = nil;
    }    

    [self.overlayView becomeFirstResponder];
  } else {
    NSLog(@"Unable to activate camera");
  }
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

#pragma mark 
#pragma mark Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];
	self.startTouchPosition = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
  
  if ([touch tapCount] == 1) {
		[self onSingleTap:touch];
	} else if ([touch tapCount] == 2) {
		[self onDoubleTap:touch];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.view];
  
	// If the onSwipe tracks correctly.
	if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
			fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		if (startTouchPosition.x < currentTouchPosition.x) {
			[self onSwipeRight];
		} else {
			[self onSwipeLeft];
		}
		self.startTouchPosition = currentTouchPosition;
    
	} else if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= VERT_SWIPE_DRAG_MIN &&
             fabsf(startTouchPosition.x - currentTouchPosition.x) <= HORIZ_SWIPE_DRAG_MAX)
  {
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		if (startTouchPosition.y < currentTouchPosition.y) {
			[self onSwipeDown];
		} else {
			[self onSwipeUp];
		}
		self.startTouchPosition = currentTouchPosition;  

  } else {
		// Process a non-swipe event.
	}
}

-(void)onSingleTap:(UITouch*)touch {
	NSLog(@"onSingleTap");
	[camera takePicture];
}

-(void)onDoubleTap:(UITouch*)touch {
	NSLog(@"onDoubleTap");
}

- (void)onSwipeUp {
	NSLog(@"onSwipeUp");
}

- (void)onSwipeDown {
	NSLog(@"onSwipeDown");
}

- (void)onSwipeLeft {
	NSLog(@"onSwipeLeft");
}

- (void)onSwipeRight {
	NSLog(@"onSwipeRight");
}


- (void)dealloc {
  [overlayView release];
  [overlayLabel release];
  [camera release];
  [super dealloc];
}


@end
