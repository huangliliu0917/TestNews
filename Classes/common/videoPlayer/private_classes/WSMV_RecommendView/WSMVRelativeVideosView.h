//
//  WSMVRelativeVideosView.h
//  sohunews
//
//  Created by handy wang on 10/26/13.
//  Copyright (c) 2013 Sohu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNVideoData;

@interface WSMVRelativeVideosThumbnailWillPlayIndicator : UIView
@end

@interface WSMVRelativeVideoThumbnailView : UIControl
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface WSMVRelativeVideosView : UIView<UIScrollViewDelegate>
@property (nonatomic, weak)id delegate;
@property (nonatomic, strong)NSMutableArray *relativeVideos;

- (void)appendRelativeVideos:(NSArray *)relativeVideos;
- (void)replaceAllRelativeVieos:(NSArray *)videos;
- (void)willPlayVideoAfter:(SNVideoData *)video;
- (void)resetWillPlayThumbnailUI;
- (BOOL)isInFirstPage;
@end

@protocol WSMVRelativeVideosViewDelegate
- (void)didTapRelativeVideo:(SNVideoData *)relativeVideo;
- (void)didScrollRelativeVideosView;
@end
