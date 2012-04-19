//
//  ViewController.h
//  tweetSearchList
//
//  Created by 真有 津坂 on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//以下追加
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>   {
    //NSMutableDataは変更可能な文字列(文字列を追加していきたい場合やデータの保持など)を使う
    //以下追加
    NSMutableData *receivedData;
    NSMutableArray *tweetsArray;
    NSMutableArray *tweetsArray2;
    NSMutableArray *tweetsArray3;
    
    //nameLabel・textLabel・tweetIconの3つはstoryboardでひも付けしないこと
    UILabel *nameLabel;
    UILabel *textLabel;
    UIImageView *tweetIcon;
    //検索結果に該当するツイート数を数える(最大15)
    int tweetcount;
}

//TableViewとTextFieldはstoryboardでひも付ける(TableViewの中に設置するものはひも付けしないでタグで指定する)
@property (weak, nonatomic) IBOutlet UITextField *myField;

@property (weak, nonatomic) IBOutlet UITableView *myTable;

//以下追加
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,retain) UIImageView *tweetIcon;


- (IBAction)reloadBtn:(id)sender;
- (IBAction)keyHide:(id)sender;

//追加
- (void)reloadTweet;

@end
