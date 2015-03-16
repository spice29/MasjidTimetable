//
//  NearestMasjidView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "NearestMasjidView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#define kGOOGLE_API_KEY @"AIzaSyCmSqUd3wPMncaFJM-Q38nqEImkPza4fr8"
#define	kMosque	@"mosque"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NearestMasjidView ()
{
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    NSString *latitude,*longitude,*city;
    NSArray *masjidNames,*lat,*longs,*geometry,*location,*address;
}
@end

@implementation NearestMasjidView

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Local Maasjid";
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.nearMap.delegate = self;
    [self.nearMap setShowsUserLocation:YES];
    [self performSelector:@selector(updateLocation) withObject:nil afterDelay:10];
}

-(void)updateLocation
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];

    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {

        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    latitude=[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            city = [placemark locality];
        }
        [self makeRestaurantRequests];
    }];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKMapRect mRect = self.nearMap.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currentCentre = self.nearMap.centerCoordinate;
}


#pragma mark - MKMapViewDelegate methods.

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,10000,10000);
    
    [mv setRegion:region animated:YES];
}

-(void)makeRestaurantRequests
{
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://maps.googleapis.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/maps/api/place/textsearch/json?query=%@&sensor=%@&key=%@",[NSString stringWithFormat:@"%@+in+%@",@"mosque",city],@"false",@"AIzaSyCmSqUd3wPMncaFJM-Q38nqEImkPza4fr8"] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSDictionary *jsonDict = (NSDictionary *) JSON;
                                                                                            NSArray* places = [jsonDict objectForKey:@"results"];
                                                                                            masjidNames=[places valueForKey:@"name"];
                                                                                            geometry=[places valueForKey:@"geometry"];
                                                                                            location=[geometry valueForKey:@"location"];
                                                                                            address=[places valueForKey:@"formatted_address"];
                                                                                            lat=[location valueForKey:@"lat"];
                                                                                            longs=[location valueForKey:@"lng"];
                                                                                            [self mapAnnotations];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                        }];
    
    [operation start];
 
}

-(void)mapAnnotations
{
    for (int i=0; i<masjidNames.count; i++) {
        NSString *lati=[lat objectAtIndex:i];
        float latVal=[lati floatValue];
        NSString *longi=[longs objectAtIndex:i];
        float longVal= [longi floatValue];
        CLLocation* myLocation = [[CLLocation alloc] initWithLatitude:latVal longitude:longVal];
        CLLocationCoordinate2D clocation=myLocation.coordinate;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        region.span = span;
        region.center = clocation;
        MKPointAnnotation *secondpoint=[[MKPointAnnotation alloc]init];
        secondpoint.coordinate=myLocation.coordinate;
        secondpoint.title=[masjidNames objectAtIndex:i];
        secondpoint.subtitle=[address objectAtIndex:i];
        [self.nearMap addAnnotation:secondpoint];
    }
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

