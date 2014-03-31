//
//  FASAlbumThumbnailView.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASAlbum.h"
#import "FASDataManager.h"
#import "FASFacebookConnection.h"

@interface FASAlbumThumbnailView : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollection;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (retain)FASDataManager *dataManager;
@property (retain)FASFacebookConnection *fb;

@end
