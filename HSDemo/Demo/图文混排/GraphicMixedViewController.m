//
//  GraphicMixedViewController.m
//  Demo
//
//  Created by whs on 2020/12/3.
//  Copyright © 2020 whs. All rights reserved.
//

#import "GraphicMixedViewController.h"
#import "GraphicMixedView.h"
#import "YYText.h"

@interface GraphicMixedViewController ()

@property(nonatomic, strong)YYLabel *tokenLabel;

@end

@implementation GraphicMixedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tokenLabel];
}



- (YYLabel *)tokenLabel {
    if (!_tokenLabel) {
        _tokenLabel = [YYLabel new];
        _tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 30);
        _tokenLabel.numberOfLines = 0;
        _tokenLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.75];
        [self addSeeMoreButtonInLabel:_tokenLabel];
        
    }
    
    return _tokenLabel;
}
 
- (void)addSeeMoreButtonInLabel:(YYLabel *)label {
    
    UIFont *font16 = [UIFont systemFontOfSize:16];
    label.attributedText = [[NSAttributedString alloc] initWithString:@"我们可以使收起 我们可以使用以下方式来舒服舒服舒服舒服指定切断文本" attributes:@{NSFontAttributeName : font16}];
 
//    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//    attach.image =[UIImage imageNamed:@"001"]; //设置图片
//    attach.bounds = CGRectMake(0, 0, 8, 8); //设置图片大小、位置
//    NSAttributedString *str2 = [NSAttributedString attributedStringWithAttachment:attach];

    NSString *moreString = @" 展开";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... %@", moreString]];
    //[text appendAttributedString:str2];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    UIImage *image = [UIImage imageNamed:@"night-shou-arrow_icon"];
    iv.image = image;
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:iv contentMode:UIViewContentModeCenter attachmentSize:iv.frame.size alignToFont:font16 alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:attachText];

    NSRange expandRange = [text.string rangeOfString:moreString];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:expandRange];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(0, expandRange.location)];
    
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:moreString]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        [weakSelf setFrame:YES];
    };
    
    text.yy_font = font16;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentTop];
    
    label.truncationToken = truncationToken;
}
 
- (NSAttributedString *)appendAttriStringWithFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
//    if ([_tokenLabel.attributedText.string containsString:@"收起"]) {
//        return [[NSAttributedString alloc] initWithString:@""];
//    }
 
    
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append yy_setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击收起
        [weakSelf setFrame:NO];
    };
    
    return append;
}
 
- (void)expandString {
    NSMutableAttributedString *attri = [_tokenLabel.attributedText mutableCopy];
    [attri appendAttributedString:[self appendAttriStringWithFont:attri.yy_font]];
    _tokenLabel.attributedText = attri;
}
 
- (void)packUpString {
    NSString *appendText = @"... 收起 ";
    NSMutableAttributedString *attri = [_tokenLabel.attributedText mutableCopy];
    NSRange range = [attri.string rangeOfString:appendText options:NSBackwardsSearch];
 
    if (range.location != NSNotFound) {
        [attri deleteCharactersInRange:range];
    }
 
    _tokenLabel.attributedText = attri;
}
 
 
- (void)setFrame:(BOOL)isExpand {
    if (isExpand) {
        [self expandString];
        self.tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200);
    }
    else {
        [self packUpString];
        self.tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 30);
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

