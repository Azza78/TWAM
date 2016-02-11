//
//  SavedPostView.h
//  TWAM
//
//  Created by Aron Calo on 2016/02/02.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import <UIKit/UIKit.h>

int counterSP;

@interface SavedPostView : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
