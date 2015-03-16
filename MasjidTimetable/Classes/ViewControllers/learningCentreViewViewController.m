//
//  learningCentreViewViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "learningCentreViewViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "TableViewCell.h"
#import "InstructionDetailView.h"
#import "AppDelegate.h"

@interface learningCentreViewViewController ()
{
    NSArray *results;
    BOOL isSearching;
    NSMutableArray *jsonDict,*filteredTitles,*getData,*jsonData;
    UIImageView *image;
    NSMutableString *searchedString;
}
@end

@implementation learningCentreViewViewController

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
    jsonData=[[NSMutableArray alloc]init];
    filteredTitles=[[NSMutableArray alloc]init];
    getData=[[NSMutableArray alloc]init];
    self.title=@"   Topics & Articles";
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    searchedString=[[NSMutableString alloc]initWithString:@""];
    self.tableView.layer.cornerRadius=7.0f;
    self.tableView.clipsToBounds=YES;
    [self getArticles];
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

-(void)getArticles
{
    [SVProgressHUD showWithStatus:@"Fetching Resuts..."];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/custompages.php" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                            jsonData = (NSMutableArray *) responseObjct;
                            [SVProgressHUD dismiss];
                            getData=[jsonData valueForKey:@"page_title"];
                            [self.tableView reloadData];
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
      return isSearching ? filteredTitles.count : getData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
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
    
    NSString *val1 = isSearching? filteredTitles[indexPath.row]:getData[indexPath.row];
    cell.LearningText.text=val1;
   
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0) {}
    else
        cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bck.png"]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        InstructionDetailView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
        [self.navigationController pushViewController:ttView animated:YES];
    }
    else
    {
        InstructionDetailView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
        [self.navigationController pushViewController:ttView animated:YES];
    }
}

- (IBAction)cancelClicked
{
    [self.writeText resignFirstResponder];
    isSearching=NO;
    jsonData = [[NSMutableArray alloc] initWithArray:jsonData];
    getData=[jsonData valueForKey:@"page_title"];
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField.text length] == 0){
        
        jsonData = [[NSMutableArray alloc] initWithArray:jsonData];
        getData=[jsonData valueForKey:@"page_title"];
        [searchedString setString:@""];
        [self.tableView reloadData];
    }
    else {
        if (textField.text !=nil) {
            if ([textField.text isEqualToString:@""]){
                NSRange range = NSMakeRange([searchedString length]-1,1);
                [searchedString replaceCharactersInRange:range withString:@""];
            }
            else
                [searchedString appendFormat:@"%@",textField.text];
            if ([searchedString isEqualToString:@""]) {
                isSearching=NO;
                jsonData = [[NSMutableArray alloc] initWithArray:jsonData];
                getData=[jsonData valueForKey:@"page_title"];
                [self.tableView reloadData];
            }
            else
            {
                isSearching= YES;
                NSString *nonMutableString=[NSString stringWithString:searchedString];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"page_title CONTAINS[cd] %@",nonMutableString];
                results = [jsonData filteredArrayUsingPredicate:predicate];
                filteredTitles = [results valueForKey:@"page_title"];
                [self.tableView reloadData];
            }
        }
    }
    [self.writeText resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.cancel.hidden=NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string !=nil) {
        if ([string isEqualToString:@""]){
            NSRange range = NSMakeRange([searchedString length]-1,1);
            [searchedString replaceCharactersInRange:range withString:@""];
        }
        else
            [searchedString appendFormat:@"%@",string];
        
        if ([searchedString isEqualToString:@""]) {
             isSearching=NO;
            jsonData = [[NSMutableArray alloc] initWithArray:jsonData];
            getData=[jsonData valueForKey:@"page_title"];
            [self.tableView reloadData];
        }
        else
        {
            isSearching= YES;
            NSString *nonMutableString=[NSString stringWithString:searchedString];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"page_title CONTAINS[cd] %@",nonMutableString];
            results = [jsonData filteredArrayUsingPredicate:predicate];
            filteredTitles = [results valueForKey:@"page_title"];
            [self.tableView reloadData];
        }
    }
    
    return YES;
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
