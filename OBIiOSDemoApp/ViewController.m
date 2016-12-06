//
//  ViewController.m
//  OBIiOSDemoApp
//
//  Created by StarMac on 9/18/16.
//  Copyright © 2016 Minao. All rights reserved.
//

#import "ViewController.h"

#import "APIService.h"
#import "NSString+Base64.h"
#import "NSData+AESCrypt.h"
#import "VSDropdown.h"
#import "JSWaiter.h"

@interface ViewController ()<UITextFieldDelegate, UIAlertViewDelegate, VSDropdownDelegate>{
   
   
        VSDropdown *_dropdown;
        
    NSMutableArray *cardTypeArray;
    
    NSInteger selectedTypeIndex;
    
    NSString *subSalePrice;
    NSString *cardType;
    
    NSString *email;
    int viewWidth;
    int viewHeight;
}
@property (nonatomic, assign) NSUInteger dropdownIndex;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate=self;
    self.scrollView.scrollEnabled = false;
    
    [_emailView setHidden:NO];
    [_detailView setHidden:YES];
    [_purchaseView setHidden:YES];
    
    [_radioButton1 setSelected:NO];
    [_radioButton2 setSelected:YES];
    [_radioButton1 setImage:[UIImage imageNamed:@"selected-radiobutton.png"] forState:UIControlStateSelected];
    [_radioButton2 setImage:[UIImage imageNamed:@"selected-radiobutton.png"] forState:UIControlStateSelected];
    
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    
    //VSDropdown
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:NO];
    
    self.dropdownIndex = -1;
    
    cardTypeArray = [[NSMutableArray alloc] init];
    cardTypeArray = [@[[@{
                          @"Type_id" : @"0",
                          @"Type_name" : @"VISA 4444.... (Valid cc)"
                          } mutableCopy],
                       [@{
                          @"Type_id" : @"1",
                          @"Type_name" : @"MasterCard 5105.... (Invalid cc)"
                          } mutableCopy],
                       [@{
                          @"Type_id" : @"2",
                          @"Type_name" : @"American Express 3782.... (Valid cc)"
                          } mutableCopy]
                       
                       
                       ] mutableCopy];
    
}

- (void)initDetailView {             //init Subscriptions Detail View

    [self.detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [_lblCards setFrame:CGRectMake(15, 311, 110, 20)];
    [_groupView  setFrame:CGRectMake(0, 390, viewWidth, 130)];

    [self.detailView addSubview:_detailTopView];
    [self.detailView addSubview:_lblEmptySub];
    [_lblEmptySub setHidden:YES];
    [self.detailView addSubview:_lblCards];
    [self.detailView addSubview:_lblEmptyCards];
    [_lblEmptyCards setHidden:YES];
    [_detailView addSubview:_groupView];
    
    
}

- (void)initPurchaseView {             //init Purchase Subscriptions View
    [_radioButton1 setSelected:NO];
    [_radioButton2 setSelected:YES];
    subSalePrice = @"1000";
    _promotionCodeTextField.text = @"";
    _creditCardTextField.text = @"4444444444444448";
    _cvcTextField.text = @"123";
    _monthTextField.text = @"9";
    _yearTextField.text = @"2016";
    _firstNameTextField.text = @"";
    _lastNameTextField.text = @"";
    _addressTextField.text = @"";
    _cityTextField.text = @"";
    _stateTextField.text = @"";
    _zipTextField.text = @"";
    cardType = @"VISA";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDetail:(id)sender {                    //Click Subscriptions Detail Button
    [self initDetailView];
    
    email = [self.emailTextField text];
    self.emailTextField1.text = email;
    
    NSMutableArray *arrayOfferName = [[NSMutableArray alloc]init];
    NSMutableArray *arraySalePrice = [[NSMutableArray alloc]init];
    NSMutableArray *arrayPaymentType = [[NSMutableArray alloc]init];
    NSMutableArray *arrayLastFourDigits = [[NSMutableArray alloc]init];
    
    if ([email isEqualToString:@""] || [email isEqual:nil]){                    //Detect Valid Email
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email is empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else if ([self validateEmail:email]){
        
        [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];//progressbar start
        
        self.scrollView.contentOffset = CGPointZero;
        [_emailView setHidden:YES];
        [_detailView setHidden:NO];
        [_purchaseView setHidden:YES];
        
        NSDictionary *param = @{
                                @"email":email
                                };

//******ListSub Request:*******//
        [APIService makeApiCallWithMethodUrl:@"http://demoapp.qat.obi.aol.com/listSub" andRequestType:RequestTypeGet andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
            
            NSLog(@"success %@", result);
            NSArray *dictSub = (NSArray*)result;
            
            for (int i = 0; i<dictSub.count; i++) {
                NSDictionary *dictSubData = [dictSub objectAtIndex:i];
                NSString *offerName = dictSubData[@"offerName"];
                NSString *salePrice = dictSubData[@"salePrice"];
                [arrayOfferName addObject:offerName];
                [arraySalePrice addObject:salePrice];
                
            }
            
            NSLog(@"arrayOfferName %@", arrayOfferName);
            NSLog(@"arraySalePrice %@", arraySalePrice);
            
        //******ListInstrument Request:*******//
            [APIService makeApiCallWithMethodUrl:@"http://demoapp.qat.obi.aol.com/listInstrument" andRequestType:RequestTypeGet andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
                
                NSLog(@"success %@", result);
                
                [JSWaiter HideWaiter];                             //progressbar end
                NSArray *dictInstrument = (NSArray*)result;
                
                for (int i = 0; i<dictInstrument.count; i++) {
                    NSDictionary *dictInstrumentData = [dictInstrument objectAtIndex:i];
                    NSString *paymentType = dictInstrumentData[@"paymentType"];
                    NSString *lastFourDigits = dictInstrumentData[@"lastFourDigits"];
                    [arrayPaymentType addObject:paymentType];
                    [arrayLastFourDigits addObject:lastFourDigits];
                }
                
                NSLog(@"arrayPaymentType %@", arrayPaymentType);
                NSLog(@"arrayLastFourDigits %@", arrayLastFourDigits);
  
                //Display Subscriptions Detail Data
                if ([arrayOfferName count] == 0) {
                    [_lblEmptySub setHidden:NO];
                    [_lblEmptyCards setHidden:NO];
                    
                    self.groupView.frame = CGRectMake(0, 390, viewWidth, 130);
                    
                }else {
                    int y = 258;
                    int subCount = (int)[arrayOfferName count];
                    int paymentCount = (int)[arrayPaymentType count];
                    for (int i = 0; i < subCount; i++) {
                        UITextField *subTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, y, viewWidth-30, 33)];
                        [subTextField setBorderStyle:UITextBorderStyleRoundedRect];
                        NSString *strOfferName = [arrayOfferName objectAtIndex:i];
                        NSString *strSalePrice = [arraySalePrice objectAtIndex:i];
                        [subTextField setFont:[UIFont systemFontOfSize:14]];
                        subTextField.enabled = NO;
                        subTextField.text =[NSString stringWithFormat:@"%@ $%@ per month", strOfferName, strSalePrice];
                        y += 33;
                        [self.detailView addSubview:subTextField];
                    }
                    
                    self.lblCards.frame = CGRectMake(self.lblCards.frame.origin.x, y + 19, self.lblCards.frame.size.width, self.lblCards.frame.size.height);
                    y += 47;
                    
                    for (int i = 0; i < paymentCount; i++) {
                        UITextField *paymentTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, y, viewWidth-30, 33)];
                        [paymentTextField setBorderStyle:UITextBorderStyleRoundedRect];
                        NSString *strPaymentType = [arrayPaymentType objectAtIndex:i];
                        NSString *strLastFourDigits = [arrayLastFourDigits objectAtIndex:i];
                        [paymentTextField setFont:[UIFont systemFontOfSize:14]];
                        paymentTextField.enabled = NO;
                        paymentTextField.text =[NSString stringWithFormat:@"%@ %@", strPaymentType, strLastFourDigits];
                        y += 33;
                        [self.detailView addSubview:paymentTextField];
                    }
                    
                    self.groupView.frame = CGRectMake(self.groupView.frame.origin.x, y + 19, viewWidth, self.groupView.frame.size.height);

                    
                    y += 149;
                    
                    if (y > viewHeight) {
                        self.scrollView.scrollEnabled = true;
                        [self.scrollView setContentSize:CGSizeMake( self.view.bounds.size.width, y)];
                    }else{
                        self.scrollView.scrollEnabled = false;
                    }
                }

                
            } faultCallback:^(NSError *fault) {
                NSLog(@"error %@", fault);
            }];
        //**************************************//
            

            
        } faultCallback:^(NSError *fault) {
            NSLog(@"error %@", fault);
        }];
//**************************************//
        
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter Email correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
}

- (IBAction)btnPurchase:(id)sender {                      //Click Purchase Subscriptions Button
    [self initPurchaseView];
    
    email  =   [self.emailTextField text];
    self.emailTextField2.text = email;
    
    if ([email isEqualToString:@""] || [email isEqual:nil]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email is empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else if ([self validateEmail:email]){
    [_emailView setHidden:YES];
    [_detailView setHidden:YES];
    [_purchaseView setHidden:NO];
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.scrollEnabled = true;
    [self.scrollView setContentSize:CGSizeMake( self.view.bounds.size.width, 1300)];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter Email correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
}

- (IBAction)btnChangeEmail:(id)sender {                     //Click Change Email Button
    
    self.scrollView.scrollEnabled = false;
    [self.scrollView setContentSize:CGSizeMake( self.view.bounds.size.width, self.view.bounds.size.height)];

    [_emailView setHidden:NO];
    [_detailView setHidden:YES];
    [_purchaseView setHidden:YES];
    
}

- (IBAction)btnReset:(id)sender {                            //Click Reset Button
    _firstNameTextField.text = @"";
    _lastNameTextField.text = @"";
    _addressTextField.text = @"";
    _cityTextField.text = @"";
    _stateTextField.text = @"";
    _zipTextField.text = @"";
}

- (IBAction)btnSubmit:(id)sender {                         //Click Submit Button
    if ([_firstNameTextField.text isEqualToString:@""] || [_lastNameTextField.text isEqualToString:@""] || [_addressTextField.text isEqualToString:@""] || [_cityTextField.text isEqualToString:@""] || [_stateTextField.text isEqualToString:@""] || [_zipTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Input Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else{

   //********************* Get Request Token *******************
        
        [JSWaiter ShowWaiter:self.view title:@"Please Wait..." type:0];//progressbar start
        
        NSDictionary *param = @{
                                @"email":email
                                };
        [APIService makeApiCallWithMethodUrl:@"http://demoapp.qat.obi.aol.com/getRequestToken" andRequestType:RequestTypeGet andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
            NSLog(@"success %@", result);
            
            NSDictionary *dictToken = (NSDictionary*)result;
            NSString *guid = dictToken[@"guid"];
            NSString *authToken = dictToken[@"authToken"];
            NSString *reqToken = dictToken[@"reqToken"];
            
            reqToken = [reqToken stringByReplacingOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, reqToken.length)];
            NSString *cardNum = [self.creditCardTextField text];
            NSString *cvc = [self.cvcTextField text];
   
   //********************* Tokenization of the Credit Card ***********************
            [self tokenizePaymentMethod:authToken forGUID:guid forToken:reqToken forCreditCard:cardNum forCVC:cvc];
        } faultCallback:^(NSError *fault) {
            NSLog(@"error %@", fault);
        }];

    }
}

//Tokenization of the Credit Card Function
- (void) tokenizePaymentMethod:(NSString*) authToken
                       forGUID:(NSString*)guid
                      forToken:(NSString*)reqToken
                 forCreditCard:(NSString*)cardNum
                        forCVC:(NSString*)cvc {
    NSString *url = [NSString stringWithFormat:@"https://jsl.qat.obi.aol.com/obipmservice/apiCall?apiName=tokenizePaymentMethod&sg=testobi&t=%@&tg=%@&country=US&lang=en", authToken, guid];
    
    NSString *string = [NSString stringWithFormat:@"%@;%@", cardNum, cvc];
    NSMutableData *cardPlain=[[string dataUsingEncoding:NSASCIIStringEncoding] mutableCopy];
    while ([cardPlain length]<32)
        
    {
        
        [cardPlain appendBytes:"" length:1];
        
    }
    
    NSData *data = [cardPlain AES256EncryptWithKey:reqToken];
    NSString *base64String = [NSString base64StringFromData:data length:[data length]];
    
    NSLog(@"%@", base64String);

    NSDictionary *param = @{
                            @"tokenizePaymentMethod":@{
                                    @"requestData":base64String
                                    }
                            };

//Tokenization of the Credit Card Request
    [APIService makeApiCallWithMethodUrl:url andRequestType:RequestTypeJSON andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
        NSLog(@"%@", result);
        NSDictionary *dictPayment = (NSDictionary*)result;
        NSDictionary *data = dictPayment[@"data"];
        NSDictionary *tokenizePaymentMethodResponse = data[@"m:tokenizePaymentMethodResponse"];
        NSString *accountNumber = tokenizePaymentMethodResponse[@"m:result"];
        
        NSString *firstName = [self.firstNameTextField text];
        NSString *lastName = [self.lastNameTextField text];
        NSString *address = [self.addressTextField text];
        NSString *city = [self.cityTextField text];
        NSString *state = [self.stateTextField text];
        NSString *zip = [self.zipTextField text];
        NSString *expiryDate;
        if ([[self.monthTextField text]intValue] > 0 && [[self.monthTextField text]intValue] < 13 ) {
            if ([[self.monthTextField text]intValue] < 10) {
                expiryDate = [NSString stringWithFormat:@"0%@%@", [self.monthTextField text], [self.yearTextField text]];
            }else{
                expiryDate = [NSString stringWithFormat:@"%@%@", [self.monthTextField text], [self.yearTextField text]];
            }
        }else{
            //error message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Date Input Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        NSString *paymentType = cardType;
        
   //********************* Setup Payment Method ***********************
        [self setupPaymentMethod:firstName forLastName:lastName forStreet1:address forCity:city forState:state forZIP:zip forAccountNumber:accountNumber forExpiryDate:expiryDate forPaymentType:paymentType];
    } faultCallback:^(NSError *fault) {
        NSLog(@"%@", fault);
    }];
}

//Setup Payment Method Function
- (void) setupPaymentMethod:(NSString*) firstName
                forLastName:(NSString*)lastName
                 forStreet1:(NSString*)street
                    forCity:(NSString*)city
                   forState:(NSString*)state
                     forZIP:(NSString*)zip
           forAccountNumber:(NSString*)accountNumber
              forExpiryDate:(NSString*)expiryDate
             forPaymentType:(NSString*)paymentType {
    
    NSDictionary *param = @{
                            @"firstName":firstName,
                            @"lastName":lastName,
                            @"email":email,
                            @"street1":street,
                            @"city":city,
                            @"state":state,
                            @"zip":zip,
                            @"country":@"US",
                            @"accountNumber":accountNumber,
                            @"expiryDate":expiryDate,
                            @"paymentType":paymentType
                            };

//Setup Payment Method Request
    [APIService makeApiCallWithMethodUrl:@"http://demoapp.qat.obi.aol.com/setupPaymentMethod" andRequestType:RequestTypeJSON andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
        NSLog(@"success %@", result);
        
        NSDictionary *dictSetupPayment = (NSDictionary*)result;
        NSString *pmId = dictSetupPayment[@"pmId"];
        
   //********************* Subscribe ***********************
        [self subscribe:pmId];
    }faultCallback:^(NSError *fault) {
        NSLog(@"error %@", fault);
    }];
    
}

//Subscribe Function
- (void) subscribe:(NSString*) pmId {

    NSString *orderUUID = [[NSUUID UUID] UUIDString];
    
    NSDictionary *param = @{
                            @"source":@"testobi-2",
                            @"salePrice":subSalePrice,
                            @"email":email,
                            @"pmId":pmId,
                            @"orderUUID":orderUUID,
                            };

//Subscribe Request
    [APIService makeApiCallWithMethodUrl:@"http://demoapp.qat.obi.aol.com/subscribe" andRequestType:RequestTypeJSON andPathParams:nil andQueryParams:param resultCallback:^(NSObject *result) {
        NSLog(@"success %@", result);
        
        [JSWaiter HideWaiter];                             //progressbar end
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success Subscribe" message:@"Thank you for Subscribing!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }faultCallback:^(NSError *fault) {

        [JSWaiter HideWaiter];                             //progressbar end

        NSLog(@"error %@", fault);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed Subscribe" message:@"500: Internal Server Error, please contact administrator for the future information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self btnDetail:NULL];
    }
}

- (IBAction)btnOpenAccount:(id)sender {
}

- (IBAction)btnRadioButton:(id)sender {
    
    switch ([sender tag]) {
        case 1:
            [_radioButton1 setSelected:YES];
            [_radioButton2 setSelected:NO];
            subSalePrice = @"500";
            break;
            
        case 2:
            [_radioButton1 setSelected:NO];
            [_radioButton2 setSelected:YES];
            subSalePrice = @"1000";
            break;
            
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark VSdropdown Delegate

- (IBAction)onDropUp:(id)sender {
    
    [self showDropDownForButton:sender adContents:[self getNameArray:cardTypeArray] multipleSelection:NO];
    
}
- (NSMutableArray *)getNameArray:(NSMutableArray *)arr {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *dic in arr) {
        [names addObject:[@"" stringByAppendingString:[dic objectForKey:@"Type_name"]]];
    }
    return names;
}
- (void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [_dropdown setDrodownAnimation:rand() % 2];
    
    [_dropdown setAllowMultipleSelection:multipleSelection];
    
    [_dropdown setupDropdownForView:sender];
    
    [_dropdown setShouldSortItems:NO];
    
    [_dropdown setTextColor:[UIColor blackColor]];
    
    
    if (_dropdown.allowMultipleSelection) {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[sender.titleLabel.text]];
        
    }
    
}


- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
    _dropdownIndex = [[[cardTypeArray objectAtIndex:index] objectForKey:@"Type_id"] intValue];
    
    switch (_dropdownIndex) {
        case 0:
            self.creditCardTextField.text = @"4444444444444448";
            cardType = @"VISA";
            break;
            
        case 1:
            self.creditCardTextField.text = @"5105105105105100";
            cardType = @"MasterCard";
            break;

        case 2:
            self.creditCardTextField.text = @"378282246310005";
            cardType = @"American Express";
            break;

        default:
            break;
    }
    
    NSLog(@"%lu, %li",(unsigned long)_dropdownIndex, (long)selectedTypeIndex);
    
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown {
    
    return [UIColor grayColor];
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown {
    return 1.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown {
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown {
    return -2.0;
}


//VSDropdown Delegate methods End.


- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

@end
