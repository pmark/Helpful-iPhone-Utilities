//
//  HelpfulUtilitiesAppDelegate.h
//  HelpfulUtilities
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

@interface HelpfulUtilitiesAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

