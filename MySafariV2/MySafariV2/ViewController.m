//
//  ViewController.m
//  MySafariV2
//
//  Created by I-Horng Huang on 23/07/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate,UITabBarDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITextField *myURLTextField;
@property (weak, nonatomic) IBOutlet UIView *viewWithButtons;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *pageTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinning;
@property (weak, nonatomic) NSURL *url;
@property (weak, nonatomic) NSString *displayURL;

@property CGFloat originalY;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkButtonEnable];
    self.myWebView.scrollView.delegate = self;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.originalY = self.myWebView.scrollView.contentOffset.y;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.myWebView.scrollView.contentOffset.y;
    CGFloat offset = self.originalY - yOffset;

    if (offset > 0) {
        //up appear
        NSLog(@"UP IS %f",offset);
        self.myURLTextField.alpha = 1;
        self.viewWithButtons.alpha = 1;

    }else{
        //down disapear
        NSLog(@"DOWN IS %f",offset);
        self.myURLTextField.alpha = 0;
        self.viewWithButtons.alpha = 0;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self checkButtonEnable];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.displayURL = [self.url absoluteString];
    self.myURLTextField.text = self.displayURL;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.spinning startAnimating];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self checkButtonEnable];
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.pageTitle.title = title;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.spinning stopAnimating];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkButtonEnable];
    NSString *urlString = self.myURLTextField.text;
    if([[urlString substringToIndex:7]  isEqualToString: @"http://"]){
        self.url = [NSURL URLWithString:urlString];
    } else {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",urlString]];
    }
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [self.myWebView loadRequest:urlRequest];
    [textField resignFirstResponder];
    return YES;
}

- (void)checkButtonEnable {
    self.backButton.enabled = self.myWebView.canGoBack;
    self.forwardButton.enabled = self.myWebView.canGoForward;
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self.myWebView goBack];
    [self checkButtonEnable];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.myWebView goForward];
    [self checkButtonEnable];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.myWebView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.myWebView reload];
}
- (IBAction)newFeatureButtonPressed:(id)sender {
    UIAlertView *newFeatureAlert = [[UIAlertView alloc]init];
    newFeatureAlert.title = @"New Feature";
    newFeatureAlert.message = @"coming soon...";
    newFeatureAlert.delegate = self;
    [newFeatureAlert addButtonWithTitle:@"OK"];
    [newFeatureAlert show];
}

@end
