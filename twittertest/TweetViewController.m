//
//  TweetViewController.m
//  twittertest
//
//  Created by Richard Robinson on 9/14/14.
//  Copyright (c) 2014 WEBDMG. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()

@end

@implementation TweetViewController
@synthesize tweetid;
@synthesize tweettext;
@synthesize text;
@synthesize profilimage;
@synthesize profile_image_url_dest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Add tweet text to view
    text.text = tweettext;
    //URL of image
    NSURL *url = [NSURL URLWithString:profile_image_url_dest];
    //convert image to data
    NSData *data = [NSData dataWithContentsOfURL:url];
    //create image object with data
    UIImage *img = [[UIImage alloc] initWithData:data];
    //add image to image view
    profilimage.image = img;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark action buttons
- (IBAction)favorite:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        NSArray *accounts = [accountStore accountsWithAccountType:accountType];
        if (accounts.count) {
            ACAccount *twitterAccount = [accounts objectAtIndex:0];
            
            
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:tweetid forKey:@"id"];
            
            
            // Do a simple search, using the Twitter API
            TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/create.json"]
                                                     parameters:parameters requestMethod:TWRequestMethodPOST];
            [request setAccount:twitterAccount];
            // Notice this is a block, it is the handler to process the response
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
             {
                 if ([urlResponse statusCode] == 200)
                 {
 
                     //alert location
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Response" message:@"Fav!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                     [alert show];

                }
                 else
                     NSLog(@"Twitter error, HTTP response: %li", (long)[urlResponse statusCode]);
             }];
        }else
            NSLog(@"unathorized");
    }];
   
}

- (IBAction)retweet:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        NSArray *accounts = [accountStore accountsWithAccountType:accountType];
        if (accounts.count) {
            ACAccount *twitterAccount = [accounts objectAtIndex:0];
            
            NSString *twitterUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", tweetid];
            
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:tweetid forKey:@"id"];
            
            
            // Do a simple search, using the Twitter API
            TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:twitterUrl]
                                                     parameters:parameters requestMethod:TWRequestMethodPOST];
            [request setAccount:twitterAccount];
            // Notice this is a block, it is the handler to process the response
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
             {
                 if ([urlResponse statusCode] == 200)
                 {

                     //alert location
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Response" message:@"Retweeted" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     
                 }
                 else
                     NSLog(@"Twitter error, HTTP response: %li", (long)[urlResponse statusCode]);
             }];
        }else
            NSLog(@"unathorized");
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
