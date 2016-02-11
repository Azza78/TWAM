//
//  UserProfile.h
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserProfile : UIViewController <NSXMLParserDelegate, FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *profilePictureView;

//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end
