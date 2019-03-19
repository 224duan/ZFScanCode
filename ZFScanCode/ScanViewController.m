//
//  ScanViewController.m
//  ZFScanCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#define KFilePath [NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"scanResult.txt"]

#define KXlsxPath [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"result.xls"]

#import "ScanViewController.h"
#import "ZFScanViewController.h"
#include "LibXL/libxl.h"  
#import "GCDWebUploader.h"
#import "UIViewController+DXKit.h"

@interface ScanViewController ()<UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate>
{
    GCDWebUploader* _webUploader;
}
@property(nonatomic, assign) BOOL isOpen;

@property(nonatomic, strong) UIDocumentInteractionController *docu;

@property(nonatomic, strong) NSMutableArray * result;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"☠️";
    self.view.backgroundColor = ZFWhite;
    
    
    _result = [NSMutableArray arrayWithContentsOfFile:KFilePath];
    if (_result == nil) {
        _result = [NSMutableArray array];
    }
}

- (IBAction)sendByWeb:(id)sender{
    
    if ([self sendFile]) {
        
        [self saveXLSX];
        
        if (_webUploader == nil) {
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
        }
        if (!_isOpen) {
            [_webUploader start];
            _isOpen = YES;
        }
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [self showAlertControllerWithTitle:@"将手机和电脑连接到同一WiFi,在电脑端的浏览器打开以下链接" message:[_webUploader.serverURL absoluteString] preferredStyle:UIAlertControllerStyleAlert actions:@[sure]];
    }
}

- (IBAction)sentByThird  {
    
    if ([self sendFile]){
        
        [self saveXLSX];
        
        if (_docu == nil) {
            _docu = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:KXlsxPath]];
            _docu.delegate = self;
        }else{
            _docu.URL = [NSURL fileURLWithPath:KXlsxPath];
        }
        CGRect rect = CGRectMake(0, 0, 320, 300);  //这里感觉没什么用
        [_docu presentOpenInMenuFromRect:rect inView:self.view animated:YES];  //不写可以直接预览
    }
}


-(BOOL)sendFile
{
    if (_result.count) return YES;
 
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"😱 没有结果 😱" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:sure];
    [self presentViewController:alertVc animated:YES completion:nil];
    return NO;
}

/**
 *  扫描事件
 */

- (IBAction)scanAction:(UIButton *)sender {

    
    UIStoryboard *mainStroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *scanVc = [mainStroy instantiateViewControllerWithIdentifier:@"ZFScanVCID"];
    ZFScanViewController * vc = (ZFScanViewController *)scanVc;
    
    __weak typeof(self) weakSelf = self;
    vc.returnScanBarCodeValue = ^(NSString * barCodeString){
        
        if (![weakSelf.result containsObject:barCodeString] && barCodeString != nil) {
            [weakSelf.result insertObject:barCodeString atIndex:0];
            [weakSelf.result writeToFile:KFilePath atomically:YES];
        }
    };
    
    vc.closeScanBarCodeValue = ^(NSString * barCodeString){
        [weakSelf.result removeObject:barCodeString];
        [weakSelf.result writeToFile:KFilePath atomically:YES];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)clearAllData:(id)sender {
    
    if (_result.count < 1) return;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"是否清除所有数据" message:@"清除之后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"清除"
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.result removeAllObjects];
        [weakSelf.result writeToFile:KFilePath atomically:YES];
        [self.tableView reloadData];
        
    }];
    [alertVc addAction:cancel];
    [alertVc addAction:sure];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.result.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCellID" forIndexPath:indexPath];
    
    cell.textLabel.text = _result[indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"结果（%d）", (int)_result.count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_result removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self.result writeToFile:KFilePath atomically:YES];
    }
}

#pragma mark - private
-(void)saveXLSX
{
    BookHandle book = xlCreateBook();
    SheetHandle sheet = xlBookAddSheet(book, "Sheet1", NULL);
    
    //第一个参数代表插入哪个表，第二个是第几行（默认从0开始），第三个是第几列（默认从0开始）
    for (int i = 0; i < self.result.count; i++) {
        const char *name_c = [self.result[i] cStringUsingEncoding:NSUTF8StringEncoding];  //这里是将NSString字符串转为C语言字符串
        xlSheetWriteStr(sheet, i+1, 0,name_c, 0);
    }
    xlBookSave(book, [KXlsxPath UTF8String]);
    xlBookRelease(book);
}


- ( UIViewController *)documentInteractionControllerViewControllerForPreview:( UIDocumentInteractionController *)interactionController{
    
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.editing = NO;
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_webUploader) {
        [_webUploader stop];
        _isOpen = NO;
    }
}




@end
