//
//  ViewController.h
//  twittertest
//
//  Created by Richard Robinson on 9/11/14.
//  Copyright (c) 2014 WEBDMG. All rights reserved.
//

@import UIKit;
@import MapKit;
@import CoreLocation;
@import Twitter;
@import Accounts;

//custom class import
#import "TweetViewController.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic)  NSString *selectedAnnotation;
@property (weak, nonatomic)  NSString *tweettext;
@property (weak, nonatomic)  NSString *profile_image_url_loc;
@end

