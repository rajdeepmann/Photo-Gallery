//
//  XEViewController.m
//  Xe_PhotoGallery
//
//  Created by Xebia on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XEViewController.h"
@implementation XEViewController
@synthesize addButton;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect viewFrame = self.view.frame;
    galleryView_ = [[XEPhotoGalleryView alloc] initWithFrame:CGRectMake(viewFrame.size.width/8,viewFrame.size.height/2 -50 , viewFrame.size.width* 3/4, 100) andDelegate:self];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [galleryView_ setNumberOfPhotosVisibleToUser:2];
    }
    [self.view addSubview:galleryView_];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)removedImageAtIndex:(int)aImageIndex{
    
}

-(IBAction)addPhoto:(id)sender{

    if ([popOverController_ isPopoverVisible]) {
        [popOverController_ dismissPopoverAnimated:YES];
        return;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    imagePicker_ = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) 
    {
        // Set source to the Photo Library
        imagePicker_.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    imagePicker_.delegate = self;

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentModalViewController:imagePicker_ animated:YES];
    }else{
        popOverController_ = [[UIPopoverController alloc] initWithContentViewController:imagePicker_];
        
        [popOverController_ presentPopoverFromBarButtonItem:addButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

    }
    

    

        
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * imageClicked = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [galleryView_ addImageToScrollView:imageClicked];
    
    [popOverController_ dismissPopoverAnimated:YES];    
    [self dismissModalViewControllerAnimated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [popOverController_ dismissPopoverAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];

}
@end
