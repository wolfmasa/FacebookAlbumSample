//
//  FASFacebookConnection.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/03/04.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASFacebookConnection.h"
#import "FASDataManager.h"

@implementation FASFacebookConnection

static FASFacebookConnection *sharedConnection_ = nil;

+ (FASFacebookConnection *)sharedConnection{
    if (!sharedConnection_) {
        sharedConnection_ = [FASFacebookConnection new];
        sharedConnection_.connectStatus = YES;
        sharedConnection_.permission = [NSMutableArray arrayWithArray:@[@"basic_info", @"user_photos", @"user_about_me"]];
    }

    //未接続状態ならnilを返す。（使えない）
    if(sharedConnection_.connectStatus != YES) return nil;
    return sharedConnection_;
}

-(void)initConnection
{
    
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
                                  for (NSString *permission in _permission){
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
                                           if(error){
                                               NSLog(@"Error:%@", error);
                                           }
                                           else{
                                               [_permission addObjectsFromArray:requestPermissions];
                                           }
                                       }];
                                  }
                                  
                              } else {
                                  NSLog(@"Error:%@", error);
                              }
                          }
     ];
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
                                               [self getFirstAlbumList];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // See: https://developers.facebook.com/docs/ios/errors
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self getFirstAlbumList];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void)getFirstAlbumList
{
    [self getUserDataWithGraphPath:@"/me?fields=albums.fields(name)"];
}

-(NSString*)parseUrlToGraphPath:(NSString*)url
{
    return[url substringFromIndex:[@"https://graph.facebook.com" length]];
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
                                  if(result[@"data"] == nil)
                                  {
                                      //最初のページはAlbumの中にある
                                      result = result[@"albums"];
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
    FASDataManager *dataManager = [FASDataManager sharedManager];
    
    NSMutableArray *data = albums[@"data"];
    //現在のページに書いてあるアルバム名一覧を取得する
    for (NSInteger i=0; i<data.count; i++) {
        FBGraphObject *obj = [data objectAtIndex:i];
        FASAlbum *album = [FASAlbum new];
        [album setName:obj[@"name"]];
        [album setAlbumId:obj[@"id"]];
        
        [dataManager.albums addObject:album];
    }
    
    FBGraphObject *nextpage =albums[@"paging"];
    NSString *nextPageURL = nextpage[@"next"];
    
    //次のページをセットする
    NSLog(@"%@", nextPageURL);
    dataManager.nextPageGraphPath = [self parseUrlToGraphPath:nextPageURL];
    self.nextAlbumListGraphPath = [self parseUrlToGraphPath:nextPageURL];
}


-(void)getAlbumData:(NSString*)albumId
{
    [self getAlbumDataWithFacebookID:[NSString stringWithFormat:@"/%@/photos", albumId]];
}

-(BOOL)getNextAlbumPage
{
    FASDataManager *dataManager = [FASDataManager sharedManager];
    if(dataManager.nextPageGraphPath != nil)
    {
        [self getUserDataWithGraphPath:dataManager.nextPageGraphPath];
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
                                  FASDataManager *dataManager = [FASDataManager sharedManager];
                                  NSMutableArray *array = result[@"data"];
                                  NSLog(@"%@", array);
                                  for (FBGraphObject* obj in array)
                                  //FBGraphObject *obj = (FBGraphObject*)[array objectAtIndex:0];
                                  {
                                      NSString *pictureUrl = obj[@"picture"];//source
                                      NSString *graphId = obj[@"id"];
                                      NSString *source = obj[@"source"];
                                      
                                      NSLog(@"%@", pictureUrl);
                                      
                                      FASAlbum* album = [dataManager getActiveAlbum];
                                      FASPhoto *photo = [FASPhoto new];
                                      photo.thumbnailUrl = pictureUrl;
                                      photo.imageUrl = source;
                                      photo.graphId = graphId;
                                      [self getThumbnailImage:photo];
                                      [album.photos addObject:photo];
                                      
                                  }
                              }
                              
                              [self.reloadCollectionTarget.thumbnailCollection reloadData];
                          }
     ];
}

#pragma mark New Interface

-(BOOL)getNextAlbumList:(BOOL)isFirst
{
    if(self.nextAlbumListGraphPath == nil)
        self.nextAlbumListGraphPath = @"/me?fields=albums.fields(name)";
    
    __block BOOL flag = YES;
    __block BOOL ret = NO;
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:self.nextAlbumListGraphPath
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              if (!error){
                                  if(result[@"data"] == nil)
                                  {
                                      //最初のページはAlbumの中にある
                                      result = result[@"albums"];
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

-(void)kickNext
{
    [self getNextPhotoList:NO];
}

-(void)_updateProgress:(NSNumber*)value100
{
    float progressValue =(float)[value100 intValue]/100;
    NSLog(@"progress:%f", progressValue);
    if(progressValue >= 1.0)
    {
        if(self.reloadCollectionTarget.indicator !=nil)
        {
            [self.reloadCollectionTarget.indicator stopAnimating];
        }
        progressValue = 0;
        
    }
    else if(self.reloadCollectionTarget.indicator == nil)
    {
        self.reloadCollectionTarget.indicator = [UIActivityIndicatorView alloc];
        self.reloadCollectionTarget.indicator = [self.reloadCollectionTarget.indicator initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.reloadCollectionTarget.indicator.hidesWhenStopped = YES;
        CGSize size = self.reloadCollectionTarget.indicator.frame.size;
        self.reloadCollectionTarget.indicator.frame = CGRectMake(200, 200, size.width, size.height);
        [self.reloadCollectionTarget.thumbnailCollection addSubview:self.reloadCollectionTarget.indicator];
        [self.reloadCollectionTarget.thumbnailCollection bringSubviewToFront:self.reloadCollectionTarget.indicator];
        [self.reloadCollectionTarget.indicator startAnimating];
    }
    [self.reloadCollectionTarget.progress setProgress:progressValue];
    
}

-(void)updateProgress:(NSNumber*)value100
{
    [self performSelectorInBackground:@selector(_updateProgress:) withObject:value100];
}

-(BOOL)getNextPhotoList:(BOOL)isFirst
{
    __block BOOL ret = NO;
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    
    NSLog(@"getNextPhotoList:%d", isFirst);
   if(isFirst == YES)
   {
       FASAlbum *album = [dataManager getActiveAlbum];
       if([album.photos count] > 0) return YES;
       self.nextPhotoListGraphPath = [NSString stringWithFormat:@"/%@/photos", album.albumId];
   }
   else if(self.nextPhotoListGraphPath == nil)
   {
       ret = YES;
       return ret;
   }
    
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:self.nextPhotoListGraphPath
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              if (!error){
                                  NSNumber* progressVal = @0;
                                  [self updateProgress:progressVal];
                                  FASAlbum* album = [dataManager getActiveAlbum];
                                  NSMutableArray *array = result[@"data"];
                                  int i=0;
                                  for (FBGraphObject* obj in array)
                                  {
                                      i++;
                                      
                                      NSString *pictureUrl = obj[@"picture"];//source
                                      NSString *graphId = obj[@"id"];
                                      NSString *source = obj[@"source"];

                                      FASPhoto *photo = [FASPhoto new];
                                      
                                      //TODO リストを取得するタイミングでは画像はいらない？
                                      photo.imageUrl = source;
                                      photo.thumbnailUrl = pictureUrl;
                                      photo.graphId = graphId;
                                      photo.thumbnail =[self getPhoto:photo.thumbnailUrl];
                                      [album.photos addObject:photo];
                                      
                                      progressVal = [NSNumber numberWithFloat:((float)i*100/[array count])];
                                      [self updateProgress:progressVal];
                                  }
                                  
                                  [self.reloadCollectionTarget updateCacheStatus];
                                  
                                  FBGraphObject *paging = result[@"paging"];
                                  self.nextPhotoListGraphPath = [self parseUrlToGraphPath:paging[@"next"]];
                                  
                                  ret = YES;
                              }
                              
                              [self.reloadCollectionTarget.thumbnailCollection reloadData];
                              [self performSelectorInBackground:@selector(kickNext) withObject:nil];
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
