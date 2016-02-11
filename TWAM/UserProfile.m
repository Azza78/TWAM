//
//  UserProfile.m
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import "UserProfile.h"

#define kLatestFeedURL [NSURL URLWithString:@"http://feeds.soundcloud.com/users/soundcloud:users:62921190/sounds.rss"]

@interface UserProfile (){
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;

    bool *canConnect;
}

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *biography;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property NSMutableArray *objects;

@end

@implementation UserProfile


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.spinner.hidden = NO;
  //  [_spinner startAnimating];
    
    /*
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getLatestFeed) forControlEvents:UIControlEventValueChanged];
    */
    
    //Allocates and initialises login button
    
    _loginButton = [[FBSDKLoginButton alloc] init];
    
     [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    //Sets user profile picture using Facebook profile
    
    self.profilePictureView.profileID = @"me";
    
    [self getFacebookProfileInfo];
    
 
}
- (IBAction)loginButton:(id)sender {
    
    //Logs the user in with Facebook
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [self getFacebookProfileInfo];
    
    [login logInWithReadPermissions:@[@"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location , friends ,hometown , friendlists"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error)
        {
            
            // There is an error here.
            
        }
        else
        {
            if(result.token)   // This means if There is current access token.
            {
                // Token created successfully and you are ready to get profile info
                [self getFacebookProfileInfo];
            }        
        }
    }];
    
}

-(void)profileUpdated:(NSNotification *) notification{
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
   
}

- (void) loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
  
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

-(void)getFacebookProfileInfo {
    
    //Fetches and displays Facebook profile info
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    self.profilePictureView.profileID = @"me";
    
       FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters: @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location , friends ,hometown , friendlists"}];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            if ([result objectForKey:@"email"]) {
                
                NSLog(@"Email: %@",[result objectForKey:@"email"]);
                _biography.text = [result objectForKey:@"email"];
                
            }
            if ([result objectForKey:@"first_name"] && [result objectForKey:@"last_name"]) {
                
                NSLog(@"First Name : %@",[result objectForKey:@"first_name"]);
                NSString *fullName = [NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                _name.text = fullName;
                
            }
            if ([result objectForKey:@"id"]) {
                
                NSLog(@"User id : %@",[result objectForKey:@"id"]);
                
            }
            
            
        }
        
    }];
    
    [connection start];
}


- (IBAction)play:(id)sender {
}
- (IBAction)deleteItem:(id)sender {
}
/*
- (void)getLatestFeed
{
    
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString: @"http://feeds.soundcloud.com/users/soundcloud:users:62921190/sounds.rss"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    self.spinner.hidden = YES;
    [_spinner stopAnimating];
    
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}

*/

- (BOOL)prefersStatusBarHidden {
    return YES;
}



-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
    
}

/*
-(void)viewDidAppear:(BOOL)animated {
    
    
    [self getLatestFeed];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
        
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}




#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    
    messageLabel.text = @"Loading feed... (If feed does not appear, check your connection and reload the page)";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Arial-Bold" size:20];
    messageLabel.textColor =  [UIColor whiteColor];
    
    [messageLabel sizeToFit];
    
    self.tableView.backgroundView = messageLabel;
    
    
    
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    /*
     NSURL *imageURL = [NSURL URLWithString: @"http://feeds.soundcloud.com/users/soundcloud:users:62921190/sounds.rss"];
     
     //get a dispatch queue
     dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     //this will start the image loading in bg
     dispatch_async(concurrentQueue, ^{
     NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
     
     //this will set the image when loading is finished
     dispatch_async(dispatch_get_main_queue(), ^{
     thumbnail.image = [UIImage imageWithData:image];
     });
     });
     
 
    return cell;
    
    
}
*/
@end
