//
//  TextFieldDelegateVC.m
//  ACOBJCVersion
//
//  Created by LINCHUNGYAO on 2015/10/25.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "TextFieldDelegateVC.h"
#import "AFNetworking.h"

@interface TextFieldDelegateVC () <UIPickerViewDataSource,UIPickerViewDelegate>
{

    NSArray *ratingArray;
    NSString *rating;
    NSUserDefaults *userDefault;
    NSString *authToken;
}

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIPickerView *ratringPickerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end


@implementation TextFieldDelegateVC
static NSUInteger limit = 40;

-(void) viewDidLoad
{
    [super viewDidLoad];

    self.userImage.image = [UIImage imageNamed:@"Jonny.jpg"];
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImage.layer.borderWidth =3.0f;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
    self.userImage.clipsToBounds = YES;


    self.labelUserName.text = @"Johnny Scrap";
    self.labelUserName.textColor = [UIColor whiteColor];

//    self.messageTextView.text = @"Commments only for 140 characters";
    self.messageTextView.layer.borderWidth = 2.0f;
    self.messageTextView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    self.messageTextView.layer.cornerRadius = 5.0f;
    self.messageTextView.textColor = [UIColor whiteColor];
    [self.messageTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:20]];

    ratingArray = @[@"⭐️",@"⭐️⭐️",@"⭐️⭐️⭐️",@"⭐️⭐️⭐️⭐️",@"⭐️⭐️⭐️⭐️⭐️"];
     [self.ratringPickerView selectRow:2 inComponent:0 animated:YES];

    self.confirmButton.layer.borderWidth = 2.0f;
    self.confirmButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;

    rating = @"3";

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return ratingArray.count;
}
- (IBAction)confirmButton:(UIButton *)sender {

    UIAlertController *alertAsk = [UIAlertController alertControllerWithTitle:@"Sure to Comment?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button one");

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    authToken = [userDefaultes stringForKey:@"loginToken"];

    NSString *URL_SIGNIN = @"http://www.pa9.club/api/v1/comments";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSLog(@"auth_token:%@",authToken);
    NSLog(@"rating:%@",rating);
    NSLog(@"content:%@",self.messageTextView.text);
    NSLog(@"store_id:%@",self.storeID);


    NSDictionary *params = @ {@"auth_token" :authToken, @"rating" :rating, @"content" :self.messageTextView.text, @"store_id" :self.storeID };


    [manager POST:URL_SIGNIN parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error while sending POST"
                                                             message:@"Sorry, try again."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];

         NSLog(@"Error: %@", [error localizedDescription]);
     }];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"AddEditNotification" object:nil userInfo:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}];

    [alertAsk addAction:cancelButton];
    [alertAsk addAction:okButton];

    alertAsk.view.tintColor = [UIColor grayColor];

    [self presentViewController:alertAsk animated:YES completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil]; 
}
/*
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return ratingArray[row];
}
*/

    //custom setup of PickerView
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *retval = (UILabel*)view;

    if (!retval) {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }

    retval.text = ratingArray[row];
    retval.backgroundColor = [UIColor grayColor];
    retval.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    retval.textAlignment = NSTextAlignmentCenter;
    retval.textColor = [UIColor whiteColor];

    return retval;

}
    //end of PickerView setting-------------


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (rating == nil) {
        rating = @"3";
    }
    else{

    rating= [NSString stringWithFormat:@"%lu",(row + 1)];
    }

//    NSLog(@"row %lu component %lu", row, component);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    textView.text = @"";
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
}

    //resigning keyboard when background is tapped
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    unsigned long allowedLength = limit - [textView.text length] + range.length;

    if (text.length > allowedLength) {  //means lenght of replacement text is greater than allowed lenght

            NSString *limitedString = [text substringToIndex:allowedLength];
            NSMutableString *newString = [textView.text mutableCopy];
            [newString replaceCharactersInRange:range withString:limitedString];
            textView.text = newString;
//            self.countLabel.text = [NSString stringWithFormat:@"%lu left",allowedLength];


        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Notice"
                                              message:@"only 140 characters"
                                              preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];

        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:nil];

        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

//        self.countLabel.text = @"140  characters already";
        return  NO;
    }
    else{
        return YES;
    }

}

-(void)textViewDidChange:(UITextView *)textView{


//    NSString *string = [NSString stringWithString:textView.text];
//
//    if (string.length > 0) {
//        self.countLabel.text = [NSString stringWithFormat:@"%lu characters", string.length];
//    }

}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{


    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    [self.view addSubview:naviBar];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous-50"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backButtonPressed)
                                 ];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:nil
                                ];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] initWithTitle:@""];

    naviItem.leftBarButtonItem = backItem;
    naviItem.rightBarButtonItem = addItem;
        //        menu照片的顏色受leftBarButtonItem.tintColor控制
    naviItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

        //使_UIBackdropView的顏色變成透明
    [naviBar setBackgroundImage:[UIImage new]
                  forBarMetrics:UIBarMetricsDefault];
    naviBar.shadowImage = [UIImage new];
    naviBar.translucent = YES;

    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];

//    self.navigationItem.title = @"My Title";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
////    [self.navigationItem.title setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:20]];


}

-(void)backButtonPressed{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
