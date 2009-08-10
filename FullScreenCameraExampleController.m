//
//  FullScreenCameraExampleController.m
//  HelpfulUtilities
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import "FullScreenCameraExampleController.h"


@implementation FullScreenCameraExampleController

@synthesize camera, cameraMode, overlayView;


- (void)loadView {  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  label.text = @"This is the overlay.";
  label.textAlignment = UITextAlignmentCenter;
  label.adjustsFontSizeToFitWidth = YES;
  label.textColor = [UIColor redColor];
  label.shadowOffset = CGSizeMake(0, -1);  
  label.shadowColor = [UIColor blackColor];
  
  self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  self.overlayView.backgroundColor = [UIColor clearColor];
  self.overlayView.clipsToBounds = YES;
  self.overlayView.opaque = NO;
  self.overlayView.alpha = 0.5f;  
  [self.overlayView addSubview:label];
  [label release];

  self.view = self.overlayView;
}

- (void) viewDidAppear:(BOOL)animated { 
  [self initCamera];
  [self.camera displayModalWithController:self animated:YES];
}

- (void) initCamera {  
  if ([FullScreenCameraController isAvailable]) {  
    NSLog(@"Initializing camera.");
    FullScreenCameraController *tmpCamera = [[FullScreenCameraController alloc] init];
    self.camera = tmpCamera;
    [tmpCamera release];
    [self.camera.view setBackgroundColor:[UIColor blueColor]];
    [self.camera setCameraOverlayView:self.overlayView];
  } else {
    NSLog(@"Camera not available.");
  }
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
  if ([FullScreenCameraController isAvailable]) {  
    self.cameraMode = !self.cameraMode;
    if (self.cameraMode == YES) {
      NSLog(@"Setting view to camera");
      if (!self.camera) { [self initCamera]; }
      
      // TODO: figure out why simply setting the view is not working
      //self.view = self.camera.view;
      [self.camera displayModalWithController:self animated:YES];
      
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

- (void)dealloc {
  [overlayView release];
  [camera release];
  [super dealloc];
}


@end
