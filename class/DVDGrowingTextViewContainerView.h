//
//  DVDGrowingTextViewContainerView.h
//  Keynected
//
//  Created by Dave van Dugteren on 23/04/2014.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

typedef enum : NSUInteger {
	ViewClosedTypeDefault, //Hidden
    ViewClosedTypeBottom,
} ViewClosedType;

@protocol DVDGrowingTextViewContainerViewProtocol <NSObject>

@optional

- (void) didChangeHeight:(float)height;

@end

@interface DVDGrowingTextViewContainerView : UIView
<HPGrowingTextViewDelegate>
{
	ViewClosedType viewClosedType; //Hidden or on bottom
}

@property (nonatomic, strong) HPGrowingTextView *textView;
@property (weak) id <DVDGrowingTextViewContainerViewProtocol> delegate;

+ (id) growingTextViewContainerView : (UIViewController *) viewController isFirstResponder : (BOOL) isFirstResponder;

/**
 By Dave van Dugteren
 
 This method is used to add a Growing TextView to a given View Controller either initially visible (With Keyboard showing) or just below (Or bottom of) the VC view aka Hidden. Depending on which optional settings are set when this object is created.
 
 @param viewController The ViewController that will have this view added to it and handled.
 
 @param isFirstResponder if TRUE then the keyboard is showing and the view is 'raised'.
 */
- (void) addToViewController : (UIViewController *) viewController isFirstResponder : (BOOL) isFirstResponder;

/**
 By Dave van Dugteren
 
 Essentially becomes first responder.
 
  */

- (void) show;

@end
