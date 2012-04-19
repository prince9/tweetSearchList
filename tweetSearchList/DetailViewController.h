//
//  DetailViewController.h
//  tweetSearchList
//
//  Created by 真有 津坂 on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    
    //追加、ツイートされたテキストを受け取って表示する
    NSString *myStr;
}

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

//以下追加
@property (nonatomic,retain) NSString *myStr;
@property (strong, nonatomic) id detailItem;


@end
