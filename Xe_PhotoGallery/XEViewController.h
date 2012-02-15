//
//  XEViewController.h
//  Xe_PhotoGallery
//
//  Created by Xebia on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEPhotoGalleryView.h"

@interface XEViewController : UIViewController<PhotoScrollingViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    @private
    UIPopoverController * popOverController_;
    UIImagePickerController * imagePicker_;
    XEPhotoGalleryView * galleryView_;
}
-(IBAction)addPhoto:(id)sender;
@property (retain) IBOutlet UIBarButtonItem * addButton;
@end
