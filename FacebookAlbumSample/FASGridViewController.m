//
//  FASGridViewController.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/06/10.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASGridViewController.h"

@interface FASGridViewController ()

@end

@implementation FASGridViewController

/**
-(void)loadPicture
{
    FASDataManager *manager = [FASDataManager sharedManager];
    FASAlbum* album = [manager getActiveAlbum];
    for (NSObject* obj in album.photos) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:album.photos[index]];
    }
    
}
 **/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate:self];
    [self reloadData];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSUInteger)numberOfViews
{
    FASDataManager *manager = [FASDataManager sharedManager];
    FASAlbum* album = [manager getActiveAlbum];
    
    return [album.photos count];
}

-(NSUInteger)maximumViewsPerCell
{
    return 3;
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo *)rowInfo
{
    FASDataManager *manager = [FASDataManager sharedManager];
    FASAlbum* album = [manager getActiveAlbum];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:album.photos[index]];
    return imageView;
}

- (CGFloat)rowHeightForRowInfo:(BDRowInfo *)rowInfo
{
    //    if (rowInfo.viewsPerCell == 1) {
    //        return 125  + (arc4random() % 55);
    //    }else {
    //        return 100;
    //    }
    return 55 + (arc4random() % 125);
}

/**
- (void)_demoAsyncDataLoading
{
    _items = [NSArray array];
    //load the placeholder image
    for (int i=0; i < kNumberOfPhotos; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake(0, 0, 44, 44);
        imageView.clipsToBounds = YES;
        _items = [_items arrayByAddingObject:imageView];
    }
    [self reloadData];
    NSArray *images = [self _imagesFromBundle];
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [_items objectAtIndex:i];
        UIImage *image = [images objectAtIndex:i];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        [self performSelector:@selector(animateUpdate:)
                   withObject:[NSArray arrayWithObjects:imageView, image, nil]
                   afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];
    }
}
 **/

@end
