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
            ret = NO;;
    }
    
    return ret;
}

@end
