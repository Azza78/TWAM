//
//  ListenHistory.m
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import "ListenHistory.h"
#import "OtherPersonProfile.h"


@interface ListenHistory (){
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    
    IBOutlet UIImageView *thumbnail;
}

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property NSMutableArray *objects;
@end

@implementation ListenHistory


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.spinner.hidden = NO;
    [_spinner startAnimating];
    
    
}

- (IBAction)saveItem:(id)sender {
  /*
    NSLog (@"Item Saved");
    counterLH-= 1;
    // [countLabel setText:[NSString stringWithFormat:@"%d", counterLH]];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:counterLH forKey:@"counter"];
    [userDefaults synchronize];
    
    
   NSString *item = [[NSUserDefaults standardUserDefaults]
   stringForKey:@"item0"];
   
   NSString *itemName = item;
   
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
                                                    message:@"Press OK"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
   
   */

}
- (IBAction)playItem:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString: @"http://feeds.soundcloud.com/users/soundcloud:users:62921190/sounds.rss"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    self.spinner.hidden = YES;
    [_spinner stopAnimating];
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



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        [[segue destinationViewController] setUrl:string];
        
    }
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
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
    
    return nil;
}
@end
