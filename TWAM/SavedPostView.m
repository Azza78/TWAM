//
//  SavedPostView.m
//  TWAM
//
//  Created by Aron Calo on 2016/02/02.
//  Copyright © 2016 Aron Calo. All rights reserved.
//

#import "SavedPostView.h"

@interface SavedPostView ()
@property (strong, nonatomic) IBOutlet UILabel *itemOne;
@property (weak, nonatomic) IBOutlet UILabel *itemTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemThree;
@property (strong, nonatomic) IBOutlet UILabel *itemFour;
@property (weak, nonatomic) IBOutlet UILabel *itemFive;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellOne;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTwo;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellThree;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFour;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFive;



@property (strong, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation SavedPostView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    counterSP = [[NSUserDefaults standardUserDefaults] integerForKey:@"counter"];
    
    if (counterSP >= 5){
        //Disables editing if no posts have been saved
        _editButton.userInteractionEnabled = NO;
        _editButton.alpha = 0.5;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Schedule empty"
                                                        message:@"Please add items"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //Retrieves and displays saved items from User Defaults
    
    NSString *itemOneName = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"item1"];
    
    NSString *itemTwoName = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"item2"];
    
    NSString *itemThreeName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"item3"];
    
    NSString *itemFourName = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"item4"];
    
    NSString *itemFiveName = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"item5"];
    
    
    [self.itemOne setText:itemOneName];
    [self.itemTwo setText:itemTwoName];
    [self.itemThree setText:itemThreeName];
    [self.itemFour setText:itemFourName];
    [self.itemFive setText:itemFiveName ];
    
    
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    
}

- (IBAction)editButton:(id)sender {
    
    //Removes item from Table View
    
    if (  [self.tableView isEditing]) {
        
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView endEditing:YES];
        [self.tableView setEditing:NO animated:YES];
        
        
    }
    
    else {
        
        [_editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
        
        
    }
    
    
}

-(void)reloadData{
    
    NSString *itemOneName = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"item1"];
    
    NSString *itemTwoName = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"item2"];
    
    NSString *itemThreeName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"item3"];
    
    NSString *itemFourName = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"item4"];
    
    NSString *itemFiveName = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"item5"];
    
  
    
    [self.itemOne setText:itemOneName];
    [self.itemTwo setText:itemTwoName];
    [self.itemThree setText:itemThreeName];
    [self.itemFour setText:itemFourName];
    [self.itemFive setText:itemFiveName ];
    
}

- (IBAction)backButton:(id)sender {
    [self performSegueWithIdentifier:@"menu" sender:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //Even if the method is empty you should be seeing both rearrangement icon and animation.
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //When item id deleted, counter is increased and cell is reset
        counterSP+= 1;
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:counterSP forKey:@"counter"];
        [userDefaults synchronize];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *reset = @" ";
        
        if (cell == _cellOne) {
            [[NSUserDefaults standardUserDefaults] setObject:reset forKey:@"item1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        else if (cell == _cellTwo) {
            [[NSUserDefaults standardUserDefaults] setObject:reset forKey:@"item2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        else if (cell == _cellThree) {
            [[NSUserDefaults standardUserDefaults] setObject:reset forKey:@"item3"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        else if (cell == _cellFour) {
            [[NSUserDefaults standardUserDefaults] setObject:reset forKey:@"item4"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        else if (cell == _cellFive) {
            [[NSUserDefaults standardUserDefaults] setObject:reset forKey:@"item5"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        
        [self reloadData];
        
        
        
        if (counterSP >= 5){
            
            _editButton.userInteractionEnabled = NO;
            _editButton.alpha = 0.5;
            
            [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
            [self.tableView endEditing:YES];
            [self.tableView setEditing:NO animated:YES];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Schedule empty"
                                                            message:@"Please add items from Whats On"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView endEditing:YES];
        [self.tableView setEditing:NO animated:YES];
        
    }
}

@end
