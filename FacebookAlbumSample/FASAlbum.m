//
//  FASAlbum.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbum.h"
#import "FASFileManager.h"

@implementation FASAlbum

- (id)initWithFBObject:(FBGraphObject*)fb
{
    self = [super init];
    if (self) {
        self.fbObject = fb;
    }
    
    self.photos = [NSMutableArray new];
    return self;
}

-(BOOL)updateCacheStatus
{
    FASAlbumCacheStatus status;
    if([self.photos count]== 0)
    {
        status = FASAlbumCacheStatusLoading;
    }
    else
    {
        BOOL flag = YES;
        FASFileManager *fileManager = [FASFileManager sharedManager];
        [fileManager setAlbum:self.albumId];
        
        for (FASPhoto* photo in self.photos) {
            if ([photo isCached]!= YES)
                flag = NO;
        }
        
        if(flag == YES)
            status = FASAlbumCacheStatusCached;
        else
            status = FASAlbumCacheStatusNotCached;
    }
    if (status == self.cacheStatus) {
        return NO;
    }
    else
    {
        self.cacheStatus = status;
        return YES;
    }
}

@end
