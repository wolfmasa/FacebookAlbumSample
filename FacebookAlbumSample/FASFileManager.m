//
//  FASFileManager.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/04/06.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASFileManager.h"

@implementation FASFileManager
static FASFileManager *sharedManager_ = nil;

+ (FASFileManager *)sharedConnection{
    if (!sharedManager_) {
        sharedManager_ = [FASFileManager new];
    }
    return sharedManager_;
}

-(BOOL)createDir:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    
    if([fileManager fileExistsAtPath:path]!=YES)
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    
    if(err==nil) return YES;
    else return NO;
}

-(BOOL)initWithUserId:(NSString*)userId
{
    if(userId==nil) return NO;
    self.userId = userId;
    
    return [self createDir:userId];
}

-(BOOL)createAlbumDir:(NSString*)albumId
{
    if (albumId==nil || self.userId==nil) return NO;
    
    NSString* dirPath = [NSString stringWithFormat:@"%@/%@", self.userId, albumId];
    
    return [self createDir:dirPath];
}


/*
 NSFileManager *fm = [NSFileManager defaultManager];
 NSError *error;
 
 Dir
 // チェック
 [fm fileExistsAtPath:dirA];
 
 // 作成
 [fm createDirectoryAtPath:dirA withIntermediateDirectories:YES attributes:nil error:&error];
 
 // 移動
 [fm moveItemAtPath:dirA toPath:dirB error:&error];
 
 // コピー
 [fm copyItemAtPath:dirA toPath:dirB error:&error];
 
 // 削除
 [fm removeItemAtPath:dirA error:&error];
 
 File
 // 作成
 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://xxx/xxx.png"]];
 [fm createFileAtPath:pathA contents:data attributes:nil];
 
 // 削除
 [fm removeItemAtPath:pathA error:&error];
 
 // 移動
 [fm moveItemAtPath:pathA toPath:pathB error:&error];
 
 // コピー
 [fm copyItemAtPath:pathA toPath:pathB error:&error];
 
 */

@end
