//
//  Note.m
//  NoteApp
//
//  Created by iiiedu2 on 2015/6/4.
//  Copyright (c) 2015年 Rossi. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.noteID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (UIImage *)image{
	//檔案路徑
	NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:self.imageName];
	//載入圖檔成UIImage
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	return image;
}

-(UIImage*)thumbnailImage{
	UIImage *image = [self image];
	if ( !image){
		return nil;
	}
	CGSize thumbnailSize = CGSizeMake(50, 50); //設定縮圖大小
	CGFloat scale = [UIScreen mainScreen].scale;
	UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, scale);
	
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
    [circlePath addClip];
    
	//計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
	//最小值MIN會變成UIViewContentModeScaleAspectFit
	CGFloat widthRatio = thumbnailSize.width / image.size.width;
	CGFloat heightRadio = thumbnailSize.height / image.size.height;
	CGFloat ratio = MAX(widthRatio,heightRadio);
	
	CGSize imageSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
	[image drawInRect:CGRectMake(-(imageSize.width-50.0)/2.0, -(imageSize.height-50.0)/2.0,imageSize.width, imageSize.height)];
	
	//取得縮圖
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}
@end
