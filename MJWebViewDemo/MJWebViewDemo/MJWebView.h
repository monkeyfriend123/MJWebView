//
//  MJWebView.h
//  1112
//
//  Created by js on 15/7/31.
//  Copyright (c) 2015年 js. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJWebViewDelegate <UIWebViewDelegate>

@end

IB_DESIGNABLE
@interface MJWebView : UIView

/** 初始化方法 */
- (instancetype)initWithURL:(NSString *)url;

//正在请求的URL
@property (nonatomic, copy) IBInspectable NSString *url;

/** 转发uiwebview 的代理方法 */
@property (nonatomic,weak) IBOutlet id<MJWebViewDelegate> forwardTarget;


@end
