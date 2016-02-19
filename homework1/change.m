//
//  change.m
//  homework1
//
//  Created by 余玺 on 15/6/15.
//  Copyright (c) 2015年 yx. All rights reserved.
//
#import "change.h"

@implementation change
+ (UIImage *)grayscaleImage:(UIImage *) image
{
    CGSize size = image.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width,
                             image.size.height);
    // Create a mono/gray color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, size.width,
                                                 size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    // Draw the image into the grayscale context
    CGContextDrawImage(context, rect, [image CGImage]);
    CGImageRef grayscale = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    // Recover the image
    UIImage *img = [UIImage imageWithCGImage:grayscale];
    CFRelease(grayscale);
    return img;
}
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
