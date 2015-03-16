//
//  MasjidListView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "TableViewCell.h"

@class MasjidListTextField;

@interface MasjidListView : UIViewController<UITextFieldDelegate,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIImageView *searchImage;
@property (strong, nonatomic) IBOutlet UILabel *backLabel;
@property (strong, nonatomic) IBOutlet MasjidListTextField *searchtextField;
@property (strong, nonatomic) IBOutlet UIButton *crossBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *greenDot;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;
@property (weak, nonatomic) IBOutlet UIButton *navLeft;
@property (weak, nonatomic) IBOutlet UILabel *navCenter;
@property (weak, nonatomic) IBOutlet UIButton *navRight;
@property (weak, nonatomic) IBOutlet UIButton *all;
@property (strong, nonatomic) IBOutlet UIView *alphabetView;

- (IBAction)cancelTapped;
- (IBAction)timeTablePage;
- (IBAction)popView;
- (IBAction)reload;

@end
