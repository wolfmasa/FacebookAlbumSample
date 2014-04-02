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
