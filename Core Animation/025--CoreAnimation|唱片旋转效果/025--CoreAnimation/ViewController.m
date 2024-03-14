//
//  ViewController.m
//  025--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
#import "MusicAlbumView.h"

#define  WIDTHANDHEIGHT 80

@interface ViewController ()
@property (nonatomic, strong) MusicAlbumView *musicAlbum;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.musicAlbum = [[MusicAlbumView alloc] initWithFrame:CGRectMake(self.view.bounds.size .width- WIDTHANDHEIGHT - 10, self.view.bounds.size.height - WIDTHANDHEIGHT - 10, WIDTHANDHEIGHT, WIDTHANDHEIGHT)];
    [self.musicAlbum.album setImage:[UIImage imageNamed:@"hello.png"]];
    [self.view addSubview:self.musicAlbum];
    [self.musicAlbum startAnimation:12];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
