//
//  nRSSWebViewController.h
//  nRSS
//
//  Created by Nico Naegele on 4/1/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nRSSWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) NSDictionary* entry;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
- (IBAction)loadNextEntry:(id)sender;
- (IBAction)loadPreviousEntry:(id)sender;

- (void)prepareWebViewForFeedEntry:(NSDictionary*)feedEntry;
@end
