//
//  FASViewController.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/08.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FASViewController : UIViewController<UITableViewDelegate, FBLoginViewDelegate>

@property bool isConnect;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)changeConnect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getAlbumButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;

- (IBAction)clearCache:(id)sender;
@end
