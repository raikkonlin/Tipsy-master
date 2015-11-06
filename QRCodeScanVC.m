//
//  QRCodeScanVC.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/3.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "QRCodeScanVC.h"
#import "AFNetworking.h"

@interface QRCodeScanVC () <AVCaptureMetadataOutputObjectsDelegate>
{

    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;

    UIView *_highlightView;
    UILabel *_label;

    UIImageView *qrImageView;


    NSArray *receivedArray;
    NSDictionary *receivedDictionay;
    NSString *receivedString;

}

@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@end

@implementation QRCodeScanVC



-(void)viewDidLoad{

    [super viewDidLoad];

    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];

    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80);
//    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(waiting)";
    [self.view addSubview:_label];

    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;

    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }

    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];

    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    [_prevLayer setFrame:self.viewPreview.layer.bounds];
    _prevLayer.frame = self.view.frame;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];

    [_session startRunning];

    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"QRCodeAuth" object:nil
//                                                      userInfo:receivedString];


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

        //************************************************
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
        //***********************************************

    self.viewPreview.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    self.viewPreview.layer.borderWidth = 2.0f;
    self.viewPreview.layer.cornerRadius = 5.0f;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
//    [_prevLayer removeFromSuperlayer];

    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }

        if (detectionString != nil)
        {
            _label.text = detectionString;
            receivedDictionay = @{@"detectionString":detectionString};

            [[NSNotificationCenter defaultCenter] postNotificationName:@"QRCodeAuth" object:nil
                             userInfo:receivedDictionay];

//
            [self dismissViewControllerAnimated:NO completion:nil];
//            [self performSelector:@selector(QRCodeAuth:) withObject:detectionString afterDelay:0];
            break;
        }
        else
            _label.text = @"(waiting)";
        _label.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    }

    _highlightView.frame = highlightViewRect;

//        [self QRCodeAuth:receivedString];

}


-(void)backButtonPressed{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end
