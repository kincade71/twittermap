//
//  Annotation.m
//  twittertest
//
//  Created by Richard Robinson on 9/13/14.
//  Copyright (c) 2014 WEBDMG. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize tweetid;
@synthesize tweet;
@synthesize profile_image_url;

-(id)initWithPosition:(CLLocationCoordinate2D)coords{
    if (self = [super init]) {
        self.coordinate = coords;
    }
    return self;
}

@end
