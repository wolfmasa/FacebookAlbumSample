//
//  FASPhotoViewController.h
//  FacebookAlbumSample
//
//  Created by J.Masa on 2014/03/21.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASPhoto.h"
#import "FASFacebookConnection.h"
#import "FASDataManager.h"

@interface FASPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) FASPhoto* photo;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)pushSave:(id)sender;
- (IBAction)pushPrev:(id)sender;
- (IBAction)pushNext:(id)sender;
@end
