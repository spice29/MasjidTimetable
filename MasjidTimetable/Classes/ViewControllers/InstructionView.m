//
//  InstructionView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "InstructionView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "TableViewCell.h"
#import "InstructionDetailView.h"
#import "AppDelegate.h"

@interface InstructionView ()
{
    NSArray *content,*title;
    NSArray *jsonDict;
    UITableViewCell *cells;
    UIImageView *image;
}
@end

@implementation InstructionView

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"          Instructions";
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [self getInstructions];
    self.tableview.layer.cornerRadius=4.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)//(cim == nil && cgref == NULL)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    }
    else
    {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
    [super viewWillAppear:animated];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getInstructions
{
    [SVProgressHUD showWithStatus:@"Fetching Resuts..."];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/instructionpages.php" parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                jsonDict = (NSArray *) responseObjct;
                [SVProgressHUD dismiss];
                title=[jsonDict valueForKey:@"page_title"];
                [self.tableview reloadData];
             }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [SVProgressHUD dismiss];
    }];
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [title count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple = @"SimpleTableItem";
    
    TableViewCell *cell = (TableViewCell *)[tableViews dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.arrow.frame=CGRectMake(cell.arrow.frame.origin.x+5, cell.arrow.frame.origin.y-10, cell.arrow.frame.size.width, cell.arrow.frame.size.height);
    cell.LearningText.frame=CGRectMake(cell.LearningText.frame.origin.x, cell.LearningText.frame.origin.y-6, cell.LearningText.frame.size.width, cell.LearningText.frame.size.height);
    cell.masjidName.hidden=YES;
    cell.country.hidden=YES;
    cell.localName.hidden=YES;
    cell.l1.hidden=YES;
    cell.l2.hidden=YES;
    cell.LearningText.text=[title objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0) {}
    else {
        cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bck.png"]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        NSArray*getInstructions=[jsonDict objectAtIndex:indexPath.row];
        NSString *getTitle=[getInstructions valueForKey:@"page_title"];
        NSString *getContent=[getInstructions valueForKey:@"content"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:getTitle forKey:@"title"];
        [defaults setObject:getContent forKey:@"detail"];
        [defaults synchronize];
        
        InstructionDetailView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
        [self.navigationController pushViewController:ttView animated:YES];
    }
    else
    {
        NSArray*getInstructions=[jsonDict objectAtIndex:indexPath.row];
        NSString *getTitle=[getInstructions valueForKey:@"page_title"];
        NSString *getContent=[getInstructions valueForKey:@"content"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:getTitle forKey:@"title"];
        [defaults setObject:getContent forKey:@"detail"];
        [defaults synchronize];
        
        InstructionDetailView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
        [self.navigationController pushViewController:ttView animated:YES];
    }
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
