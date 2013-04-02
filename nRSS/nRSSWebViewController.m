//
//  nRSSWebViewController.m
//  nRSS
//
//  Created by Nico Naegele on 4/1/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "nRSSWebViewController.h"

@interface nRSSWebViewController ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation nRSSWebViewController

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO];
//    NSURL* url = [NSURL URLWithString:self.entry[@"url"]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
	// Do any additional setup after loading the view.
}

- (void)loadView
{
    self.view = self.webView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareWebViewForFeedEntry:(NSDictionary *)feedEntry
{
    self.entry = feedEntry;
    NSURL* url = [NSURL URLWithString:self.entry[@"url"]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

- (IBAction)loadNextEntry:(id)sender {
}

- (IBAction)loadPreviousEntry:(id)sender {
}
@end
