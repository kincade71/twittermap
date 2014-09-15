//
//  TweetViewController.h
//  twittertest
//
//  Created by Richard Robinson on 9/14/14.
//  Copyright (c) 2014 WEBDMG. All rights reserved.
//

@import UIKit;
@import Twitter;
@import Accounts;

@interface TweetViewController : UIViewController

@property (nonatomic, strong) NSString *tweetid;
@property (nonatomic, strong) NSString *tweettext;
@property (nonatomic, strong) NSString *profile_image_url_dest;
@property (weak, nonatomic) IBOutlet UIImageView *profilimage;
@property (weak, nonatomic) IBOutlet UITextView *text;

//actions
- (IBAction)favorite:(id)sender;
- (IBAction)retweet:(id)sender;

@end
