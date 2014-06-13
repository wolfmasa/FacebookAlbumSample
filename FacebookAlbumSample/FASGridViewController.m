//
//  FASGridViewController.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/06/10.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASGridViewController.h"

#import "BDDynamicGridCell.h"
#import "BDRowInfo.h"

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
    _images = [NSMutableArray new];
    
    FASDataManager* manager = [FASDataManager sharedManager];
    FASAlbum* album = [manager getActiveAlbum];
    
    for (FASPhoto* p in album.photos ) {
        //UIImage * image = [self clipImage:p.image resize:CGSizeMake(100., 100.)];
        UIImage *image = p.image;
        
        UIImageView *iv = [[UIImageView alloc]initWithImage:image];
        [_images addObject:iv];
    }
    [self _demoAsyncDataLoading];
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
    return [_images count];
}

-(NSUInteger)maximumViewsPerCell
{
    return 5;
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo *)rowInfo
{
    return _images[index];
}

- (CGFloat)rowHeightForRowInfo:(BDRowInfo *)rowInfo
{
    //    if (rowInfo.viewsPerCell == 1) {
    //        return 125  + (arc4random() % 55);
    //    }else {
    //        return 100;
    //    }
    return 55 + (arc4random() % 125);
    //return 100;
}

- (void) animateUpdate:(NSArray*)objects
{
    UIImageView *imageView = [objects objectAtIndex:0];
    UIImage* image = [objects objectAtIndex:1];
    [UIView animateWithDuration:0.5
                     animations:^{
                         imageView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         imageView.image = image;
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              imageView.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              NSArray *visibleRowInfos =  [self visibleRowInfos];
                                              for (BDRowInfo *rowInfo in visibleRowInfos) {
                                                  [self updateLayoutWithRow:rowInfo animiated:YES];
                                              }
                                          }];
                     }];
}

- (void)_demoAsyncDataLoading
{

     _items = [NSArray array];
     //load the placeholder image
     for (int i=0; i < _images.count; i++) {
     UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
     imageView.frame = CGRectMake(0, 0, 44, 44);
     imageView.clipsToBounds = YES;
     _items = [_items arrayByAddingObject:imageView];
     }
    
    [self reloadData];
    
    for (int i = 0; i < [_images count]; i++) {
        UIImageView *imageView = _images[i];
        UIImage *image = imageView.image;
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        NSLog(@"%.2fx%.2f", image.size.width, image.size.height);
        
        [self performSelector:@selector(animateUpdate:)
                   withObject:[NSArray arrayWithObjects:imageView, image, nil]
                   afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];
    }
}


-(UIImage *) clipImage:(UIImage *)original resize:(CGSize)resize
{
    
    // リサイズ画像のx,y,width,heightを算出
    float resized_x = 0.0;
    float resized_y = 0.0;
    float resized_width = resize.width;
    float resized_height = resize.height;
    
    // 縦横それぞれの「倍率」を算出し、より大きな倍率（＝大きな画像）を採用する。
    float ratio_width = resize.width/original.size.width;
    float ratio_height = resize.height/original.size.height;
    if( ratio_width < ratio_height ){
        // 縦の倍率採用
        resized_width = original.size.width*ratio_height;
        resized_x = (resize.width-resized_width)/2; // 横ははみ出る
    }else{
        // 横の倍率採用
        resized_height = original.size.height*ratio_width;
        resized_y = (resize.height-resized_height)/2; // 縦ははみ出る
    }
    
    // リサイズとクリップ処理
    CGSize resized_size = CGSizeMake(resize.width ,resize.height);
    UIGraphicsBeginImageContext(resized_size);
    // はみ出してる部分を切り落とす
    [original drawInRect:CGRectMake(resized_x, resized_y, resized_width, resized_height)];
    UIImage* resized_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized_image;
}

@end
