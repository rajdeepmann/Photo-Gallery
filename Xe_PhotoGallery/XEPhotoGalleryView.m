//
//  PhotoScrollingView.m
//  Digikam
//
//  Created by Xebia on 24/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XEPhotoGalleryView.h"
#define kNoPhotoAdded @"No photo added"
#define kFontName @"Futura-CondensedMedium"
#define kSystemFont  [UIFont fontWithName:kFontName size:22]
#define kNumberOfImageToDisplay 5
#define kWidthPaddingInImages 10
#define kHeightPaddingInImages 10

@implementation XEPhotoGalleryView
@synthesize delegate;
@synthesize numberOfPhotosVisibleToUser;
@synthesize widhtPaddingInImages;
@synthesize heightPaddingInImages;



#pragma mark - No Photo label

-(void)showNoPhotoAdded{
    if (!noPhotoLabel_) {
        noPhotoLabel_ = [[UILabel alloc] initWithFrame:scrollView_.frame];
        noPhotoLabel_.text = kNoPhotoAdded;
        noPhotoLabel_.font = kSystemFont;
        noPhotoLabel_.textColor = [UIColor whiteColor];
        noPhotoLabel_.textAlignment = UITextAlignmentCenter;
        [noPhotoLabel_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:noPhotoLabel_ ];
    }

}

-(void)removeNoPhotoAdded{
    [noPhotoLabel_ removeFromSuperview];
    noPhotoLabel_ = nil;
}

-(void)configureFramesForGallery{
    float widthAvailable = self.frame.size.width - 2* ( previousButton_.frame.origin.x + 1.5*previousButton_.frame.size.width) - ( self.numberOfPhotosVisibleToUser -1) * self.widhtPaddingInImages;
    CGRect scrollViewRect = CGRectMake(previousButton_.frame.origin.x + 1.5 *previousButton_.frame.size.width, 0, self.frame.size.width - 2* ( previousButton_.frame.origin.x + 1.5*previousButton_.frame.size.width), self.frame.size.height);
    if (scrollView_ != nil) {
        [scrollView_ removeFromSuperview];
        scrollView_ = nil;
    }
    scrollView_ = [[UIScrollView alloc] initWithFrame:scrollViewRect];        
    [self addSubview:scrollView_];
    
    imageWidth_ = widthAvailable / self.numberOfPhotosVisibleToUser ;
    imageHeight_ = ( self.frame.size.height - self.heightPaddingInImages* 2 );
    images_ = [NSMutableArray array];
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)aDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfPhotosVisibleToUser = kNumberOfImageToDisplay;
        self.widhtPaddingInImages = kWidthPaddingInImages;
        self.heightPaddingInImages = kHeightPaddingInImages;
        
        self.delegate = aDelegate;
        //self.autoresizesSubviews = YES;
        
        UIImage * backgroundImage =  [UIImage imageNamed:@"camera_strip"];
        UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [backgroundImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:backgroundImageView];
        
        nextButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * nextButtonImage = [UIImage imageNamed:@"right_arrow"];
        [nextButton_ setBackgroundImage:nextButtonImage forState:UIControlStateNormal];
        [nextButton_ setFrame:CGRectMake(self.frame.size.width - nextButtonImage.size.width*1.5,(self.frame.size.height - nextButtonImage.size.height)/2, nextButtonImage.size.width, nextButtonImage.size.height)];  
        //[nextButton_ addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchDown];        
        [self addSubview:nextButton_];
        
        previousButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * previousButtonImage = [UIImage imageNamed:@"left_arrow"];
        [previousButton_ setBackgroundImage:previousButtonImage forState:UIControlStateNormal];
       //[previousButton_ addTarget:self action:@selector(previousButtonTapped) forControlEvents:UIControlEventTouchDown];
        [previousButton_ setFrame:CGRectMake(previousButtonImage.size.width/2,(self.frame.size.height - previousButtonImage.size.height)/2, previousButtonImage.size.width, previousButtonImage.size.height)];
        [self addSubview:previousButton_];
        
        
        [self configureFramesForGallery];
        [self showNoPhotoAdded];
    }
    return self;
}

-(void)placeImages:(NSArray *)aImageList{
    scrollView_.contentSize =CGSizeZero;
    if ([aImageList count] > 0) {
        [self removeNoPhotoAdded];
    }
    for (int imageNumber =0 ; imageNumber < [aImageList count]; imageNumber ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[aImageList objectAtIndex:imageNumber]];
        imageView.frame = CGRectMake(imageNumber * (imageWidth_ + self.widhtPaddingInImages), self.heightPaddingInImages, imageWidth_, imageHeight_);
        [scrollView_ addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [imageView addGestureRecognizer:longPressGesture];
        CGSize size = scrollView_.contentSize;
        size.width = size.width + imageWidth_ + self.widhtPaddingInImages;
        scrollView_.contentSize = size;
        scrollView_.showsVerticalScrollIndicator = NO;
        scrollView_.showsHorizontalScrollIndicator = NO;

    }
}

-(void)displayImages:(NSArray *)aImageList{
    images_ = [NSMutableArray arrayWithArray:aImageList];
    [self placeImages:images_];
}

-(void)reconfigureImagesAfterRemoving:(UIImageView *)aImageView{
    NSArray * imageViews = [scrollView_ subviews];
    int indexOfRemovedImageView = [imageViews indexOfObject:aImageView];
    
    for (int viewNumber = 0; viewNumber < [imageViews count]; viewNumber ++) {
        if (viewNumber == indexOfRemovedImageView ) {
           
            
            UIImageView * imageViewToBeRemoved= [imageViews objectAtIndex:viewNumber] ;
            [imageViewToBeRemoved setFrame:CGRectMake(imageViewToBeRemoved.frame.size.width/2+imageViewToBeRemoved.frame.origin.x,scrollView_.frame.size.height/2, 0, 0)];                    

        }else if (viewNumber >= indexOfRemovedImageView ){
            CGPoint origin = ((UIImageView *)[imageViews objectAtIndex:viewNumber]).frame.origin;
            origin.x = origin.x - self.widhtPaddingInImages - imageWidth_;
            origin.y = self.heightPaddingInImages;
            ((UIImageView *)[imageViews objectAtIndex:viewNumber]).frame = CGRectMake(origin.x, origin.y, imageWidth_, imageHeight_);
            scrollView_.showsVerticalScrollIndicator = NO;
            scrollView_.showsHorizontalScrollIndicator = NO;
        }
    }
    
    CGSize size = scrollView_.contentSize;
    size.width = size.width - imageWidth_ -self.widhtPaddingInImages;
    scrollView_.contentSize = size;
}

-(void)addImageToScrollView:(UIImage *)aImage{
    [self removeNoPhotoAdded];
    if (images_ == nil) {
        [self displayImages:[NSArray arrayWithObject:aImage]];
    }else{
        [images_ addObject:aImage];

        UIImageView * imageView = [[UIImageView alloc] initWithImage:aImage];
        imageView.frame = CGRectMake(scrollView_.contentSize.width , self.heightPaddingInImages, imageWidth_, imageHeight_);
        [scrollView_ addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [imageView addGestureRecognizer:longPressGesture];
        CGSize size = scrollView_.contentSize;
        size.width = size.width + imageWidth_ + self.widhtPaddingInImages;
        scrollView_.contentSize = size;
        scrollView_.showsVerticalScrollIndicator = NO;
                scrollView_.showsHorizontalScrollIndicator = NO;
    }

}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender { 
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView * imageView = (UIImageView *)sender.view;
        NSArray * imageViews = [scrollView_ subviews];
        int indexOfRemovedImageView = [imageViews indexOfObject:imageView];

        [UIView animateWithDuration:0.75 animations: ^{
            [self reconfigureImagesAfterRemoving:imageView];
        } completion:^(BOOL finished){
            [imageView removeFromSuperview];
            [images_ removeObject:imageView.image];	
            [self.delegate removedImageAtIndex:indexOfRemovedImageView];
            if ([images_ count]==0) {
                [self showNoPhotoAdded];
            }
        }];
    }
}

-(void)nextButtonTapped{
    CGPoint contentOffSet = scrollView_.contentOffset;
    if (scrollView_.contentSize.width - imageWidth_ < scrollView_.frame.size.width) {
        return;
    }else if(contentOffSet.x /imageWidth_ >= [images_ count] - kNumberOfImageToDisplay ){
        
        return;

    }else{
        [scrollView_ setContentOffset:CGPointMake(contentOffSet.x +  imageWidth_, contentOffSet.y) animated:YES];
    }
    
}


-(void)previousButtonTapped{
    CGPoint contentOffSet = scrollView_.contentOffset;
    if (scrollView_.contentSize.width + imageWidth_< scrollView_.frame.size.width) {
        return;
    }else if(contentOffSet.x /imageWidth_ >= [images_ count] - kNumberOfImageToDisplay ){
        
        return;
        
    }
    else {
        
        [scrollView_ setContentOffset:CGPointMake(contentOffSet.x -  imageWidth_, contentOffSet.y) animated:YES];
        
    }   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setNumberOfPhotosVisibleToUser:(NSInteger)aNumberOfPhotosVisibleToUser{
    numberOfPhotosVisibleToUser = aNumberOfPhotosVisibleToUser;
    [self configureFramesForGallery];
}

-(void)setWidhtPaddingInImages:(float)aWidhtPaddingInImages{
    widhtPaddingInImages = aWidhtPaddingInImages;
    [self configureFramesForGallery];
}

-(void)setHeightPaddingInImages:(float)aHeightPaddingInImages{
    heightPaddingInImages = aHeightPaddingInImages;
    [self configureFramesForGallery];
}

@end
