//
//  FindView.m
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import "FindView.h"

@interface FindView ()
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *connectFacebook;

@end

@implementation FindView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Allocates and initialises Facebook SDK Login button
    
    _connectFacebook = [[FBSDKLoginButton alloc] init];
    
    //Updates Facebook info shown on app
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectFacebook:(id)sender {
    
    //When tapped, user is logged in with Facebook
}

- (IBAction)searchField:(id)sender {
}

- (IBAction)connectInstagram:(id)sender {
}
- (IBAction)connectGoogle:(id)sender {
}
- (IBAction)connectRally:(id)sender {
}
- (IBAction)connectOther:(id)sender {
}

@end
