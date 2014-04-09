//
//  FASFacebookConnection.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/03/04.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FASPhoto.h"
#import "FASAlbumThumbnailView.h"

@interface FASFacebookConnection : NSObject

//シングルトン
+(FASFacebookConnection*)sharedConnection;

@property(weak, nonatomic)UITableView* reloadTableTarget;
@property(weak, nonatomic)FASAlbumThumbnailView* reloadCollectionTarget;

-(void)startFacebookConnection;
-(BOOL)getNextAlbumPage;
-(void)getAlbumData:(NSString*)albumId;

@property NSString *nextAlbumListGraphPath;
@property NSString *nextPhotoListGraphPath;

-(BOOL)getNextAlbumList:(BOOL)isFirst;
-(BOOL)getNextPhotoList:(BOOL)isFirst;
-(BOOL)getThumbnailImage:(FASPhoto*)photo;
-(BOOL)getFullImage:(FASPhoto*)photo;

-(void)updateProgress:(NSNumber*)value100;

@end
