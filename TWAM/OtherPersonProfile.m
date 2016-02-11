//
//  OtherPersonProfile.m
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import "OtherPersonProfile.h"

@interface OtherPersonProfile (){
    
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    
    IBOutlet UIImageView *thumbnail;
}

@property (strong, nonatomic) IBOutlet UITextView *biography;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property NSMutableArray *objects;
@end

@implementation OtherPersonProfile


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.spinner.hidden = NO;
    [_spinner startAnimating];

}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
}

- (IBAction)favouriteAction:(id)sender {
}

-(void)viewDidAppear:(BOOL)animated {
    
    
    [self configureView];
    NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];

    
    
    feeds = [[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:myURL];
    
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


- (IBAction)saveItem:(id)sender {
/*
    NSLog (@"Item Saved");
    counterOP-= 1;
    // [countLabel setText:[NSString stringWithFormat:@"%d", counterOP]];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:counterOP forKey:@"counter"];
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
 }UserDefaults] synchronize];
}
 */
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
    
   
    
    return nil;
}


@end
