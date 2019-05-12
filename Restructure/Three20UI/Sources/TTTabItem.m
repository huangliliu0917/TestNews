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

#import "TTTabItem.h"

// Core
#import "TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTabItem

@synthesize title       = _title;
@synthesize icon        = _icon;
@synthesize object      = _object;
@synthesize badgeNumber = _badgeNumber;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTitle:(NSString*)title {
	self = [self init];
  if (self) {
    self.title = title;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_title);
  TT_RELEASE_SAFELY(_icon);
  TT_RELEASE_SAFELY(_object);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTabBar:(TTTabBar*)tabBar {
  _tabBar = tabBar;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBadgeNumber:(int)value {
  value = value < 0 ? 0 : value;
  _badgeNumber = value;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  [_tabBar performSelector:@selector(tabItem:badgeNumberChangedTo:) withObject:self
                withObject:[NSNumber numberWithInt:value]];
#pragma clang diagnostic pop
}


@end
