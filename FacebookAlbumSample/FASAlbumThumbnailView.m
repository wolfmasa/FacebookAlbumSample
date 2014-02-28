//
//  FASAlbumThumbnailView.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbumThumbnailView.h"

@implementation FASAlbumThumbnailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.thumbnailCollection.delegate = self.delegateTemp;
    self.thumbnailCollection.dataSource = self.delegateTemp;
    [self.thumbnailCollection reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
