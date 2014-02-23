//
//  BBSetCategoryViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 2/22/14.
//  Copyright (c) 2014 Equippd Software. All rights reserved.
//

#import "BBSetCategoryViewController.h"

#define kCategoryCellHeight 60
#define kCategoryNum 11

#define kCellItemImageTag 100
#define kCellItemTextTag 101
#define kCellItemDescTag 102

@interface BBSetCategoryViewController ()

@end

@implementation BBSetCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kCategoryNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categoryTableCell";
    UITableViewCell *cell; // = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BillCategory_E category = (BillCategory_E)indexPath.row;
    
    // Configure the cell...
    if (cell == nil) {
        UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 40, 40)];
        itemImage.tag = kCellItemImageTag;
        itemImage.backgroundColor = [BBMethodStore billCategoryColor:category];

        UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, 30, 30)];
        itemText.tag = kCellItemTextTag;
        itemText.font = [UIFont fontWithName:[VAR_STORE navBarDefaultFontName] size:20];
        itemText.text = [BBMethodStore billCategoryShortText:category];
        itemText.textColor = [UIColor colorWithWhite:1 alpha:1];
        itemText.adjustsFontSizeToFitWidth = YES;
        
        UILabel *itemDescText = [[UILabel alloc] initWithFrame:CGRectMake(66, 15, 200, 28)];
        itemDescText.tag = kCellItemDescTag;
        itemDescText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:16];;
        itemDescText.text = [BBMethodStore billCategoryLongText:category];

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView addSubview:itemImage];
        [cell.contentView addSubview:itemText];
        [cell.contentView addSubview:itemDescText];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCategoryCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"tableView:didSelectRowAtIndexPath called")
    BillRecord *record = [VAR_STORE pendingBillRecord];
    BillCategory_E category = (BillCategory_E)indexPath.row;
    record.category = [[NSNumber alloc] initWithInteger:(NSUInteger)category];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
