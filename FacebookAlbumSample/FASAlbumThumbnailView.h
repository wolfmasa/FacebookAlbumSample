//
//  FASAlbumThumbnailView.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASAlbum.h"

@interface FASAlbumThumbnailView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, retain)FASAlbum *album;

@property(nonatomic, retain)NSMutableArray *images;//UIImages
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollection;

@end
