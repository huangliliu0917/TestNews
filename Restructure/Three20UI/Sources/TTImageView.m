//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTImageView.h"

// UI
#import "TTImageViewDelegate.h"

// UI (private)
#import "TTImageLayer.h"
#import "TTImageViewInternal.h"

// Style
//#import "Three20Style/TTShape.h"
//#import "Three20Style/TTStyleContext.h"
//#import "Three20Style/TTContentStyle.h"
//#import "Three20Style/UIImageAdditions.h"

// Network
#import "TTURLCache.h"
#import "TTURLImageResponse.h"
#import "TTURLRequest.h"

#import "TTNetworkMode.h"

static BOOL gWebpEabled;
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTImageView

@synthesize urlPath             = _urlPath;
@synthesize image               = _image;
@synthesize defaultImage        = _defaultImage;
@synthesize autoresizesToImage  = _autoresizesToImage;
@synthesize request				= _request;

@synthesize delegate = _delegate;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
      self = [super initWithFrame:frame];
      if (self) {
          _autoresizesToImage = NO;
          _maskView=[[UIImageView alloc] initWithFrame:self.bounds];
          _maskView.backgroundColor=[UIColor clearColor];
      }
      return self;
}

// fix 默认图 重影 by jojo
//- (void)setContentMode:(UIViewContentMode)contentMode {
//    [super setContentMode:contentMode];
//    _maskView.contentMode = contentMode;
//}
//
//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    _maskView.frame = self.bounds;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  _delegate = nil;
  [_request cancel];
  TT_RELEASE_SAFELY(_request);
  TT_RELEASE_SAFELY(_urlPath);
  TT_RELEASE_SAFELY(_image);
  TT_RELEASE_SAFELY(_defaultImage);
    TT_RELEASE_SAFELY(_maskView);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (Class)layerClass {
  return [TTImageLayer class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
//  if (self.style) {
    [super drawRect:rect];
//  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawContent:(CGRect)rect {
  if (nil != _image) {
//    [_image drawInRect:rect contentMode:self.contentMode];
      [_image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
  } else {
//    [_defaultImage drawInRect:rect contentMode:self.contentMode];
      [_image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request {
  [_request release];
  _request = [request retain];

  [self imageViewDidStartLoad];
  if ([_delegate respondsToSelector:@selector(imageViewDidStartLoad:)]) {
    [_delegate imageViewDidStartLoad:self];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLImageResponse* response = request.response;
  [self setImage:response.image];
  TT_RELEASE_SAFELY(_request);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  TT_RELEASE_SAFELY(_request);

  [self imageViewDidFailLoadWithError:error];
  if ([_delegate respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
    [_delegate imageView:self didFailLoadWithError:error];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidCancelLoad:(TTURLRequest*)request {
  TT_RELEASE_SAFELY(_request);

  [self imageViewDidFailLoadWithError:nil];
  if ([_delegate respondsToSelector:@selector(imageView:didFailLoadWithError:)]) {
    [_delegate imageView:self didFailLoadWithError:nil];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTStyleDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)drawLayer:(TTStyleContext*)context withStyle:(TTStyle*)style {
//  if ([style isKindOfClass:[TTContentStyle class]]) {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(ctx);
//
//    CGRect rect = context.frame;
//    [context.shape addToPath:rect];
//    CGContextClip(ctx);
//
//    [self drawContent:rect];
//
//    CGContextRestoreGState(ctx);
//  }
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
  return !!_request;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
  return nil != _image && _image != _defaultImage;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {
  if (nil == _request && nil != _urlPath) {
    UIImage* image = [[TTURLCache sharedCache] imageForURL:_urlPath];

    if (nil != image) {
      self.image = image;

    } else {
      TTURLRequest* request = [TTURLRequest requestWithURL:_urlPath delegate:self];
      if (gWebpEabled && ![[request headers] objectForKey:@"Accept"]) {
          [request setValue:@"image/webp,image/*;q=0.8" forHTTPHeaderField:@"Accept"];
      }
      request.response = [[[TTURLImageResponse alloc] init] autorelease];
      // Give the delegate one chance to configure the requester.
      if ([_delegate respondsToSelector:@selector(imageView:willSendARequest:)]) {
    	  [_delegate imageView:self willSendARequest:request];
      }

      if (![request send]) {
        // Put the default image in place while waiting for the request to load
        if (_defaultImage && nil == self.image) {
          self.image = _defaultImage;
        }
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopLoading {
  [_request cancel];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidStartLoad {
    if (self.image) {
        _maskView.image=self.image;
    }
    // 暂时把渐变效果去掉了 by jojo
//    [self addSubview:_maskView];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidLoadImage:(UIImage*)image {
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:.1f];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidFailLoadWithError:(NSError*)error {
    [_maskView removeFromSuperview];
    _maskView.alpha=1.0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dismiss
{
    [UIView beginAnimations:@"dismiss" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    _maskView.alpha=0.0f;
    [UIView commitAnimations];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_maskView removeFromSuperview];
    _maskView.alpha=1.0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unsetImage {
  [self stopLoading];
  self.image = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDefaultImage:(UIImage*)theDefaultImage {
  if (_defaultImage != theDefaultImage) {
    [_defaultImage release];
    _defaultImage = [theDefaultImage retain];
  }
  if (nil == _urlPath || 0 == _urlPath.length) {
    //no url path set yet, so use it as the current image
    self.image = _defaultImage;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUrlPath:(NSString*)urlPath {
  // Check for no changes.
    if ([TTImageView isWebpEnabled]) {
        BOOL hasWebP = ([urlPath hasPrefix:@"http://cache.k.sohu.com/img7/"] || [urlPath hasPrefix:@"http://cache.k.sohu.com/img8/"] || [urlPath hasPrefix:@"https://cache.k.sohu.com/img7/"] || [urlPath hasPrefix:@"https://cache.k.sohu.com/img8/"]);
        
        if ([TTNetworkMode isWWANmode]) {
            if (hasWebP) {
                urlPath = [urlPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".webp"];
            }
        } else {
            if (hasWebP) {
                urlPath = [urlPath stringByReplacingOccurrencesOfString:@".webp" withString:@".jpg"];
            }
        }
    }

  if (nil != _image && nil != _urlPath && [urlPath isEqualToString:_urlPath]) {
    return;
  }

  [self stopLoading];

  {
    NSString* urlPathCopy = [urlPath copy];
    [_urlPath release];
    _urlPath = urlPathCopy;
  }

  if (nil == _urlPath || 0 == _urlPath.length) {
    // Setting the url path to an empty/nil path, so let's restore the default image.
    self.image = _defaultImage;

  } else {
    [self reload];
  }
}

+ (void)setWebpEnabled:(BOOL)bEnable {
    gWebpEabled = bEnable;
}

+ (BOOL)isWebpEnabled {
    return gWebpEabled;
}

@end