//
//  BBCurrencyViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 5/3/14.
//  Copyright (c) 2014 Equippd Software. All rights reserved.
//

#import "BBCurrencyViewController.h"

@interface BBCurrencyViewController ()

@property (nonatomic, strong) NSMutableDictionary *currencyDictionary;
@property (nonatomic, strong) NSArray *currencyArray;

@end

@implementation BBCurrencyViewController

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
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"CurrencyList" ofType:@"plist"];
    self.currencyDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:sourcePath];
    self.currencyArray = [[self.currencyDictionary allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
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
    return [self.currencyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSString *name = [[self.currencyDictionary valueForKey:[self.currencyArray objectAtIndex:indexPath.row]] objectAtIndex:3];

    UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, 300, 30)];
    itemText.tag = 100;
    itemText.font = [UIFont fontWithName:[VAR_STORE navBarDefaultFontName] size:14];
    itemText.text = name;
    itemText.adjustsFontSizeToFitWidth = YES;
        
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currencyCell"];
    [cell.contentView addSubview:itemText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"tableView:didSelectRowAtIndexPath called")
    NSString *symbol = [[self.currencyDictionary valueForKey:[self.currencyArray objectAtIndex:indexPath.row]] objectAtIndex:1];
    NSString *code = [[self.currencyDictionary valueForKey:[self.currencyArray objectAtIndex:indexPath.row]] objectAtIndex:2];
    [SETTINGS setObject:symbol forKey:@"currencySymbol"];
    [SETTINGS setObject:code forKey:@"currencyCode"];
    (VAR_STORE).currencySymbol = symbol;
    [SETTINGS synchronize];

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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
