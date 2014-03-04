//
//  FASDataManager.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASDataManager.h"

@implementation FASDataManager


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FASAlbum* album = (FASAlbum*)[self.albums objectAtIndex:0];
    FASPhoto* photo = [album.photos objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [UICollectionViewCell new];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:photo.thumbnail];
    cell.backgroundView = imageView;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    FASAlbum* album = (FASAlbum*)[self.albums objectAtIndex:0];
    return [album.photos count];
}

@end
