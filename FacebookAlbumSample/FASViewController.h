//
//  FASViewController.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/08.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FASViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *albumGetButton;
- (IBAction)getAlbumList:(id)sender;

@end
