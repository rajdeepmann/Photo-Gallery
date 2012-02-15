//
//  PhotoScrollingView.h
//  Digikam
//
//  Created by Xebia on 24/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoScrollingViewDelegate
-(void)removedImageAtIndex:(int )aImageIndex;
@end

@interface XEPhotoGalleryView : UIView{
    @private 
    UIButton * nextButton_;
    UIButton * previousButton_;
    int numberOfImages_;
    float imageWidth_;
    float imageHeight_;
    UIScrollView * scrollView_;
    NSMutableArray * images_;
    UILabel * noPhotoLabel_;    
}
@property (retain, nonatomic) id<PhotoScrollingViewDelegate> delegate;
@property (nonatomic) NSInteger numberOfPhotosVisibleToUser;
@property (nonatomic) float widhtPaddingInImages;
@property (nonatomic) float heightPaddingInImages;

-(void)displayImages:(NSArray *)aImageList;
-(void)addImageToScrollView:(UIImage *)aImage;
- (id)initWithFrame:(CGRect)frame andDelegate:(id)aDelegate;

@end
