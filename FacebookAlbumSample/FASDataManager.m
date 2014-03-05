//
//  FASDataManager.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASDataManager.h"



@implementation FASDataManager

- (id)init
{
    self = [super init];
    if (self) {
        self.albums = [NSMutableArray new];
    }
    return self;
}

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

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albums count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    FASAlbum *a = (FASAlbum *)[self.albums objectAtIndex:indexPath.row];
    [cell textLabel].text = a.name;
    return cell;
}

@end
