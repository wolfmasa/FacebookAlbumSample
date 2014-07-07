//
//  FASAlbumThumbnailView.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FASAlbumThumbnailView : UIViewController

//UI Controll
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollection;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

//Update Cache status text
-(void)updateCacheStatus;

//SaveButton
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveAlbum:(id)sender;


@end
