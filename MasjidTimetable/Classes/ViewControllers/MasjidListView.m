//
//  MasjidListView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MasjidListView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "MasjidDetailView.h"
#import "TimeTableView.h"
#import "MTDBHelper.h"
#import "MajidListCell.h"
#import "MasjidListTextField.h"

@interface MasjidListView ()
{
    NSArray *masjidNames,*localArea,*largerArea,*countryValue;
    NSMutableArray *masjid_values;
    NSArray *filterdMasjidName,*FilteredLocalArea,*FilteredCountry,*filteredLargerArea,*filteredMasjidID;
    NSMutableArray *jsonDict,*getIDValues;
    NSMutableArray *arrayOfCharacters;
    NSMutableArray *masjid_id,*masjid_address,*masjid_pin,*masjid_phn;
    NSMutableDictionary *objectsForCharacters,*pinObject,*phnObject,*addObject,*IdObject;
    NSInteger selectedCell;
    NSString *searchWithoutMasjid;
    NSArray *getP,*getIDs;
    NSMutableString *searchingString;
    NSMutableArray *a1,*a2,*a3,*a4;
    NSArray *results;
    NSMutableArray *arrayOfNames;
    NSString *numbericSection;
    NSString *firstLetter;
    NSMutableDictionary *objects,*largerObject,*CountryObject;
    NSMutableArray *getlocations,*MasjidLargerArea,*MasjidCountry;
    NSMutableArray *addCapitalData;
    int j,m,KeyAppearence;
    NSArray *alphabets;
    NSArray *masjids;
    int getLocale;
}

@end

@implementation MasjidListView

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.searchtextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navCenter.font =[UIFont fontWithName:@"Helvetica Bold" size:17.0];
        self.navRight.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:8.0];
        self.navLeft.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:8.0];
        self.searchtextField.font =[UIFont fontWithName:@"Helvetica" size:12.0];
        self.all.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13.0];
    }
    getLocale=0;
    xts=0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.crossBtn.hidden=NO;
    self.greenDot.hidden=YES;
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]]; //background
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    self.crossBtn.hidden=YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfIDs = [userDefaults objectForKey:@"idValues"];
    NSArray *arrayOfpriorities = [userDefaults objectForKey:@"priorityValues"];
    addids=[NSMutableArray arrayWithArray:arrayOfIDs];
    addpri=[NSMutableArray arrayWithArray:arrayOfpriorities];
    dictData=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"idWithPriorities"]];
    [self call];
    [self getData];
}

- (void) textFieldDidChange:(UITextField *) textField
{
    if ([textField.text isEqualToString:@""]) {
        masjids = [[MTDBHelper sharedDBHelper] getMasjids];
    } else {
        masjids = [[MTDBHelper sharedDBHelper] searchMasjids:textField.text];
    }
    [self.tableView reloadData];
}

-(void)call
{
    if ([dictData count]==2 || [dictData count]==3 ||[dictData count]==4)
    {
        getLocale=0;
        NSArray *sortedKeys2 = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSString *key2=[sortedKeys2 objectAtIndex:1];
        NSString *valueForkey2=[dictData valueForKey:key2];
        if ([key2 isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"secondKey"]]) {
            if (![valueForkey2 isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"secondValue"]]) {
                [self getTimeTable];
                [self getNotes];
                [self getDetailsOfTimeTable];
                [self getFormat];
                [self retrievePost2];
            }
        } else {
            [self getNotes];
            [self getTimeTable];
            [self getDetailsOfTimeTable];
            [self getFormat];
            [self retrievePost2];
        }
    }
}

-(void)getData
{
    for (j=0; j<[addpri count]; j++) {
        for (m=0;m<[masjidNames count];m++) {
            if ([[jsonDict valueForKey:@"masjid_id"]containsObject:addids[j]]) {
                
            }
        }
        NSUInteger val=[[jsonDict valueForKey:@"masjid_id"]indexOfObject:addids[j]];
        [get addObject:[NSString stringWithFormat:@"%lu",(unsigned long)val]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title= @"Select Masjid";
    KeyAppearence = 1;
    alphabets = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    a1 = [NSMutableArray array];
    a2 = [NSMutableArray array];
    a3 = [NSMutableArray array];
    a4 = [NSMutableArray array];
    addCapitalData = [NSMutableArray array];
    MasjidLargerArea = [NSMutableArray array];
    MasjidCountry = [NSMutableArray array];
    masjid_id = [NSMutableArray array];
    masjid_phn = [NSMutableArray array];
    masjid_pin = [NSMutableArray array];
    masjid_address = [NSMutableArray array];
    searchingString = [[NSMutableString alloc] initWithString:@""];
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    UIImage *buttonImage1 = [UIImage imageNamed:@"reload.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Reload" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width/2, buttonImage1.size.height/2);
    [button1 addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    self.tableView.layer.cornerRadius=3.0f;
    self.tableView.clipsToBounds=YES;
    
    //    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    //    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    //    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    //    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    //    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    //    txfSearchField.layer.cornerRadius = 50.0f;
    //    txfSearchField.clearButtonMode=UITextFieldViewModeAlways;
    [self retrievePost];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    //    dictData=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"idWithPriorities"]];
    //    if ([dictData count]==2 ||[dictData count]==2|| [dictData count]==3) {
    //        NSArray *sortedKeys2 = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //        NSString *key2=[sortedKeys2 objectAtIndex:1];
    //        NSString *valueForkey2=[dictData valueForKey:key2];
    //        [[NSUserDefaults standardUserDefaults]setValue:key2 forKey:@"secondKey"];
    //        [[NSUserDefaults standardUserDefaults]setValue:valueForkey2 forKey:@"secondValue"];
    //    }
    
    [self loadMasjids];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadData
{
    [self.searchtextField resignFirstResponder];
    self.searchImage.hidden=NO;
    self.crossBtn.hidden=YES;
    isSearching=NO;
    [searchingString setString:@""];
    self.searchtextField.text=@"";
    [self retrievePost];
    [self.tableView reloadData];
    KeyAppearence=1;
}

-(void)retrievePost
{
    masjid_values=[[NSMutableArray alloc]init];
    addCapitalData=[[NSMutableArray alloc]init];
    MasjidLargerArea=[[NSMutableArray alloc]init];
    MasjidCountry=[[NSMutableArray alloc]init];
    masjid_id=[[NSMutableArray alloc]init];
    masjid_phn=[[NSMutableArray alloc]init];
    masjid_pin=[[NSMutableArray alloc]init];
    masjid_address=[[NSMutableArray alloc]init];
    
    //    [SVProgressHUD show];
    //
    //    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    //    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    //
    //    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/masjids.php" parameters:nil];
    //
    //    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    //                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
    //                                                                                            jsonDict = (NSMutableArray *) responseObjct;
    //                                                                                            [SVProgressHUD dismiss];
    //                                                                                            [[MTDBHelper sharedDBHelper] saveMasjids:responseObjct];
    //
    //                                                                                            masjidNames=[jsonDict valueForKey:@"masjid_name"];
    //                                                                                            localArea=[jsonDict valueForKey:@"masjid_local_area"];
    //                                                                                            largerArea=[jsonDict valueForKey:@"masjid_larger_area"];
    //                                                                                            countryValue=[jsonDict valueForKey:@"masjid_country"];
    //
    //                                                                                            masjidNames = [masjidNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //                                                                                            for (int k=0;k<[masjidNames count];k++) {
    //                                                                                                if ([[jsonDict valueForKey:@"masjid_name"] containsObject:masjidNames[k]]) {
    //                                                                                                    NSInteger index= [[jsonDict valueForKey:@"masjid_name"]indexOfObject:masjidNames[k]];
    //                                                                                                    NSString *getId=[[jsonDict valueForKey:@"masjid_id"]objectAtIndex:index];
    //                                                                                                    [masjid_values addObject:getId];
    //                                                                                                }
    //                                                                                            }
    //                                                                                            for (NSString *item in masjidNames) {
    //                                                                                                NSString *newString = [item stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[item substringToIndex:1] capitalizedString]];
    //                                                                                                [addCapitalData addObject:newString];
    //                                                                                            }
    //                                                                                            [self setupIndexData];
    //                                                                                            [self getData];
    //                                                                                        }
    //                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //                                                                                            [SVProgressHUD dismiss];
    //                                                                                        }];
    //
    //    [operation start];
}

- (void) loadMasjids
{
    masjids = [[MTDBHelper sharedDBHelper] getMasjids];
    if (masjids == nil || [masjids count] == 0) {
        [SVProgressHUD show];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/masjids.php" parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                                [[MTDBHelper sharedDBHelper] addMasjids:responseObjct];
                                                                                                masjids = [[MTDBHelper sharedDBHelper] getMasjids];
                                                                                                [self.tableView reloadData];
                                                                                                [SVProgressHUD dismiss];
                                                                                            }
                                                                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                [SVProgressHUD dismiss];
                                                                                            }];
        [operation start];
    }
}

- (void) refreshMasjidsData
{
    [SVProgressHUD show];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/masjids.php" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            [[MTDBHelper sharedDBHelper] updateMasjids:responseObjct];
                                                                                            masjids = [[MTDBHelper sharedDBHelper] getMasjids];
                                                                                            [self.tableView reloadData];
                                                                                            [SVProgressHUD dismiss];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabets;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    BOOL found = NO;
    NSInteger b = 0;
    for (Masjid *obj in masjids)
    {
        if ([[[obj.name substringToIndex:1] uppercaseString] isEqualToString:title])
            if (!found)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:b inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                found = YES;
            }
        b++;
    }
    return b;
}


- (void)setupIndexData
{
    arrayOfCharacters    = [[NSMutableArray alloc] init];
    getIDValues=[[NSMutableArray alloc]init];
    objectsForCharacters = [[NSMutableDictionary alloc] init];
    objects=[[NSMutableDictionary alloc]init];
    largerObject=[[NSMutableDictionary alloc]init];
    CountryObject=[[NSMutableDictionary alloc]init];
    IdObject=[[NSMutableDictionary alloc]init];
    addObject=[[NSMutableDictionary alloc]init];
    pinObject=[[NSMutableDictionary alloc]init];
    phnObject=[[NSMutableDictionary alloc]init];
    getlocations=[[NSMutableArray alloc]init];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    arrayOfNames = [[NSMutableArray alloc] init];
    numbericSection    = @"#";
    for (int i=0;i<[addCapitalData count];i++) {
        NSString *masjidLocal,*MasjidlargerArea,*country,*address,*idValue,*postCode,*PhnNo;
        firstLetter = [[addCapitalData[i] description] substringToIndex:1];
        if([[jsonDict valueForKey:@"masjid_name"] containsObject:masjidNames[i]])
        {
            NSInteger index= [[jsonDict valueForKey:@"masjid_name"]indexOfObject:masjidNames[i]];
            masjidLocal=[[jsonDict valueForKey:@"masjid_local_area"]objectAtIndex:index];
            MasjidlargerArea=[[jsonDict valueForKey:@"masjid_larger_area"]objectAtIndex:index];
            country=[[jsonDict valueForKey:@"masjid_country"]objectAtIndex:index];
            idValue=[[jsonDict valueForKey:@"masjid_id"]objectAtIndex:index];
            address=[[jsonDict valueForKey:@"masjid_add_1"]objectAtIndex:index];
            postCode=[[jsonDict valueForKey:@"masjid_post_code"]objectAtIndex:index];
            PhnNo=[[jsonDict valueForKey:@"masjid_telephone"]objectAtIndex:index];
        }
        else
        {
        }
        if ([formatter numberFromString:firstLetter] == nil) {
            
            if (![objectsForCharacters objectForKey:firstLetter]) {
                [getlocations removeAllObjects];
                [arrayOfNames removeAllObjects];
                [MasjidCountry removeAllObjects];
                [MasjidLargerArea removeAllObjects];
                [masjid_address removeAllObjects];
                [masjid_id removeAllObjects];
                [masjid_phn removeAllObjects];
                [masjid_pin removeAllObjects];
                [arrayOfCharacters addObject:firstLetter];
            }
            [getlocations addObject:[masjidLocal description]];
            [MasjidLargerArea addObject:[MasjidlargerArea description]];
            [MasjidCountry addObject:[country description]];
            [arrayOfNames addObject:[addCapitalData[i] description]];
            [masjid_address addObject:address];
            [masjid_id addObject:idValue];
            [masjid_phn addObject:PhnNo];
            [masjid_pin addObject:postCode];
            [CountryObject setObject:[MasjidCountry copy] forKey:firstLetter];
            [largerObject setObject:[MasjidLargerArea copy] forKey:firstLetter];
            [objects setObject:[getlocations copy] forKey:firstLetter];
            [objectsForCharacters setObject:[arrayOfNames copy] forKey:firstLetter];
            [IdObject setObject:[masjid_id copy] forKey:firstLetter];
            [addObject setObject:[masjid_address copy] forKey:firstLetter];
            [pinObject setObject:[masjid_pin copy] forKey:firstLetter];
            [phnObject setObject:[masjid_phn copy] forKey:firstLetter];
        }
        else {
            
            if (![objectsForCharacters objectForKey:numbericSection]) {
                [arrayOfNames removeAllObjects];
                [arrayOfCharacters addObject:numbericSection];
            }
            [arrayOfNames addObject:[addCapitalData[i] description]];
            [objectsForCharacters setObject:[arrayOfNames copy]  forKey:numbericSection];
        }
    }
    isSearching=NO;
    [self.tableView reloadData];
}

-(void)letsCheck
{
    for (int k=0;k<[alphabets count];k++) {
        {
            for (int l=0;l<[addCapitalData count];l++) {
                if (![addCapitalData containsObject:alphabets[k]]) {
                    [getlocations removeAllObjects];
                    [arrayOfNames removeAllObjects];
                    [MasjidCountry removeAllObjects];
                    [MasjidLargerArea removeAllObjects];
                    [masjid_address removeAllObjects];
                    [masjid_id removeAllObjects];
                    [masjid_phn removeAllObjects];
                    [masjid_pin removeAllObjects];
                    
                    getlocations =[[NSMutableArray alloc]initWithArray:getlocations];
                    arrayOfNames =[[NSMutableArray alloc]initWithArray:arrayOfNames];
                    masjid_address =[[NSMutableArray alloc]initWithArray:masjid_address];
                    masjid_id =[[NSMutableArray alloc]initWithArray:masjid_id];
                    masjid_phn =[[NSMutableArray alloc]initWithArray:masjid_phn];
                    MasjidCountry =[[NSMutableArray alloc]initWithArray:MasjidCountry];
                    MasjidLargerArea =[[NSMutableArray alloc]initWithArray:MasjidLargerArea];
                    masjid_pin =[[NSMutableArray alloc]initWithArray:masjid_pin];
                    
                    [CountryObject setObject:[MasjidCountry copy] forKey:firstLetter];
                    [largerObject setObject:[MasjidLargerArea copy] forKey:firstLetter];
                    [objects setObject:[getlocations copy] forKey:firstLetter];
                    [objectsForCharacters setObject:[arrayOfNames copy] forKey:firstLetter];
                    [IdObject setObject:[masjid_id copy] forKey:firstLetter];
                    [addObject setObject:[masjid_address copy] forKey:firstLetter];
                    [pinObject setObject:[masjid_pin copy] forKey:firstLetter];
                    [phnObject setObject:[masjid_phn copy] forKey:firstLetter];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [masjids count];
    //    return isSearching ? filterdMasjidName.count : [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:section]] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MajidListCell *cell = (MajidListCell*)[tableViews dequeueReusableCellWithIdentifier:@"majidListCell" forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[MajidListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"majidListCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.cellBtn setTag:indexPath.row];
    [cell.cellBtn addTarget:self action:@selector(openDetailPage:) forControlEvents:UIControlEventTouchUpInside];
    Masjid *masjid = [masjids objectAtIndex:indexPath.row];
    
    //    NSString *val1 = isSearching? filterdMasjidName[indexPath.row] :[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    //    NSString *val= isSearching? FilteredLocalArea[indexPath.row] : [[objects objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    //    NSString *val2= isSearching? FilteredCountry[indexPath.row] : [[CountryObject objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    //    NSString *val3= isSearching? filteredLargerArea[indexPath.row] : [[largerObject objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = masjid.name;
    cell.localNameLabel.text = masjid.localArea;
    [cell.nameLabel setTextColor:[UIColor blackColor]];
    [cell.mainContentView setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height-1)];
    cell.cellBtn.frame = cell.mainContentView.frame;
    [cell.nameLabel setFrame:CGRectMake(8, 1, cell.mainContentView.frame.size.width - 20, 30)];
    [cell.localNameLabel setFrame:CGRectMake(26, 24, cell.contentView.frame.size.width - 40, 30)];
    [cell.countryLabel setFrame:CGRectMake(26, 45, cell.mainContentView.frame.size.width - 20, 29)];
    NSString *state = masjid.largerArea.length > 0 ? [NSString stringWithFormat:@"%@%@ %@",masjid.largerArea,@",",masjid.country] : masjid.country;
    cell.countryLabel.text = state;
    
    switch ([masjid.favorite intValue]) {
        case 1:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:249.0/255.0 blue:93.0/255.0 alpha:1.0];
            break;
        case 2:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:206.0/255.0 blue:246.0/255.0 alpha:1.0];
            break;
        case 3:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:167.0/255.0 blue:112.0/255.0 alpha:1.0];
            break;
        case 4:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:138.0/255.0 blue:199.0/255.0 alpha:1.0];
            break;
            
        default:
            cell.mainContentView.backgroundColor = [UIColor whiteColor];
            break;
    }
    
    //    if (isSearching==YES) {
    //        for (int ab=0;ab<[addids count];ab++) {
    //            if ([[filteredMasjidID objectAtIndex:indexPath.row]isEqual:[addids objectAtIndex:ab]])
    //            {
    //                if ([[addpri objectAtIndex:ab]isEqual:@"1"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:112.0/255.0 green:249.0/255.0 blue:93.0/255.0 alpha:1.0];
    //                }
    //                else if ([[addpri objectAtIndex:ab]isEqual:@"2"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:163.0/255.0 green:206.0/255.0 blue:246.0/255.0 alpha:1.0];
    //                }
    //                else if ([[addpri objectAtIndex:ab]isEqual:@"3"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:167.0/255.0 blue:112.0/255.0 alpha:1.0];
    //                }
    //                else if ([[addpri objectAtIndex:ab]isEqual:@"4"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:138.0/255.0 blue:199.0/255.0 alpha:1.0];
    //                }
    //            }
    //        }
    //    }
    //    else
    //    {
    //        for (int ab=0; ab < [dictData count]; ab++)
    //        {
    //            NSArray *sortedKeys2 = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //            NSString *key2=[sortedKeys2 objectAtIndex:ab];
    //            NSString *valueForkey2=[dictData valueForKey:key2];
    //            if ([[[IdObject objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row] isEqualToString:valueForkey2])
    //            {
    //                if ([key2 isEqual:@"1"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:112.0/255.0 green:249.0/255.0 blue:93.0/255.0 alpha:1.0];
    //                }
    //                else if ([key2 isEqual:@"2"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:163.0/255.0 green:206.0/255.0 blue:246.0/255.0 alpha:1.0];
    //                }
    //                else if ([key2 isEqual:@"3"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:167.0/255.0 blue:112.0/255.0 alpha:1.0];
    //                }
    //                else if ([key2 isEqual:@"4"]) {
    //                    cell.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:138.0/255.0 blue:199.0/255.0 alpha:1.0];
    //                }
    //            }
    //        }
    //    }
    
    return cell;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if ([self.searchtextField isFirstResponder]) {
    //        [self.searchtextField resignFirstResponder];
    //        KeyAppearence=0;
    //    }
}

- (void)openDetailPage:(UIButton*)button
{
    MasjidDetailView *masjidView = [self.storyboard instantiateViewControllerWithIdentifier:@"masjidDetails"];
    [masjidView setMasjid:[masjids objectAtIndex:button.tag]];
    [self.navigationController pushViewController:masjidView animated:YES];
    
    //    address = [[addObject objectForKey:[arrayOfCharacters objectAtIndex:0]] objectAtIndex:button.tag];
    
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return alphabets;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchtextField resignFirstResponder];
    //    KeyAppearence=1;
    //    if ([textField.text length] == 0){
    //        [self setupIndexData];
    //        [searchingString setString:@""];
    //        [self.tableView reloadData];
    //    } else{
    //        if (textField.text !=nil) {
    //            if ([textField.text isEqualToString:@""]){
    //                NSRange range = NSMakeRange([searchingString length]-1,1);
    //                [searchingString replaceCharactersInRange:range withString:@""];
    //            } else {
    //                [searchingString setString:textField.text];
    //            }
    //            if ([textField.text isEqualToString:@""]) {
    //                [self setupIndexData];
    //                [self.tableView reloadData];
    //                isSearching=NO;
    //            } else if ([textField.text isEqualToString:@"Masjid "]||[textField.text isEqualToString:@"masjid "] || [textField.text isEqualToString:@"masjid"] || [textField.text isEqualToString:@"Masjid"]) {
    //                isSearching=NO;
    //                [self setupIndexData];
    //                [self.tableView reloadData];
    //            } else {
    //                isSearching= YES;
    //                NSString *nonMutableString=[NSString stringWithString:textField.text];
    //                NSString *regexString  = [NSString stringWithFormat:@".*\\b%@.*", nonMutableString];
    //                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masjid_name matches[cd] %@ OR masjid_larger_area matches[cd] %@ OR masjid_local_area matches[cd] %@" ,regexString,regexString,regexString];
    //                results = [jsonDict filteredArrayUsingPredicate:predicate];
    //                filterdMasjidName = [results valueForKey:@"masjid_name"];
    //                FilteredLocalArea = [results valueForKey:@"masjid_local_area"];
    //                FilteredCountry=[results valueForKey:@"masjid_country"];
    //                filteredLargerArea=[results valueForKey:@"masjid_larger_area"];
    //                filteredMasjidID=[results valueForKey:@"masjid_id"];
    //                [self.tableView reloadData];
    //            }
    //        }
    //    }
    //
    //    [self.searchtextField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    self.crossBtn.hidden=NO;
    //    KeyAppearence=0;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    if (string !=nil) {
    //        if ([string isEqualToString:@""]){
    //            NSRange range = NSMakeRange([searchingString length]-1,1);
    //            [searchingString replaceCharactersInRange:range withString:@""];
    //        } else {
    //            [searchingString appendFormat:@"%@",string];
    //        }
    //        if ([searchingString isEqualToString:@""]) {
    //            isSearching=NO;
    //            [self setupIndexData];
    //            [self.tableView reloadData];
    //        }
    //        else if ([searchingString isEqualToString:@"Masjid "]||[searchingString isEqualToString:@"masjid "] || [searchingString isEqualToString:@"masjid"] || [searchingString isEqualToString:@"Masjid"]) {
    //            isSearching=NO;
    //            CountryObject=Nil;
    //            largerObject=nil;
    //            objects=nil;
    //            objectsForCharacters=nil;
    //            objectsForCharacters = [[NSMutableDictionary alloc] initWithDictionary:objectsForCharacters];
    //            objects = [[NSMutableDictionary alloc] initWithDictionary:objects];
    //            largerObject = [[NSMutableDictionary alloc] initWithDictionary:largerObject];
    //            CountryObject = [[NSMutableDictionary alloc] initWithDictionary:CountryObject];
    //            [self.tableView reloadData];
    //        }
    //        else
    //        {
    //            isSearching= YES;
    //            NSString *nonMutableString=[NSString stringWithString:searchingString];
    //            NSString *regexString  = [NSString stringWithFormat:@".*\\b%@.*", nonMutableString];
    //            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masjid_name matches[cd] %@ OR masjid_larger_area matches[cd] %@ OR masjid_local_area matches[cd] %@" ,regexString,regexString,regexString];
    //            results = [jsonDict filteredArrayUsingPredicate:predicate];
    //            filterdMasjidName = [results valueForKey:@"masjid_name"];
    //            FilteredLocalArea = [results valueForKey:@"masjid_local_area"];
    //            FilteredCountry=[results valueForKey:@"masjid_country"];
    //            filteredLargerArea=[results valueForKey:@"masjid_larger_area"];
    //            filteredMasjidID=[results valueForKey:@"masjid_id"];
    //            [self.tableView reloadData];
    //        }
    //    }
    
    return YES;
}

- (IBAction)cancel:(id)sender
{
    [self.searchtextField resignFirstResponder];
    masjids = [[MTDBHelper sharedDBHelper] getMasjids];
    self.searchtextField.text=@"";
    //    KeyAppearence=1;
    //    [searchingString setString:@""];
    //    isSearching=NO;
    //    [self setupIndexData];
    [self.tableView reloadData];
    //    self.searchImage.hidden=NO;
}

//-(void)addSearchAlphbets
//{
//    float startY=120.2+24;
//    float height=10.2+0.5;
//    float width=22;
//    float startX=293;
//
//    if([UIScreen mainScreen].bounds.size.height > 650.0f)
//    {
//        startX=347;
//        startY=startY+55.77;
//        height=height+4.5;
//    }
//    else if([UIScreen mainScreen].bounds.size.height > 480.0f)
//    {
//        startY=startY+24.57;
//        height=height+2;
//    }
//
//    for (int x=0; x<26; x++) {
//        UIButton *searchAlphaButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        searchAlphaButton.frame=CGRectMake(startX, startY+1, width, height);
//        searchAlphaButton.tag=x;
//        [searchAlphaButton addTarget:self action:@selector(alphabetSearchButtonClicked:) forControlEvents:UIControlEventEditingChanged];
//        [self.view addSubview:searchAlphaButton];
//        startY=startY+height+2;
//        if([UIScreen mainScreen].bounds.size.height > 480.0f)
//        {
//            startY=startY+0.6;
//        }
//    }
//}

-(void)alphabetSearchButtonClicked:(UIButton *)_button{
    
    //    if (KeyAppearence==0) {
    //        [self.searchtextField resignFirstResponder];
    //        KeyAppearence=1;
    //    }
    //    else if (KeyAppearence==1)
    //    {
    //        isSearching=YES;
    //        self.searchtextField.text=@"";
    //        self.searchImage.hidden=NO;
    //        NSInteger number= _button.tag;
    //        NSString *_searchString=[NSString stringWithFormat:@"%c",number+65];
    //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masjid_name beginswith [c] %@",_searchString];
    //        results = [jsonDict filteredArrayUsingPredicate:predicate];
    //        filterdMasjidName=[results valueForKey:@"masjid_name"];
    //        FilteredLocalArea=[results valueForKey:@"masjid_local_area"];
    //        filteredLargerArea=[results valueForKey:@"masjid_larger_area"];
    //        FilteredCountry=[results valueForKey:@"masjid_country"];
    //        filteredMasjidID=[results valueForKey:@"masjid_id"];
    //        [self.tableView reloadData];
    //    }
}

- (IBAction)cancelTapped
{
    [self.searchtextField resignFirstResponder];
    self.searchImage.hidden=NO;
    isSearching=NO;
    [searchingString setString:@""];
    self.searchtextField.text=@"";
    [self setupIndexData];
    [self.tableView reloadData];
    KeyAppearence=1;
    
}

- (IBAction)timeTablePage
{
    if (KeyAppearence==0) {
        [self.searchtextField resignFirstResponder];
        KeyAppearence=1;
    }
    else if(KeyAppearence==1)
    {
        self.greenDot.hidden=YES;
        [self movet];
        KeyAppearence=1;
    }
}

-(void)movet
{
    xts=1;
    dispatch_async(dispatch_get_main_queue(), ^{
        TimeTableView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"timeTable"];
        [self.navigationController pushViewController:ttView animated:YES];
    });
    
}

- (IBAction)popView {
    if (KeyAppearence==0) {
        [self.searchtextField resignFirstResponder];
        KeyAppearence=1;
    }
    else if (KeyAppearence==1)
    {
        [self performSelector:@selector(popMethod) withObject:self afterDelay:0.5];
        KeyAppearence=1;
    }
}

-(void)popMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reload
{
    if (KeyAppearence==0) {
        [self.searchtextField resignFirstResponder];
        KeyAppearence=1;
    } else if (KeyAppearence==1) {
        [self.searchtextField resignFirstResponder];
        self.searchImage.hidden=NO;
        self.crossBtn.hidden=YES;
        isSearching=NO;
        [searchingString setString:@""];
        self.searchtextField.text=@"";
        [self retrievePost];
        [self refreshMasjidsData];
        [self.tableView reloadData];
        KeyAppearence=1;
    }
}

-(void)getNotes
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    firstKey=[sortedKeys objectAtIndex:1];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/notes.php?masjid_id=%@",[dictData valueForKey:firstKey]]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSArray *json = (NSArray *) JSON;
                                             globalMasjidNotes=[[NSArray alloc]init];
                                             globalMasjidNotes=json;
                                             [[NSUserDefaults standardUserDefaults] setObject:globalMasjidNotes forKey:@"globalMasjidNotes1"];
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
    
}

-(void)getDetailsOfTimeTable
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    NSString *str=[NSString stringWithFormat:@"/data/timetable.php?masjid_id=%@",[dictData valueForKey:firstKey]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:str parameters:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [SVProgressHUD dismiss];
                                             NSArray *result = (NSArray *) JSON;
                                             if ([result count]==0) {
                                                 [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"globalTimeTable1"];
                                             }
                                             else
                                             {
                                                 globalTimeTable=result;
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalTimeTable forKey:@"globalTimeTable1"];
                                             }
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                        }];
    [operation start];
}

-(void)getFormat
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    firstKey=[sortedKeys objectAtIndex:1];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    NSString *str=[NSString stringWithFormat:@"/data/timetabledetails.php?masjid_id=%@",[dictData valueForKey:firstKey]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:str parameters:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             globalTimeTableFormat= (NSArray *) JSON;
                                             if ([globalTimeTableFormat count]==0)
                                             {
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalTimeTableFormat forKey:@"globalTimeTableFormat1"];
                                             }
                                             else
                                             {
                                                 
                                                 
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalTimeTableFormat forKey:@"globalTimeTableFormat1"];
                                             }
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    
    [operation start];
}

-(void)retrievePost2
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    firstKey=[sortedKeys objectAtIndex:1];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/masjids.php?masjid_id=%@",[dictData valueForKey:firstKey]]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [SVProgressHUD dismiss];
                                             NSArray *getMasjid=(NSArray *) JSON;
                                             globalMasjidNames=[getMasjid objectAtIndex:0];
                                             if ([globalMasjidNames count]==0)
                                             {
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalMasjidNames forKey:@"globalMasjidValues1"];
                                             }
                                             else
                                             {
                                                 NSMutableDictionary *mutableDict = [globalMasjidNames mutableCopy];
                                                 for (NSString *key in [globalMasjidNames allKeys])
                                                 {
                                                     if ([[globalMasjidNames objectForKey:key]isEqual:[NSNull null]])
                                                     {
                                                         [mutableDict setValue:@""forKey:key];
                                                     }
                                                 }
                                                 globalMasjidNames = [mutableDict copy];
                                                 NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:globalMasjidNames];
                                                 NSDictionary *myDictionary = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
                                                 [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"globalMasjidValues1"];
                                             }
                                             
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                        }];
    [operation start];
    
}

-(void)getTimeTable
{
    NSArray *sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *firstKey=[sortedKeys objectAtIndex:1];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/timetable.php?masjid_id=%@",[dictData valueForKey:firstKey]] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSArray *jsonObject = (NSArray *) JSON;
                                                                                            [[NSUserDefaults standardUserDefaults]setValue:jsonObject forKey:@"monthlyTimetable1"];
                                                                                            
                                                                                        }
                                         
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                        }];
    
    [operation start];
}

@end
