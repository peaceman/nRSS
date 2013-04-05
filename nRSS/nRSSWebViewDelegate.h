//
//  nRSSWebViewDelegate.h
//  nRSS
//
//  Created by Nico Naegele on 4/3/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol nRSSWebViewDelegate <NSObject>
- (BOOL)webViewCanLoadPreviousEntry;
- (BOOL)webViewCanLoadNextEntry;

- (void)webViewWillLoadPreviousEntry;
- (void)webViewWillLoadNextEntry;
@end
