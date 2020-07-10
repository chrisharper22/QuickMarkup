#import <RemoteLog.h>

@interface PXUIButton : UIButton
@end

@interface PUPhotoEditButtonCenteredToolbar : UIView
-(void)setCenterView:(id)centerView leadingViews:(id)leadingViews trailingViews:(id)trailingViews;
@end

#define ParentUIViewControllerOfView(__view) ({ \
    UIResponder *__responder = __view; \
    while ([__responder isKindOfClass:[UIView class]]) \
        __responder = [__responder nextResponder]; \
    (UIViewController *)__responder; \
})

@interface PUPhotoEditViewController : UIViewController
@property(readonly, nonatomic) _Bool isStandardVideo;
@property(readonly, nonatomic) _Bool isVideoOn;
@end

%hook PUPhotoEditButtonCenteredToolbar
-(void)setCenterView:(id)centerView leadingViews:(id)leadingViews trailingViews:(id)trailingViews{
	PUPhotoEditViewController *photoEditViewController = (PUPhotoEditViewController *)ParentUIViewControllerOfView(self);
	if (!([photoEditViewController isVideoOn]) || !([photoEditViewController isStandardVideo])) {
		NSMutableArray *newTrailingViews = [trailingViews mutableCopy];
		PXUIButton *markupButton = [%c(PXUIButton) buttonWithType:UIButtonTypeSystem];
		[markupButton setImage:[[UIImage systemImageNamed:@"pencil.tip.crop.circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		[markupButton setTintColor:[UIColor whiteColor]];
		[markupButton setAlpha:0.65];
		[markupButton addTarget:photoEditViewController action:@selector(_startMarkupSession) forControlEvents:UIControlEventTouchUpInside];
		[newTrailingViews insertObject:markupButton atIndex:0];
		%orig(centerView, leadingViews, newTrailingViews);
	} else {
		%orig;
	}
}
%end

@interface PUCropToolController : UIViewController
-(NSArray *)leadingToolbarViews;
-(void)_rotateButtonTapped:(id)arg1;
-(void)_leftRotateButtonTapped:(id)arg1;
@end

%hook PUCropToolController
-(NSArray *)leadingToolbarViews{
	NSArray *leadingViews = %orig;
	NSMutableArray *newLeadingViews = [leadingViews mutableCopy];
	PXUIButton *leftRotateButton = [%c(PXUIButton) buttonWithType:UIButtonTypeSystem];
	[leftRotateButton setImage:[[[UIImage imageNamed:@"PUCropRotate" inBundle:[NSBundle bundleWithPath:@"/System/Library/Frameworks/PhotosUI.framework"] compatibleWithTraitCollection:nil] imageWithHorizontallyFlippedOrientation] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	[leftRotateButton setTintColor:[UIColor whiteColor]];
	[leftRotateButton addTarget:self action:@selector(_leftRotateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[newLeadingViews addObject:leftRotateButton];
	return [NSArray arrayWithArray:newLeadingViews];
}

%new
-(void)_leftRotateButtonTapped:(id)sender{
	[self _rotateButtonTapped:sender];
	[self _rotateButtonTapped:sender];
	[self _rotateButtonTapped:sender];
}
%end