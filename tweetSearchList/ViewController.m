//
//  ViewController.m
//  tweetSearchList
//
//  Created by 真有 津坂 on 12/04/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//ここからいちばん上のフレームワークをダウンロード、classフォルダをそのまま突っ込む
//https://github.com/stig/json-framework/downloads

#import "ViewController.h"
//追加
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize myField;
@synthesize myTable;
//以下追加
@synthesize nameLabel;
@synthesize textLabel;
@synthesize tweetIcon;

//以下追加
- (void)reloadTweet {
    //データを受け取る準備をする。receivedDataはTweet全体のデータ、tweetsArray・tweetsArray2・tweetsArray3はユーザ名・実際のツイート・アイコン
    receivedData = [[NSMutableData alloc] initWithLength:0];
    tweetsArray = [[NSMutableArray alloc] init];
    tweetsArray2 = [[NSMutableArray alloc] init];
    tweetsArray3 = [[NSMutableArray alloc] init];
    
    //以下、URLを指定→そこにアクセスする設定をする→アクセスする
    //検索語を指定する。日本語を検索する場合は、UTF-8でURLエンコードした文字列を渡す
    //英語で入力しても大丈夫
    //ここをTextFieldで入力した言葉ではなく指定したい場合はNSString *searchString = @"ほげほげ";にする
    NSString *searchString = myField.text;
    //UTF-8でURLエンコード
    NSString* encodStr = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //URLを指定
	NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@",
                           encodStr];
    
    //URLWithStringでNSURLのインスタンスを生成
    NSURL *url = [NSURL URLWithString:urlString];
    

    //NSURLRequestとurlStringで設定したアドレスにアクセスする設定をする
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
	
    //NSURLConnectionで実際にアクセスする
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	
    //アクセスできなかったらエラーを表示
	if (conn == nil) {
        NSLog(@"no Commect.");
	}
    
}

//追加
//didReceiveResponse:でデータの受信の準備をする。setLength:0でデータをいったんリセット
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

//追加
//didReceiveData:で実際にデータを受信(一気に受信できるわけではない)、receivedDataに追加
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

//以下追加
//connectionDidFinishLoading:でデータの受信が成功したときの処理を書く。受信データを保持しているreceivedDataを文字列に変換
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *json = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    
    //jsonで解析するためにJSONValueメッセージを投げる。解析データはNSDictionaryで取得
    NSDictionary *result = [json JSONValue];
	//resultsにTweetが配列の形で入っている
	NSArray *items = [result objectForKey:@"results"];
    
	//Tweetをひとつずつ取り出してNSlogで表示
	for (NSDictionary* tweet in items) {
		//NSLog(@"- %@", [tweet objectForKey:@"from_user"]);
        
        //テーブルで表示
        [tweetsArray2 addObject:[tweet objectForKey:@"from_user_name"]];
        [tweetsArray addObject:[tweet objectForKey:@"text"]];
        [tweetsArray3 addObject:[tweet objectForKey:@"profile_image_url"]];
        
        
        
        //ネットワークにアクセスしているマーク
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }
	[myTable reloadData];
    //Tweetの数を表示(一気に取れる数は最大15)
    tweetcount = [tweetsArray count];
    NSLog(@"%d",tweetcount);
    
}

//追加
//ツイートの数だけテーブルになる
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweetsArray count];
}

//以下追加
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //セルのIdentiferを指定
    static NSString *cellID = @"tweetCell";
    //UITableViewCellクラスのインスタンスを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //ユーザ名・ツイート・アイコンを表示するラベルやImageViewにタグを設定する。タグを設定することでどれがどれか識別できる。storyboardの「Tag」で設定してから以下に入力する
    nameLabel = (UILabel*)[cell viewWithTag:1];
    textLabel = (UILabel*)[cell viewWithTag:2];
    tweetIcon = (UIImageView*)[cell viewWithTag:3];
    
    nameLabel.text = [tweetsArray2 objectAtIndex:indexPath.row];
    textLabel.text = [tweetsArray objectAtIndex:indexPath.row];
    
    textLabel.lineBreakMode  = UILineBreakModeWordWrap;
    textLabel.numberOfLines  = 0;
   
    textLabel.adjustsFontSizeToFitWidth = YES;
    
    
    NSURL *url = [NSURL URLWithString:[tweetsArray3 objectAtIndex:indexPath.row]];
    NSData *iconData = [NSData dataWithContentsOfURL:url];
    tweetIcon.image = [UIImage imageWithData:iconData];
    
   

    return cell;
}

//追加
//次のViewにデータを渡す準備
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mySegue"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        NSInteger selectedIndex = [[self.myTable indexPathForSelectedRow] row];
        detailViewController.myStr = [tweetsArray objectAtIndex:selectedIndex];   
        
        
    }
    
    
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //追加、これを忘れるとデータが表示できない
    myTable.delegate = self;
    myTable.dataSource = self;
    //self〜 でvoidの中身を呼び出して実行
    [self reloadTweet];
    
    //TableViewの角を丸くする
    //CALayerでテーブルに影をつけても良いんですが、重いっぽいので今回はUIImageで影をつけたPNGファイルを読み込ませています
    CALayer* layer = self.myTable.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0;
    
    //TableViewに背景画像を設定
    UIImage* image = [UIImage imageNamed:@"tableviewback.png"];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
	[self.myTable setBackgroundView:imageView];
    
    //セルに背景画像を設定
    /*
     UIImage *cellback = [UIImage imageNamed:@"cellback.png"];
     UIImageView *backgroundView = [[UIImageView alloc] initWithImage:cellback];
     cell.backgroundView = backgroundView;
     */

    
}

- (void)viewDidUnload
{
    [self setMyField:nil];
    [self setMyTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//追加
- (IBAction)reloadBtn:(id)sender {
    [self reloadTweet];
    //ネットワークにアクセスしているマーク
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//追加、キーボード隠す
- (IBAction)keyHide:(id)sender {
    [myField resignFirstResponder];

}


@end
