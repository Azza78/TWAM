//
//  MainView.m
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import "MainView.h"
#import "OtherPersonProfile.h"

#define kLatestFeedURL [NSURL URLWithString:@"http://feeds.soundcloud.com/users/soundcloud:users:62921190/sounds.rss"]

@interface MainView (){
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    
    IBOutlet UIImageView *thumbnail;
    
    
    
    bool *canConnect;
}

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property NSMutableArray *objects;
@end

@implementation MainView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.spinner.hidden = NO;
    [_spinner startAnimating];
    
    
    //Checks if user is logged in. User can only access features if logged in. If not logged in, user is taken to login page.
    BOOL isLoggedIn = NO;
    if ([FBSDKAccessToken currentAccessToken]) {
        isLoggedIn = YES;
        NSLog(@"facebook already connected");
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Login"
                                                        message:@"Please login to your Facebook profile"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"userProfile" sender:self];
    }
    
    
    
    //This is for tracking the number of favourited posts. Maximum of five favourited posts allowed for the time being.
    
    counter = [[NSUserDefaults standardUserDefaults] integerForKey:@"counter"];
   // [countLabel setText:[NSString stringWithFormat:@"%d", counter]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
        // On first launch, this block will execute
        
        counter = 5;
    //    _countLabel.text = [NSString stringWithFormat:@"%ld", (long)counter];
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPerformedFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getLatestFeed) forControlEvents:UIControlEventValueChanged];
    
    
}


- (IBAction)play:(id)sender {
    
    //Fetches the link of the RSS item and displays result in a mini web-view. If pressed again, web view is removed and sound playback discontinued.
    
    if (isPlaying == YES) {
    
    [[self.view viewWithTag:55] removeFromSuperview];
    isPlaying = NO;
        
    }
    
    else if (isPlaying == NO) {
        
    isPlaying = YES;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
    
    NSURL *myURL = [NSURL URLWithString: [string stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, 300, 550, 200)];
    webView.tag=55;
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [webView loadRequest:request];
    [[self view] addSubview:webView];
        
    }
    
}

- (IBAction)saveItem:(id)sender {
    
     //Saves/Unsave RSS item to User Defaults. Code commented out as only works for one cell at a time for the time being.
    /*
    if (isSaved == YES) {
        
        NSLog (@"Item Removed");
        counter+= 1;
        // [countLabel setText:[NSString stringWithFormat:@"%d", counter]];
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:counter forKey:@"counter"];
        [userDefaults synchronize];
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *delete = @"";
        
        
        if (counter == 5) {
            [[NSUserDefaults standardUserDefaults] setObject:delete forKey:@"item1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 4) {
            [[NSUserDefaults standardUserDefaults] setObject:delete forKey:@"item2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 3) {
            [[NSUserDefaults standardUserDefaults] setObject:delete forKey:@"item3"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 2) {
            [[NSUserDefaults standardUserDefaults] setObject:delete forKey:@"item4"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:delete forKey:@"item5"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Removed from favourites"
                                                        message:@"OK"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        isSaved = NO;
        
    }
    
    else if (isSaved == NO) {
     
        isSaved = YES;
       */
        NSLog (@"Item Saved");
        counter-= 1;
        // [countLabel setText:[NSString stringWithFormat:@"%d", counter]];
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:counter forKey:@"counter"];
        [userDefaults synchronize];
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *itemName = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
        
        
        if (counter == 5) {
            [[NSUserDefaults standardUserDefaults] setObject:itemName forKey:@"item1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 4) {
            [[NSUserDefaults standardUserDefaults] setObject:itemName forKey:@"item2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 3) {
            [[NSUserDefaults standardUserDefaults] setObject:itemName forKey:@"item3"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 2) {
            [[NSUserDefaults standardUserDefaults] setObject:itemName forKey:@"item4"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else if (counter == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:itemName forKey:@"item5"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Saved"
                                                        message:@"OK"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
  //  }
  

}


- (void)getLatestFeed
{
    
    //Fetches RSS feed from url
    
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

-(void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        
        [self.refreshControl endRefreshing];
    }
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}



-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    
    [self getLatestFeed];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    //Downloads thumbnail associated with RSS item
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
    
    //Parses RSS feed and fetches required elements (RSS item, Title of RSS item and link pointed to by RSS item)
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    //Displays parsed items in Tableview cell
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



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        //When TableView cell is tapped, user is taken to webview by RSS item url
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        [[segue destinationViewController] setUrl:string];
        
        NSString *itemName = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
        
        [[NSUserDefaults standardUserDefaults] setObject:itemName forKey:@"item0"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
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
    
    //Gets and sets cell thumbnail
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
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
- (IBAction)profileButton:(id)sender {
    
    [self performSegueWithIdentifier:@"userProfile" sender:self];
}

- (IBAction)recordButton:(id)sender {
    
     [self performSegueWithIdentifier:@"record" sender:self];
}
- (IBAction)savedButton:(id)sender {
    
     [self performSegueWithIdentifier:@"saved" sender:self];
}
- (IBAction)findButton:(id)sender {
    
     [self performSegueWithIdentifier:@"find" sender:self];
}

@end
