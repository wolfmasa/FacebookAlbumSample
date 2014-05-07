//
//  FASAlbum.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbum.h"
#import "FASPhoto.h"
#import "FASFileManager.h"
#import "FASFacebookConnection.h"

@implementation FASAlbum

- (id)init
{
    self = [super init];
    
    self.photos = [NSMutableArray new];
    return self;
}

-(BOOL)updateCacheStatus
{
    FASAlbumCacheStatus status;
    if([self.photos count]== 0)
    {
        FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
        if(fb != nil) status = FASAlbumCacheStatusLoading;
        else status = FASAlbumCacheStatusDisConnection;
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

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@(%@)->%lu photos", self.name, self.albumId, (unsigned long)[self.photos count]];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _name = [decoder decodeObjectForKey:@"name"];
        _albumId = [decoder decodeObjectForKey:@"albumId"];
        self.photos = [decoder decodeObjectForKey:@"photos"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.albumId forKey:@"albumId"];
    [encoder encodeObject:self.photos forKey:@"photos"];
}

@end
