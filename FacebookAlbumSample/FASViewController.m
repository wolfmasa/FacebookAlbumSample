//
//  FASViewController.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/08.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASViewController.h"

@interface FASViewController ()

@end

@implementation FASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    return YES;
}

- (IBAction)getAlbumList:(id)sender {
    
    // We will request the user's public profile and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"user_photos", @"user_about_me"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has:
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted
                                               NSLog(@"new permissions %@", [FBSession.activeSession permissions]);
                                               // We can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // See: https://developers.facebook.com/docs/ios/errors
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void)makeRequestForUserDataWithPath:(NSString*)url
{
    NSLog(@"URL:%@", url);
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:url
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              NSLog(@"call");
                              if (!error){
                                  //NSError *returnError;
                                  FBGraphObject *albums = [result objectForKey:@"albums"];
                                  
                                  NSMutableArray *data = [albums objectForKey:@"data"];
                                  for (NSInteger i=0; i<data.count; i++) {
                                      FBGraphObject *obj = [data objectAtIndex:i];
                                      NSLog(@"%@", [obj objectForKey:@"name"]);
                                  }
                                  
                                  FBGraphObject *nextpage =[albums objectForKey:@"paging"];
                                  NSString *nextPageURL = [nextpage objectForKey:@"next"];
                                  
                                  NSLog(@"%@", nextPageURL);
                                  NSString *subpath = [nextPageURL substringFromIndex:[@"https://graph.facebook.com/100002061333915" length]];
                                  NSString *path = [@"/me" stringByAppendingString:subpath];
                                  [self makeRequestForUserDataWithPath:path];
                                  
                              }
                          }
     ];
}

-(void)makeRequestForUserData
{
    [self makeRequestForUserDataWithPath:@"/me?fields=albums.fields(name)"];
}

@end
