//
//  FASFacebookConnection.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/03/04.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASFacebookConnection.h"

@implementation FASFacebookConnection

-(FASFacebookConnection*)initWithDataManager:(FASDataManager*)manager
{
    self.dataManager = manager;
    
    self.nextAlbumListGraphPath = nil;
    self.nextPhotoListGraphPath = nil;
    return [super init];
}

-(void)startFacebookConnection
{
    
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
                                               [self getAlbumData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // See: https://developers.facebook.com/docs/ios/errors
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self getAlbumData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void)getAlbumData
{
    [self getUserDataWithGraphPath:@"/me?fields=albums.fields(name)"];
}

//URLの文字列を受け取って、SDK経由でアルバム一覧のFBGraphObjectを取得する
-(void)getUserDataWithGraphPath:(NSString*)path
{
    NSLog(@"URL:%@", path);
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:path
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
                                      //result = nil;
                                  }
                                  [self parseAlbumFBGraphObject:result];
                              }
                              
                              [self.reloadTableTarget reloadData];
                          }
     ];
}

-(void)parseAlbumFBGraphObject:(FBGraphObject*)albums
{
    
    NSMutableArray *data = [albums objectForKey:@"data"];
    //現在のページに書いてあるアルバム名一覧を取得する
    for (NSInteger i=0; i<data.count; i++) {
        FBGraphObject *obj = [data objectAtIndex:i];
        FASAlbum *album = [[FASAlbum alloc]initWithFBObject:obj];
        [album setName:[obj objectForKey:@"name"]];
        [album setAlbumId:[obj objectForKey:@"id"]];
        
        [self.dataManager.albums addObject:album];
    }
    
    FBGraphObject *nextpage =[albums objectForKey:@"paging"];
    NSString *nextPageURL = [nextpage objectForKey:@"next"];
    
    //次のページをセットする
    NSLog(@"%@", nextPageURL);
    self.dataManager.nextPageGraphPath = [nextPageURL substringFromIndex:[@"https://graph.facebook.com" length]];
    self.nextAlbumListGraphPath = [nextPageURL substringFromIndex:[@"https://graph.facebook.com" length]];
}


-(void)getAlbumData:(NSString*)albumId
{
    [self getAlbumDataWithFacebookID:[NSString stringWithFormat:@"/%@/photos", albumId]];
}

-(BOOL)getNextAlbumPage
{
    if(self.dataManager.nextPageGraphPath != nil)
    {
        [self getUserDataWithGraphPath:self.dataManager.nextPageGraphPath];
        return YES;
    }
    else
        return NO;
}

-(UIImage*)getPhoto:(NSString*)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return [UIImage imageWithData:data];
}

//URLの文字列を受け取って、SDK経由でアルバムのFBGraphObjectを取得する
-(void)getAlbumDataWithFacebookID:(NSString*)url
{
    NSLog(@"URL:%@", url);
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:url
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              NSLog(@"call");
                              if (!error){
                                  NSMutableArray *array = [result objectForKey:@"data"];
                                  NSLog(@"%@", array);
                                  for (FBGraphObject* obj in array)
                                  //FBGraphObject *obj = (FBGraphObject*)[array objectAtIndex:0];
                                  {
                                      NSString *pictureUrl = [obj objectForKey:@"picture"];//source
                                      NSString *graphId = [obj objectForKey:@"id"];
                                      //NSMutableArray *images =[obj objectForKey:@"images"];
                                      NSString *source = [obj objectForKey:@"source"];
                                      
                                      NSLog(@"%@", pictureUrl);
                                      
                                      FASAlbum* album = (FASAlbum*)[self.dataManager.albums objectAtIndex:self.dataManager.activeAlbumIndex];
                                      FASPhoto *photo = [FASPhoto new];
                                      photo.thumbnailUrl = pictureUrl;
                                      photo.imageUrl = source;
                                      photo.graphId = graphId;
                                      photo.thumbnail =[self getPhoto:photo.thumbnailUrl];
                                      [album.photos addObject:photo];
                                      
                                  }
                              }
                              
                              [self.reloadCollectionTarget.thumbnailCollection reloadData];
                          }
     ];
}

#pragma mark New Interface

-(BOOL)getNextAlbumList
{
    if(self.nextAlbumListGraphPath == nil)
        self.nextAlbumListGraphPath = @"/me?fields=albums.fields(name)";
    
    __block BOOL flag = YES;
    __block BOOL ret = NO;
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:self.nextAlbumListGraphPath
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              if (!error){
                                  if([result objectForKey:@"data"] == nil)
                                  {
                                      //最初のページはAlbumの中にある
                                      result = [result objectForKey:@"albums"];
                                  }
                                  [self parseAlbumFBGraphObject:result];
                                  ret = YES;
                              }
                              
                              [self.reloadTableTarget reloadData];
                              flag = NO;
                          }];
    
    //非同期で実行されてしまうので、待ち合わせ
    while (flag) sleep(500);

    return ret;
}

-(BOOL)getNextPhotoList
{
   if(self.nextPhotoListGraphPath == nil)
   {
       FASAlbum *album = [self.dataManager.albums objectAtIndex:self.dataManager.activeAlbumIndex];
       self.nextPhotoListGraphPath = [NSString stringWithFormat:@"/%@/photos", album.albumId];
   }
    __block BOOL ret = NO;
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:self.nextPhotoListGraphPath
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              if (!error){
                                  FASAlbum* album = (FASAlbum*)[self.dataManager.albums objectAtIndex:self.dataManager.activeAlbumIndex];
                                  NSMutableArray *array = [result objectForKey:@"data"];
                                  for (FBGraphObject* obj in array)
                                  {
                                      NSString *pictureUrl = [obj objectForKey:@"picture"];//source
                                      NSString *graphId = [obj objectForKey:@"id"];
                                      NSString *source = [obj objectForKey:@"source"];
                                      
                                      
                                      FASPhoto *photo = [FASPhoto new];
                                      
                                      //TODO リストを取得するタイミングでは画像はいらない？
                                      photo.imageUrl = source;
                                      photo.thumbnailUrl = pictureUrl;
                                      photo.graphId = graphId;
                                      photo.thumbnail =[self getPhoto:photo.thumbnailUrl];
                                      [album.photos addObject:photo];
                                      
                                  }
                                  
                                  FBGraphObject *paging = [result objectForKey:@"paging"];
                                  self.nextPhotoListGraphPath = [paging objectForKey:@"next"];
                                  
                                  
                                  ret = YES;
                              }
                              
                              [self.reloadCollectionTarget.thumbnailCollection reloadData];
                          }
     ];
    
    return ret;
}

-(BOOL)getThumbnailImage:(FASPhoto*)photo
{
    photo.thumbnail = [self getPhoto:photo.thumbnailUrl];
    if (photo.thumbnail != nil)
        return YES;
    else
        return NO;
}

-(BOOL)getFullImage:(FASPhoto*)photo
{
    photo.image = [self getPhoto:photo.imageUrl];
    if (photo.image != nil)
        return YES;
    else
        return NO;
}

@end
