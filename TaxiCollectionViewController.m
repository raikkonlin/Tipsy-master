//
//  TaxiCollectionViewController.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/22.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "TaxiCollectionViewController.h"
#import "TaxiButtonView.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "TaxiCollectionViewCell.h"
#import "TaxiCollectionReusableView.h"


@interface TaxiCollectionViewController (){
    NSArray *locationarray;
    NSArray *photoArray;

}

@end

@implementation TaxiCollectionViewController
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TaxiCollectionViewController class])];
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg"]];
    locationarray = @[@"全台", @"有特色", @"女性"];
    photoArray = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"TaxiIcon"],
                  [UIImage imageNamed:@"metro"],
                  [UIImage imageNamed:@"uber"],
                  [UIImage imageNamed:@"tomas"],
                  [UIImage imageNamed:@"ufo"],
                  [UIImage imageNamed:@"hasla"],
                  [UIImage imageNamed:@"clous"],
                  nil];
//    隱藏status bar~~~~~~~~~~~
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];
    self.navigationItem.title = @"車伕馬伕";
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
   
   
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
   // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TaxiIcon"]];
//    cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
//    cell.contentView.layer.borderWidth = 2;
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:110];
    
    
    NSLog(@"cell %@ %@", cell, imageView);
    
    imageView.image = photoArray[indexPath.row];
    
    
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    TaxiCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellGoHome" forIndexPath:indexPath];
    headerView.goHome.image = [UIImage imageNamed:@"gohome"];
    return headerView;
}


@end
