//
//  ViewController.h
//  OBIiOSDemoApp
//
//  Created by StarMac on 9/18/16.
//  Copyright © 2016 Minao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *purchaseView;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UIView *detailTopView;

@property (weak, nonatomic) IBOutlet UIButton *radioButton1;
@property (weak, nonatomic) IBOutlet UIButton *radioButton2;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField1;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField2;

@property (weak, nonatomic) IBOutlet UITextField *promotionCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *creditCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;


@property (weak, nonatomic) IBOutlet UILabel *lblCards;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptySub;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyCards;

//VSDropdown
@property (weak, nonatomic) IBOutlet UIButton *btnCreditypeDropdown;


- (IBAction)btnDetail:(id)sender;
- (IBAction)btnPurchase:(id)sender;
- (IBAction)btnChangeEmail:(id)sender;
- (IBAction)btnReset:(id)sender;
- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnOpenAccount:(id)sender;

- (IBAction)btnRadioButton:(id)sender;

@end

