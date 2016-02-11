//
//  MainView.h
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

int counter;
BOOL isLoggedIn;
BOOL isPlaying;
BOOL isSaved;

@interface MainView : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end
