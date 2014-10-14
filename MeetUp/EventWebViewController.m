//
//  EventWebViewController.m
//  MeetUp
//
//  Created by Adam Cooper on 10/13/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "EventWebViewController.h"

@interface EventWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

@end

@implementation EventWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.eventURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    NSLog(@"%@",url);
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
    if ([self.webView canGoBack]) {
        self.backButton.enabled = YES;
    } else {
        self.backButton.enabled = NO;
    }
}


- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
    if ([self.webView canGoForward]) {
        self.forwardButton.enabled = YES;
    } else {
        self.forwardButton.enabled = NO;
    }
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}




@end
