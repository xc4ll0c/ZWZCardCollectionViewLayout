//
//  ViewController.m
//  ZWZCardCollectionViewLayoutDemo
//
//  Created by wenZheng Zhang on 15/10/21.
//  Copyright © 2015年 ZWZ. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CollectionViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Horizontal"]) {
        vc.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    } else if ([segue.identifier isEqualToString:@"Vertical"]) {
        vc.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}

@end
