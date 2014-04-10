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

+ (FASFileManager *)sharedManager{
    if (!sharedManager_) {
        sharedManager_ = [FASFileManager new];
    }
    return sharedManager_;
}

-(NSString*)getDocumentDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
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

-(BOOL)setAlbum:(NSString*)albumId
{
    if (albumId==nil || self.userId==nil) return NO;
    
    self.albumId = albumId;
    
    NSString* dirPath = [NSString stringWithFormat:@"%@/%@/%@", [self getDocumentDir],self.userId, self.albumId];
    
    return [self createDir:dirPath];
}

-(BOOL)savePhoto:(NSString*)photoId image:(UIImage*)image
{
    if(self.albumId==nil || self.userId==nil || photoId==nil||image==nil) return NO;
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@/%@/%@.jpg", [self getDocumentDir],self.userId, self.albumId, photoId];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath] != YES)
    {
        NSData *data = UIImageJPEGRepresentation(image, 0.8f);
        NSLog(@"Save File:%@", filePath);
        return [data writeToFile:filePath atomically:YES];
    }
    else
        return YES;
}

-(UIImage*)getPhotoWithPath:(NSString*)photoId
{
    NSString* filePath = [NSString stringWithFormat:@"%@/%@/%@/%@.jpg", [self getDocumentDir],self.userId, self.albumId, photoId];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]==YES)
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    else
        return nil;
}

-(void)deleteFile:(NSString*)path
{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

-(void)deleteAlbum:(NSString*)albumId
{
    [self deleteFile:[NSString stringWithFormat:@"%@/%@/%@", [self getDocumentDir],self.userId, albumId]];
}

-(void)deletePhoto:(NSString*)photoId
{
    [self deleteFile:[NSString stringWithFormat:@"%@/%@/%@/%@.jpg"
                      , [self getDocumentDir],self.userId, self.albumId, photoId]];
}


#pragma mark Archive
-(BOOL)archivePhotoData:(NSMutableArray*)albums
{
    NSString *filePath = [[self getDocumentDir] stringByAppendingPathComponent:@"data.dat"];
    
    BOOL successful = [NSKeyedArchiver archiveRootObject:albums toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
        return YES;
    }
    
    return NO;
}

-(NSMutableArray*)unarchivePhotoData
{
    NSString *filePath = [[self getDocumentDir] stringByAppendingPathComponent:@"data.dat"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (array)
    {
        for (NSString *data in array)
        {
            NSLog(@"%@", data);
        }
    } else {
        NSLog(@"%@", @"データが存在しません。");
    }
    
    return array;
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
