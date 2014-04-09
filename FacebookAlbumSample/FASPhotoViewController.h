//
//  FASPhotoViewController.h
//  FacebookAlbumSample
//
//  Created by J.Masa on 2014/03/21.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASPhoto.h"

@interface FASPhotoViewController : UIViewController

//UI Controll
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) FASPhoto* photo;

- (IBAction)pushSave:(id)sender;
- (IBAction)pushPrev:(id)sender;
- (IBAction)pushNext:(id)sender;
@end
