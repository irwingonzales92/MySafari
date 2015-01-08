//
//  ViewController.m
//  MySafari
//
//  Created by Irwin Gonzales on 1/7/15.
//  Copyright (c) 2015 Irwin Gonzales. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UINavigationItem *superCoolNavigationItem;

@property (nonatomic) CGFloat lastContentOffset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *addressString = @"http://9gag.com";
    NSURL *addressURL = [NSURL URLWithString:addressString];
    NSURLRequest *addressRequest = [NSURLRequest requestWithURL:addressURL];
    [self.webView loadRequest:addressRequest];
    self.webView.scrollView.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *newAddressString = [[NSString alloc]init];
    
    if ([textField.text rangeOfString:@"http://"].location == NSNotFound)
    {
        newAddressString = [NSString stringWithFormat:@"http://%@", textField.text];
    }
    else
    {
        newAddressString = textField.text;
    }
    
    NSURL *addressURL = [NSURL URLWithString:newAddressString];
    NSURLRequest *addressRequest = [NSURLRequest requestWithURL:addressURL];
    [self.webView loadRequest:addressRequest];
    return true;
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
    self.spinner.hidden = false;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    self.spinner.hidden = true;

    NSString *currentWebsiteTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.superCoolNavigationItem.title = currentWebsiteTitle;

    self.urlTextField.text = [[self.webView.request URL]absoluteString];
}

- (IBAction)backButtonPressed:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)onForwardButtonPressed:(id)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}


- (IBAction)onStopLoadingButtonPressed:(id)sender
{
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender
{
    [self.webView reload];
}

- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Coming Soon";
    [alertView addButtonWithTitle:@"Dismiss"];
    [alertView show];
}

// stuff not working yet
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastContentOffset > scrollView.contentOffset.y)
    {
        self.urlTextField.hidden = false;
    }
    else if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        self.urlTextField.hidden = true;
    }

    self.lastContentOffset = scrollView.contentOffset.x;
}

@end
