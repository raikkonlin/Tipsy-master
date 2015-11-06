//
//  QRCodeViewController.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/2.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "QRCodeScanVC.h"
#import "AFNetworking.h"
#import "QRCodeSuccess.h"

@interface QRCodeViewController (){

    BOOL hasVIPService ;

    NSDictionary *receivedDictionay;
    NSString *authToken;

}
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end


@implementation QRCodeViewController

+ (instancetype) controller{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([QRCodeViewController class])];
}



-(void)viewDidLoad{

    [super viewDidLoad];
    hasVIPService = YES;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    UILabel *labelNotice = [[UILabel alloc] init];

    if (!hasVIPService) {
       labelNotice.frame = CGRectMake(width/2 - 130, height/2 + 150 , 300, 35);

       labelNotice.text = @"You don't have VIP services!!";
       labelNotice.textColor = [UIColor whiteColor];
        [self.view addSubview:labelNotice];
    }
    else{


        labelNotice.frame = CGRectMake(width/4 - 10, height/2 -55, 300, 35);
        labelNotice.text = @"Use QRCode To be a King!!";
        labelNotice.textColor = [UIColor whiteColor];
        [self.view addSubview:labelNotice];

    }

    self.qrCodeImageView.image = [UIImage imageNamed:@"qrcode.png"];

    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];

//    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];
        //menu照片的顏色受leftBarButtonItem.tintColor控制
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem
                                                alloc] initWithTitle:@"Scan QRCode"
                                               style:UIBarButtonItemStylePlain target:self
                                               action:@selector(scanQRCodeButtonPressed)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

        //使_UIBackdropView的顏色變成透明
//    [naviBar setBackgroundImage:[UIImage new]
//                  forBarMetrics:UIBarMetricsDefault];
//    naviBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    naviBar.translucent = YES;
    naviBar.backgroundColor = [UIColor clearColor];

    [self.view addSubview:naviBar];

        //************************************************
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
        //***********************************************

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QRCodeAuth:) name:@"QRCodeAuth" object:nil];
}

- (void) presentLeftMenuViewController{

        //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];

}

-(void)scanQRCodeButtonPressed{

    QRCodeScanVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeScanVC"];

    [self presentViewController:controller animated:NO completion:nil];

   
}

-(void)QRCodeAuth:(NSNotification *)notification{

    NSDictionary *receivedDictionaryFromServer = notification.userInfo;
    NSString *receivedStringFromServer = receivedDictionaryFromServer[@"detectionString"];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    authToken = [userDefaultes stringForKey:@"loginToken"];

    NSString *URL_CONFIRM = @"http://www.pa9.club/api/v1/confirm";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSDictionary *params = @ {@"auth_token" :authToken, @"qrcode" :receivedStringFromServer};

    NSLog(@"params  %@",params);

    [manager POST:URL_CONFIRM parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         NSLog(@"JSON: %@", responseObject);
         receivedDictionay = responseObject;
         NSString *comparingString = receivedDictionay[@"message"];
         NSLog(@"comparingString %@",comparingString);

         if ( [comparingString  isEqualToString:@"confirm successfully!"]) {

             QRCodeSuccess *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeSuccess"];

             [self presentViewController:controller animated:YES completion:nil];
             
         }else{

             UIAlertController *alertAsk = [UIAlertController alertControllerWithTitle:@"No Available VIP PASS" message:nil preferredStyle:UIAlertControllerStyleAlert];

             UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"No RecordS! Check Please!" style:UIAlertActionStyleDefault handler:nil];

             [alertAsk addAction:okButton];

             alertAsk.view.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

             [self presentViewController:alertAsk animated:YES completion:nil];

         }


     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         /*
         UIAlertController *alertAsk = [UIAlertController alertControllerWithTitle:@"Internet connection error." message:nil preferredStyle:UIAlertControllerStyleActionSheet];

         UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Sorry, try again." style:UIAlertActionStyleDefault handler:nil];

         [alertAsk addAction:okButton];

         alertAsk.view.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

         [self presentViewController:alertAsk animated:YES completion:nil];
          */
         UIAlertController *alertAsk = [UIAlertController alertControllerWithTitle:@"No Available VIP PASS" message:nil preferredStyle:UIAlertControllerStyleAlert];

         UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"No Records! Check Please!" style:UIAlertActionStyleDefault handler:nil];

         [alertAsk addAction:okButton];

         alertAsk.view.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

         [self presentViewController:alertAsk animated:YES completion:nil];
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}




/*  QRcode
- (void) handleGenerateButtonPressed {

    NSString *stringToEncode =

        // Generate the image
    CIImage *qrCode = [self createQRForString:stringToEncode];

        // Convert to an UIImage
    UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];

        // And push the image on to the screen
    self.qrImageView.image = qrCodeImg;

}

#pragma mark - Utility methods
- (CIImage *)createQRForString:(NSString *)qrString
{
        // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];

        // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];

        // Send the image back
    return qrFilter.outputImage;
}


- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
        // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];

        // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
        // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
        // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
        // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
}
*/

@end
