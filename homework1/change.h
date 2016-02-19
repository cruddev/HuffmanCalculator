//
//  change.h
//  homework1
//
//  Created by 余玺 on 15/6/15.
//  Copyright (c) 2015年 yx. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ViewController.h"
@interface change:UIViewController
+ (UIImage *) grayscaleImage:(UIImage *) image;
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
