//
//  FASAlbumThumbnailView.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbumThumbnailView.h"
#import "FASPhotoViewController.h"

@implementation FASAlbumThumbnailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.thumbnailCollection.delegate = self.dataManager;
    self.thumbnailCollection.dataSource = self.dataManager;
    [self.thumbnailCollection reloadData];
    
    self.progress.progress = 0;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"showPhoto"])
    {
        NSIndexPath *selectedIndexPath = [[self.thumbnailCollection indexPathsForSelectedItems] objectAtIndex:0];

        [self.dataManager changeActivePhotoIndex:selectedIndexPath.row];
        FASPhoto *photo = [self.dataManager getActivePhoto];
        
        FASPhotoViewController *photoView = [segue destinationViewController];
        photoView.photo = photo;
        
        photoView.dataManager = self.dataManager;
    }
}

@end
