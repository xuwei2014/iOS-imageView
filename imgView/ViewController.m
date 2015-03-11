//
//  ViewController.m
//  imgView
//
//  Created by 李晓剑 on 15-3-10.
//
//

#import "ViewController.h"

@interface ADImg : UIView  <NSURLConnectionDataDelegate>
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLResponse *response;
-(id) initWithFrame:(CGRect)frame;
-(void) show;
-(void) hide;
@end

@implementation ADImg
-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.clipsToBounds = YES;
        //self.layer.cornerRadius = 10.0;
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        
        NSString *urlStr = @"http://lmsj-assets.oss-cn-qingdao.aliyuncs.com/image/Demo_HBTR.jpg";
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 5.0;
        
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
        [conn start];
        NSLog(@"send request");
        
        //[_image setImage:[UIImage imageNamed:@"2.png"]];
        [self addSubview:_image];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) show {
    self.hidden = NO;
}

-(void) hide {
    self.hidden = YES;
}

-(void) imgTapped {
    [self hide];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connected!!!");
    _responseData = [[NSMutableData alloc] init];
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)_response;
    if (response.statusCode == 200) {
        UIImage *img = [UIImage imageWithData:_responseData];
        [self.image setImage:img];
        NSLog(@"Success!");
    }
}

@end


@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 10, 100, 44);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"test!!" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnTap {
    NSLog(@"test tap!!!!!");
    ADImg *img = [[ADImg alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    [self.view addSubview:img];
}

@end
