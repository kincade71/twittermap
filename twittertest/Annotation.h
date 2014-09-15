//
//  Annotation.h
//  twittertest
//
//  Created by Richard Robinson on 9/13/14.
//  Copyright (c) 2014 WEBDMG. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *tweetid;
@property (nonatomic, copy) NSString *tweet;
@property (nonatomic, copy) NSString *profile_image_url;

-initWithPosition:(CLLocationCoordinate2D)coords;
@end
