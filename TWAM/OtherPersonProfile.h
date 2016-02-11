//
//  OtherPersonProfile.h
//  TWAM
//
//  Created by Aron Calo on 2016/02/01.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherPersonProfile : UIViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id detailItem;

@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
