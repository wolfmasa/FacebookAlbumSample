//
//  FASPhotoViewController.m
//  FacebookAlbumSample
//
//  Created by J.Masa on 2014/03/21.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASPhotoViewController.h"
#import "FASFileManager.h"
#import "FASFacebookConnection.h"
#import "FASDataManager.h"

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
    if(self.photo.image == nil)
    {
        FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
        if(fb!=nil) [fb getFullImage:self.photo];
    }
    //NSLog(@"%fx%f", self.photo.image.size.width, self.photo.image.size.height);
    [self.imageView setImage:self.photo.image];
   
    FASFileManager* fileManager = [FASFileManager sharedManager];
    
    [fileManager savePhoto:self.photo.graphId image:self.photo.image];
    [self updateButtonStatus];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUiImage];
    
    
    [self.nextButton setImage:[UIImage imageNamed:@"arrow-right-blue.png"] forState:UIControlStateNormal];
    [self.prevButton setImage:[UIImage imageNamed:@"arrow-left-blue.png"] forState:UIControlStateNormal];
    [self.saveButton setImage:[UIImage imageNamed:@"downloading-blue.png"] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"arrow-right-gray.png"] forState:UIControlStateDisabled];
    [self.prevButton setImage:[UIImage imageNamed:@"arrow-left-gray.png"] forState:UIControlStateDisabled];
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

-(void)updateButtonStatus
{
    FASDataManager *dataManager = [FASDataManager sharedManager];
    [self.prevButton setEnabled:(dataManager.activePhotoIndex>0)];
    [self.nextButton setEnabled:(dataManager.activePhotoIndex < [[dataManager getActiveAlbum].photos count]-1)];
}

- (IBAction)pushPrev:(id)sender {
    FASDataManager *dataManager = [FASDataManager sharedManager];
    if(dataManager.activePhotoIndex >0)
    {
        [dataManager setActivePhotoIndex:dataManager.activePhotoIndex-1];
        self.photo = [dataManager getActivePhoto];
        [self setUiImage];
    }
}

- (IBAction)pushNext:(id)sender {
    FASDataManager *dataManager = [FASDataManager sharedManager];
    FASAlbum* album = [dataManager getActiveAlbum];
    if(dataManager.activePhotoIndex < [album.photos count]-1)
    {
        [dataManager setActivePhotoIndex:dataManager.activePhotoIndex+1];
        self.photo = [dataManager getActivePhoto];
        [self setUiImage];
    }
}
@end
