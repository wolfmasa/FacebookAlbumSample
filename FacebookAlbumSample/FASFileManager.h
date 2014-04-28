//
//  FASFileManager.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/04/06.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FASFileManager : NSObject

//シングルトン
+(FASFileManager*)sharedManager;

@property NSString* userId;
@property NSString* albumId;

-(BOOL)initWithUserId:(NSString*)userId;
-(BOOL)setAlbum:(NSString*)albumId;

//save
-(BOOL)savePhoto:(NSString*)photoId image:(UIImage*)image;

//read
-(UIImage*)getPhotoWithPath:(NSString*)photoId;

//delete
-(void)deleteAlbum:(NSString*)albumId;
-(void)deletePhoto:(NSString*)photoId;
-(void)clearAllCache;

// archive
-(BOOL)archivePhotoData:(NSMutableArray*)albums;
-(NSMutableArray*)unarchivePhotoData;

@end
