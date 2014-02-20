//
//  FASAlbum.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbum.h"

@implementation FASAlbum

- (id)initWithFBObject:(FBGraphObject*)fb
{
    self = [super init];
    if (self) {
        self.fbObject = fb;
    }
    return self;
}

@end
