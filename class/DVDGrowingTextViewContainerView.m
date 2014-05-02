//
//  DVDGrowingTextViewContainerView.m
//  Keynected
//
//  Created by Dave van Dugteren on 23/04/2014.
//  Copyright (c) 2014 Mobifiliate Pty Ltd. All rights reserved.
//

#import "DVDGrowingTextViewContainerView.h"

@interface DVDGrowingTextViewContainerView ()
{
	BOOL hasBeenAddedToAViewController;
	UIViewController *__viewController;
}

@end

@implementation DVDGrowingTextViewContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self commonInit];
    }
    return self;
}

+ (id) growingTextViewContainerView : (UIViewController *) viewController isFirstResponder : (BOOL) isFirstResponder
{
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	
	DVDGrowingTextViewContainerView *object = [[DVDGrowingTextViewContainerView alloc] initWithFrame:CGRectMake(0.f,
																												appFrame.size.height - 40.f,
																												320.f,
																												40.f)];
	
	[object addToViewController: viewController isFirstResponder:isFirstResponder];
	
	return object;
}

- (void) show
{
		NSAssert(hasBeenAddedToAViewController, @"This view must be added to a ViewController. Use 'addToViewController' instead of addSubview (To get the correct View origin).");
	[self.textView becomeFirstResponder];
}

- (void) commonInit
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
	viewClosedType = ViewClosedTypeDefault;
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
																				target: self
																				action: nil];
	
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height)];
	toolBar.barStyle = UIBarStyleBlack;
	toolBar.translucent = YES;
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWriting)];
	[toolBar setItems:[NSArray arrayWithObjects: flexiSpace, doneButton, nil]];
	
	//    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
	//    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
	//    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    toolBar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	
    // view hierachy
//    [self addSubview:toolBar];
    [self addSubview: self.textView];
    [self addSubview: entryImageView];
	//
	//    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	//    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
//	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//	doneBtn.frame = CGRectMake(self.frame.size.width - 69, 8, 63, 27);
//    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//	[doneBtn setTitle:@"Done" forState:UIControlStateNormal];
//    
//    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
//    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
//    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//    
//    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
//	//    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
//	//    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
//	[self addSubview:doneBtn];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (HPGrowingTextView *)textView
{
	if (!_textView)
	{
		_textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6.f, 3.f, 308.f, 40.f)];
		_textView.isScrollable = NO;
		_textView.contentInset = UIEdgeInsetsMake(0, 5.f, 0, 5.f);
		
		_textView.minNumberOfLines = 1;
		_textView.maxNumberOfLines = 6;
		// textView.maxHeight = 200.0f; // you can also set the maximum height in points with maxHeight
		_textView.returnKeyType = UIReturnKeyDone; //just as an example
		_textView.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
		//_internalTextView.font = [UIFont fontWithName:@"Helvetica" size:13];
		_textView.delegate = self;
		_textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
		_textView.backgroundColor = [UIColor clearColor];
		_textView.placeholder = @"Send a message...";
		_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	
	return _textView;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
	[self.textView resignFirstResponder];
	
	return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
{
	NSLog(@"Height changed");
	if ([self.delegate respondsToSelector: @selector(didChangeHeight:)]) {
		[self.delegate didChangeHeight: height];
	}
}

- (void) doneWriting
{
	NSLog(@"doneWriting");
}

/**
 By Dave van Dugteren
 
 This method is used to add a Growing TextView to a given View Controller either initially visible (With Keyboard showing) or just below (Or bottom of) the VC view aka Hidden. Depending on which optional settings are set when this object is created.
 
 @param viewController The ViewController that will have this view added to it and handled.
 
 @param isFirstResponder if TRUE then the keyboard is showing and the view is 'raised'.
 */
- (void) addToViewController : (UIViewController *) viewController isFirstResponder : (BOOL) isFirstResponder
{
	hasBeenAddedToAViewController = YES;
	
	__viewController = viewController;
	
	switch (viewClosedType) {
		case ViewClosedTypeDefault:
		{
			self.frame = CGRectMake(0.f,
									viewController.view.frame.size.height,
									320.f,
									40.f);
			break;
		}
		case ViewClosedTypeBottom:
		{
			self.frame = CGRectMake(0.f,
									viewController.view.frame.size.height - 40.f,
									320.f,
									40.f);
			break;
		}
		default:
			break;
	}
	
	NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
	
	[__viewController.view addSubview: self];
	
	if (isFirstResponder)
	{
		[self.textView becomeFirstResponder];
	}
}

-(void)resignTextView
{
	[self.textView resignFirstResponder];
}
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [__viewController.view convertRect:keyboardBounds toView:nil];
	
//	keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
//	CGRect containerFrame = containerView.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
	// get a rect for the textView frame
	CGRect containerFrame = self.frame;
    containerFrame.origin.y = __viewController.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height) - 63; //+ 25.f;
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.frame;
    containerFrame.origin.y = __viewController.view.bounds.size.height - containerFrame.size.height - 20.f;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
