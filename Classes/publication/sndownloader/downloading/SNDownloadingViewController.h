//
//  SNDownloadingViewController.h
//  sohunews
//
//  Created by handy wang on 6/29/12.
//  Copyright (c) 2012 Sohu.com Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNDownloadingViewController : UITableViewController {
    id _delegate;
    UIImageView *_emptyDownloadingBg;
}

- (id)initWithIDelegate:(id)delegateParam;

- (void)enableOrDisableRightBtn;

@end
