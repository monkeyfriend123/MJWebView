//
//  MJWebView.m
//  1112
//
//  Created by js on 15/7/31.
//  Copyright (c) 2015年 js. All rights reserved.
//

#import "MJWebView.h"

@interface MJWebView ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) CGFloat defaultY;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSURL *requestURL;
@end

@implementation MJWebView

- (instancetype)initWithCoder:(nonnull NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithURL:(NSString *)url{
    if (self = [super init]) {
        [self commonInit];
        self.url = url;
        
    }
    return self;
}


#pragma mark - Init

- (void)initView{
    _webView = [[UIWebView alloc] initWithFrame:self.bounds];
    _webView.delegate = self;
    [self addSubview:_webView];

}

- (void)commonInit{
    [self initView];

}

- (void)loadRequestURL:(NSString *)urlString{
    if (urlString.length == 0) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:URLRequest];
    
    self.requestURL = URL;
}

- (void)setUrl:(NSString *)url{
    _url = url;
    [self loadRequestURL:_url];
}

#pragma mark - LayoutView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //更新大小
    self.webView.frame = self.bounds;
    
    [self layoutTextIfneeded];
}


- (void)layoutTextIfneeded{
    
    if (self.textLabel == nil) {
        
        self.defaultY = 220;
        
        for (UIView *subView in self.webView.subviews){
            
            if ([subView isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)subView;
                scrollView.delegate = self;
                scrollView.backgroundColor = [UIColor clearColor];
                
                CGFloat insetTop = scrollView.contentInset.top;
                self.defaultY += insetTop;
                CGFloat width = CGRectGetWidth(self.bounds);
                //再最下面一层添加显示视图
                UIView *containerView = [subView.subviews firstObject];
                UIView *textContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,-200, width, 220)];
                [containerView insertSubview:textContainerView atIndex:0];
                
                //显示文字label
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.defaultY, width, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                [textContainerView addSubview:label];
                self.textLabel = label;
            }
            
        }
    }
    
    self.textLabel.text = self.requestURL.host;

}

#pragma mark - Delegate

//随着界面的滚动，移动label 的y坐标，实现一直固定在某处的效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect frame = self.textLabel.frame;
    
    self.textLabel.frame = (CGRect){CGPointMake(0,self.defaultY + offsetY),frame.size};
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.requestURL = webView.request.URL;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if ([self.forwardTarget respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.forwardTarget webViewDidFinishLoad:self.webView];
    }
}

#pragma mark - Method Forwarding
// for future UIWebViewDelegate impl

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ( [super respondsToSelector:aSelector] )
        return YES;
    
    if ([self.forwardTarget respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([_forwardTarget respondsToSelector:selector]) {
            return [(NSObject *)_forwardTarget methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_forwardTarget respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_forwardTarget];
    }
}

@end
