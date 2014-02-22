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
    
    self.albumList = [NSMutableArray new];
    [self.albumListView setDelegate:self];
    [self.albumListView setDataSource:self];
    
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

-(void)parseAlbumFBGraphObject:(FBGraphObject*)albums
{
    
    NSMutableArray *data = [albums objectForKey:@"data"];
    for (NSInteger i=0; i<data.count; i++) {
        FBGraphObject *obj = [data objectAtIndex:i];
        NSLog(@"%@", [obj objectForKey:@"name"]);
        
        FASAlbum *album = [[FASAlbum alloc]initWithFBObject:obj];
        [album setName:[obj objectForKey:@"name"]];
        [album setAlbumId:[obj objectForKey:@"id"]];
        [self getAlbumDataWithFacebookID:album.albumId];
        [self.albumList addObject:album];
    }
    
    FBGraphObject *nextpage =[albums objectForKey:@"paging"];
    NSString *nextPageURL = [nextpage objectForKey:@"next"];
    
    NSLog(@"%@", nextPageURL);
    NSString *path = [nextPageURL substringFromIndex:[@"https://graph.facebook.com" length]];
    //NSString *path = [@"/me" stringByAppendingString:subpath];
    [self makeRequestForUserDataWithPath:path];
}

//URLの文字列を受け取って、SDK経由でアルバム一覧のFBGraphObjectを取得する
-(void)makeRequestForUserDataWithPath:(NSString*)url
{
    NSLog(@"URL:%@", url);
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:url
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              NSLog(@"call");
                              if (!error){
                                  if([result objectForKey:@"data"] == nil)
                                  {
                                      //最初のページはAlbumの中にある
                                      result = [result objectForKey:@"albums"];
                                  }
                                  else
                                  {
                                      //これを書かないと再帰的に全てのアルバムを取得しに行く。
                                      result = nil;
                                  }
                                  [self parseAlbumFBGraphObject:result];
                              }
                              
                              [self.albumListView reloadData];
                          }
     ];
}

//URLの文字列を受け取って、SDK経由でアルバムのFBGraphObjectを取得する
-(void)getAlbumDataWithFacebookID:(NSString*)albumId
{
    NSString *url = [NSString stringWithFormat:@"/%@/photos", albumId];
    NSLog(@"URL:%@", url);
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:url
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              NSLog(@"call");
                              if (!error){
                                  NSMutableArray *array = [result objectForKey:@"data"];
                                  NSLog(@"%@", array);
                                  //for (FBGraphObject* obj in array) {
                                  FBGraphObject *obj = (FBGraphObject*)[array objectAtIndex:0];
                                  {
                                      NSString *pictureUrl = [obj objectForKey:@"picture"];//source
                                      
                                      NSLog(@"%@", pictureUrl);
                                      
                                      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pictureUrl]];
                                      [request setHTTPMethod:@"GET"];
                                      NSURLResponse *response = nil;
                                      NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                                      
                                      self.pic.image =[UIImage imageWithData:data];
                                  }
//                                  [self parseAlbumFBGraphObject:result];
                              }
                              
                              [self.albumListView reloadData];
                          }
     ];
}

-(void)makeRequestForUserData
{
    [self makeRequestForUserDataWithPath:@"/me?fields=albums.fields(name)"];
}

#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [UITableViewCell new];
    FASAlbum *a = (FASAlbum *)[self.albumList objectAtIndex:indexPath.row];
    [newCell textLabel].text = a.name;
    return newCell;
}

- (IBAction)pushNext:(id)sender {
}
@end
