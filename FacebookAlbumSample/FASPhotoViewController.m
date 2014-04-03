//
//  FASPhotoViewController.m
//  FacebookAlbumSample
//
//  Created by J.Masa on 2014/03/21.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASPhotoViewController.h"

@interface FASPhotoViewController ()

@end

@implementation FASPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUiImage
{
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    [fb getFullImage:self.photo];
    NSLog(@"%fx%f", self.photo.image.size.width, self.photo.image.size.height);
    [self.imageView setImage:self.photo.image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUiImage];
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

- (IBAction)pushSave:(id)sender {
    //画像保存完了時のセレクタ指定
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    //画像を保存する
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, selector, NULL);
}

//画像保存完了時のセレクタ
- (void)onCompleteCapture:(UIImage *)screenImage
 didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"画像を保存しました";
    if (error) message = @"画像の保存に失敗しました";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                    message: message
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


- (IBAction)pushPrev:(id)sender {
    if(self.dataManager.activePhotoIndex >0)
    {
        [self.dataManager setActivePhotoIndex:self.dataManager.activePhotoIndex-1];
        self.photo = [self.dataManager getActivePhoto];
        [self setUiImage];
    }
}

- (IBAction)pushNext:(id)sender {
    FASAlbum* album = [self.dataManager getActiveAlbum];
    if(self.dataManager.activePhotoIndex < [album.photos count]-1)
    {
        [self.dataManager setActivePhotoIndex:self.dataManager.activePhotoIndex+1];
        self.photo = [self.dataManager getActivePhoto];
        [self setUiImage];
    }
}
@end
