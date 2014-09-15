//
//  ViewController.m
//  twittertest
//
//  Created by Richard Robinson on 9/11/14.
//  Copyright (c) 2014 WEBDMG. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize selectedAnnotation;
@synthesize tweettext;
@synthesize profile_image_url_loc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    self.locationManager = [CLLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:TRUE];
    
    //tranparent ui navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};

}


//animates to users region
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //creates geo fence for 1 mile around user
    CLLocationDistance fenceDistance = 1609.34;
    CLLocationCoordinate2D location = [userLocation coordinate];
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 50000, 50000);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {

            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
        if (accounts.count) {
            ACAccount *twitterAccount = [accounts objectAtIndex:0];
    
    NSString *geoCode = [NSString stringWithFormat:@"%f,%f,1mi",location.latitude,location.longitude];
    
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"" forKey:@"q="];
    [parameters setObject:geoCode forKey:@"geocode"];
    [parameters setObject:@"100" forKey:@"count"];
    
    
    // Do a simple search, using the Twitter API
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"]
                                             parameters:parameters requestMethod:TWRequestMethodGET];
    [request setAccount:twitterAccount];
    // Notice this is a block, it is the handler to process the response
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if ([urlResponse statusCode] == 200)
        {
            // The response from Twitter is in JSON format
            // Move the response into a dictionary and print
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            
            NSMutableArray *annotations = [[NSMutableArray alloc]init];
            Annotation *ann;
            CLLocationCoordinate2D location;
            
            for (NSDictionary *tempObject in [dict objectForKey:@"statuses"]) {
            // Get the objects you want, e.g. output the second item's client id
            NSArray *geo = [tempObject valueForKeyPath:@"geo.coordinates"];
            NSArray *users = [tempObject valueForKeyPath:@"user"];
            if (!geo || [geo isKindOfClass:[NSNull class]]) {
                NSLog(@"No geo data present");
            }else{
            NSString *tweetId = [tempObject valueForKey:@"id_str"];
            NSString *username = [users valueForKey:@"screen_name"];
            NSString *name = [users valueForKey:@"name"];
            NSString *text = [tempObject valueForKey:@"text"];
            NSString *profile_image_url = [users valueForKey:@"profile_image_url"];
           
            NSString *latitude = [geo objectAtIndex:0];
            NSString *longitude = [geo objectAtIndex:1];
            
            double latdouble = [latitude doubleValue];
            double longsdouble = [longitude doubleValue];
               
            location.latitude = latdouble;
            location.longitude = longsdouble;
            ann = [[Annotation alloc]init];
            [ann setCoordinate:location];
            ann.title = name;
            ann.subtitle = [NSString stringWithFormat:@"@%@",username];
            ann.tweetid = tweetId;
            ann.tweet = text;
            ann.profile_image_url = profile_image_url;
            [annotations addObject:ann];
                     }
            
             [self.mapView addAnnotations:annotations];
            }
        }
        else
            NSLog(@"Twitter error, HTTP response: %li", (long)[urlResponse statusCode]);
    }];
        }else
            NSLog(@"unathorized");
    }];
    
    [self.mapView addOverlay: circle];
    [self.mapView setRegion:region animated:YES];
    
    //call update after one second
    [self performSelector:@selector(mapView:didUpdateUserLocation:) withObject:self afterDelay:3600];
}

#pragma mark overlay;
//creates the overlay
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circleR.fillColor = [UIColor clearColor];
    circleR.strokeColor = [UIColor blueColor];
    return circleR;
}

#pragma mark ann customize
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    view.pinColor = MKPinAnnotationColorPurple;
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Twitter"]];
    view.leftCalloutAccessoryView = imageView;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //annotation
    Annotation *ann = (Annotation *)view.annotation;
    //deselect
    [self.mapView deselectAnnotation:ann animated:YES];
    
    //Check if the annotation is of our annotation class
    if ([view.annotation isKindOfClass:[Annotation class]]) {
        // Store a reference to the annotation so that we can pass it on in prepare for segue.
        selectedAnnotation = ann.tweetid;
        tweettext = ann.tweet;
        profile_image_url_loc = ann.profile_image_url;
        [self performSegueWithIdentifier:@"tweet" sender:self];
    }
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tweet"]) {
        TweetViewController *destViewController = segue.destinationViewController;
        destViewController.tweetid = selectedAnnotation;
        destViewController.tweettext = tweettext;
        destViewController.profile_image_url_dest = profile_image_url_loc;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
