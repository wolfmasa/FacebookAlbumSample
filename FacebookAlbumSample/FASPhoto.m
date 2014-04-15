//
//  FASPhoto.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASPhoto.h"
#import "FASFileManager.h"

@implementation FASPhoto

-(BOOL)isCached
{
    BOOL ret = YES;
    if(self.image == nil)
    {
        FASFileManager *fileManager = [FASFileManager sharedManager];
        self.image = [fileManager getPhotoWithPath:self.graphId];
        if(self.image==nil)
            ret = NO;
    }
    
    return ret;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"photo id:%p(thumb:%@, full:%@)", self.graphId, self.thumbnailUrl, self.imageUrl];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.graphId = [decoder decodeObjectForKey:@"graphId"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.thumbnail = [decoder decodeObjectForKey:@"thumbnail"];
        self.thumbnailUrl = [decoder decodeObjectForKey:@"thumbnailUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.graphId forKey:@"graphId"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [encoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
}

@end
