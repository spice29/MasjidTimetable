#import "NumberPadDoneBtn.h"

@implementation NumberPadDoneBtn {
	
	NumberPadButton *doneBtn;

}

#pragma mark -
#pragma mark Initialization/Deallocation

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:CGRectMake(0, 0, 1, 1)];
	if(!self) return self;
	
	self.clipsToBounds = false;
	doneBtn = [NumberPadButton new];
	doneBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
	[doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(stopEditing) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:doneBtn];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
	
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark View Layouting

- (void) keyboardFrameChanged:(NSNotification*)notification
{
    float height; float width;
	
	if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
		width = CGRectGetWidth([UIScreen mainScreen].bounds);
		height = CGRectGetHeight([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
	} else {
		width = CGRectGetHeight([UIScreen mainScreen].bounds);
		height = CGRectGetWidth([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
	}
	
	float btnHeight = height/4;
	float btnWidth = (width/3)-2;
	doneBtn.frame = CGRectMake(0, (height-btnHeight)+1, btnWidth, btnHeight);
	
	if([self findFirstResponderIn:nil].keyboardAppearance == UIKeyboardAppearanceDark){
		doneBtn.tintColor = [UIColor colorWithRed:97/255.0f green:97/255.0f blue:97/255.0f alpha:1.0f];
		[doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	} else {
		doneBtn.tintColor = [UIColor whiteColor];
		[doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	if(CGRectContainsPoint(doneBtn.frame, point)){
		return true;
	}
	
	return [super pointInside:point withEvent:event];
}

#pragma mark -
#pragma mark Responder Management/Retreival

- (UIView<UITextInputTraits>*) findFirstResponderIn:(UIView*)view {
	if(view == nil) view = [self currentWindow];
	
	UIView<UITextInputTraits> *firstResponder;
	
	for (UIView *iView in view.subviews){
		if([iView isFirstResponder]){
			return firstResponder = (UIView<UITextInputTraits>*)iView;
		} else if(!firstResponder && iView.subviews.count > 0){
			firstResponder = [self findFirstResponderIn:iView];
		}
	}
	
	return firstResponder;
}

- (UIWindow*) currentWindow
{
	NSArray *windows = [UIApplication sharedApplication].windows;
	
	for(UIWindow *window in windows){
		if(!window.hidden && window.isKeyWindow) return window;
	}
	
	return nil;
}

- (void) stopEditing
{
	[[self findFirstResponderIn:nil] resignFirstResponder];
}

@end

@implementation NumberPadButton

- (void) setHighlighted:(BOOL)highlighted
{
	if (highlighted){
		self.backgroundColor = self.tintColor;
	} else {
		self.backgroundColor = [UIColor clearColor];
	}
}

@end