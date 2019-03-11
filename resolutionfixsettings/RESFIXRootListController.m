#include "RESFIXRootListController.h"
#import "UIColor+Hex.h"
#import "NactroHeaderView.h"
#include <spawn.h>
#import "UIFont+Extension.h"
#import "UIDevice+MobileGestaltCategory.h"
#import "DBetaObject.h"
#import "DRSACryption.h"
#import "DLicenseManager.h"

typedef enum _resStyleType{
	resStyleOriginal = 0, //原生
	resStyle4, // 4.0
	resStyle4Point7, //4.7
	resStyle5Point5, //5.5
	resStyleX, //iPhone X分辨率
}resStyleType;

BOOL pass;
BOOL globalResolution;
static float resolutionPrefsStyle = 0;
static NSNumber *originalWidth;
static NSNumber *originalHeight;
static NSNumber *rWidth;
static NSNumber *rHeight;
// 原先的文件名次
static NSString *originalFile = @"com.apple.iokit.IOMobileGraphicsFamily.plist.setrestarget.bak";
// 读取 plist 文件要用的名次
static NSString *readFile = @"com.apple.iokit.IOMobileGraphicsFamily.plist.setrestarget.bak.plist";
static NSString *originalPath = @"/private/var/mobile/Library/Preferences";
#define kWidth  [UIScreen mainScreen].bounds.size.width
static NSString *pubpem = @"/Library/PreferenceBundles/resolutionfixsettings.bundle/public.pem";
static NSString *plainStringPath = @"/private/var/mobile/com.nactro.resolutionfix.plain.dat";
static NSString *licensePath = @"/private/var/mobile/com.nactro.resolutionfix.dat";
#define HEADER_HEIGHT 120.0f
static NSString *tweakName = @"分辨率修改 v1.0.2 试用版";
static NSString *publicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAptsM8G+m3huFQMYqFkV6Ky5TiGqCjE6G3oL9/XSTAkCyQcVQFry17sN5u2s/7YZq0hZZmDpwXE16y2+feUMz4UI9BuS1zr9IiSqoDRKln3amekA7VLfuwuY6ptEJDqRfl114iLvkfXmArThPS7L1G43fFX5HhsblXF6SrQNHr4HHUMlSaGFBW0s5MYK1hLynV/lkn7heE87BEW13D3XwhVhHTNboZ9tABpStMbTHRUxB1Mjb79TjB0qFUvC7VP57Rd5DzO++GQwdAniKYTisJ5ZPoN9yY7dGoSWhYBz3Te7dlcCNzzSVXDrAvjvXNdkuZvf2iA8FS85QTl3IKIoHLQIDAQAB";

@interface RESFIXRootListController()
@property (nonatomic, strong)NactroHeaderView *headerView;
@property (nonatomic, assign)resStyleType resStyleType;
@property (nonatomic, strong)UIAlertView *activateAlertView;
@property (nonatomic, strong)UIAlertView *secondAlertView;
@property (nonatomic, assign)BOOL isActivated;
@end

@implementation RESFIXRootListController

- (void)viewDidLoad{
	[super viewDidLoad];
	[self verifyBeta];
}
- (void)verifyBeta{
	NSString *udid = [[UIDevice currentDevice]UDID];
	NSLog(@"udid------>",udid);
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	[DBetaObject verifyBetaWithServerURL:@"https://pay.nactro.com/api/tweaks/trial/" bundleName:@"com.nactro.resolutionfix" udid:udid publicKey:publicKey publicKeyPem:pubpem verifySuccessBlock:^(BOOL expired, NSString *license, NSString *plainString) {
		if (!expired) {
			NSLog(@"license------>%@",license);
			// 写入 license 文件
			[DLicenseManager generateLicenseWithLicenseString:license atPath:licensePath plainString:plainString atPath:plainStringPath];
			dispatch_semaphore_signal(semaphore);
		}
} verifyFailureBlock:^(BOOL expired) {
		if (expired) {
			NSFileManager *manager = [NSFileManager defaultManager];
			[manager removeItemAtPath:licensePath error:nil];
			[manager removeItemAtPath:plainStringPath error:nil];
			dispatch_semaphore_signal(semaphore);
		}
}];
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)checkIfLicenseValid{
		BOOL result = [DLicenseManager verifyLicenseFileWithPath:licensePath plainStringFilePath:plainStringPath publicKeyFile:pubpem];
		if (result) {
			return YES;
		}else{
			return NO;
		}
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
if (alertView.tag == 1) {
	if (buttonIndex == 0) {
}
}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"RESFIX" target:self];
	}

	return _specifiers;
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0){
	  return self.headerView;
	}else{
		return [super tableView:tableView viewForHeaderInSection:section];
	}
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return HEADER_HEIGHT;
	}else{
		return [super tableView:tableView heightForHeaderInSection:section];
	}
}
// 获取原生分辨率
- (void)getOriginalRes{
	/* 原生分辨率 */
	CGRect rect = [UIScreen mainScreen].bounds;
	CGSize size = rect.size;
	CGFloat scale = [UIScreen mainScreen].scale;
	originalWidth = [NSNumber numberWithFloat:size.width * scale];
	originalHeight = [NSNumber numberWithFloat:size.height * scale];
}

- (void)dealWithResStyle:(resStyleType)resStyleType{

	// resStyle4 = 0, // 4.0
	// resStyle4Point7, //4.7
	// resStyle5Point5, //5.5
	// resStyleX, //iPhone X分辨率

	switch (resStyleType) {
			case resStyleOriginal:
					// Nothing To Do
					break;
			case resStyle4:
					rWidth = [NSNumber numberWithInt:640];
					rHeight = [NSNumber numberWithInt:1136];
					break;
			case resStyle4Point7:
					rWidth = [NSNumber numberWithInt:750];
					rHeight = [NSNumber numberWithInt:1334];
					break;
			case resStyle5Point5:
					rWidth = [NSNumber numberWithInt:1080];
					rHeight = [NSNumber numberWithInt:1920];
					break;
			case resStyleX:
					rWidth = [NSNumber numberWithInt:1125];
					rHeight = [NSNumber numberWithInt:2436];
					break;
	}
}
- (void)readConfig{
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.nactro.resolutionfixsettings.plist"];
	if (prefs) {
		resolutionPrefsStyle = ([[prefs objectForKey:@"resolutionPrefsStyle"] floatValue] ?: resolutionPrefsStyle);
		globalResolution = ([[prefs objectForKey:@"globalResolution"] boolValue] ? [[prefs objectForKey:@"globalResolution"] boolValue] : globalResolution);
	}
	if (resolutionPrefsStyle == 1) {
		[self dealWithResStyle:resStyle4];
	}else if (resolutionPrefsStyle == 2) {
		[self dealWithResStyle:resStyle4Point7];
	}else if (resolutionPrefsStyle == 3) {
		[self dealWithResStyle:resStyle5Point5];
	}else if (resolutionPrefsStyle == 4) {
		[self dealWithResStyle:resStyleX];
	}
}

- (void)renameFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [originalPath stringByAppendingPathComponent:readFile];
    NSString *moveToPath = [originalPath stringByAppendingPathComponent:originalFile];
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    if (isSuccess) {
			NSLog(@"success");
    }else{
        NSLog(@"-------------->rename fail");
    }
}
- (void)copyFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [originalPath stringByAppendingPathComponent:originalFile];
    NSString *moveToPath = [originalPath stringByAppendingPathComponent:readFile];
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    if (isSuccess) {
			NSLog(@"-------------->复制文件成功!");
    }else{
        NSLog(@"-------------->复制文件失败！");
    }
}
- (void)saveConfig{
	// 读取配置文件，设置 rWidth 以及 kHeight 的值
	[self readConfig];
	if ([self checkIfLicenseValid]) {
				// 复制原先的 bak 文件，增加后缀名为 plist 用于读取内容
				[self copyFile];
				// 读取配置文件，设置 rWidth 以及 kHeight 的值
				[self readConfig];
				// 设置路径
				NSString *path = @"/private/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist.setrestarget.bak.plist";
				NSMutableDictionary *config = [NSMutableDictionary dictionary];
				// 读取plist 文件内容
				[config addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
				NSLog(@"config-------------->%@",config);
				// 设置高度键值
				[config setObject:rHeight forKey:@"canvas_height"];
				// 设置宽度键值
				[config setObject:rWidth forKey:@"canvas_width"];
				NSLog(@"修改后的config-------------->%@",config);
				// 写入文件
				[config writeToFile:path atomically:YES];
				// 写入文件后执行重命名文件
				[self renameFile];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存分辨率成功，重启并重新越狱以生效本次修改。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"试用期已结束，请前往购买正式版！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}
- (void)backToOriginalRes{
		if ([self checkIfLicenseValid]) {
			// 读取原生分辨率
			[self getOriginalRes];
			// 复制原先的 bak 文件，增加后缀名为 plist 用于读取内容
			[self copyFile];
			// 读取配置文件，设置 rWidth 以及 kHeight 的值
			[self readConfig];
			// 设置路径
			NSString *path = @"/private/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist.setrestarget.bak.plist";
			NSMutableDictionary *config = [NSMutableDictionary dictionary];
			// 读取plist 文件内容
			[config addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
			NSLog(@"config-------------->%@",config);
			// 设置高度键值
			[config setObject:originalHeight forKey:@"canvas_height"];
			// 设置宽度键值
			[config setObject:originalWidth forKey:@"canvas_width"];
			NSLog(@"修改后的config-------------->%@",config);
			// 写入文件
			[config writeToFile:path atomically:YES];
			// 写入文件后执行重命名文件
			[self renameFile];
			// 删除原先的文件
			//[self deleteFileAndRenameFile];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还原成功，重启并重新越狱以生效本次修改。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"试用期已结束，请前往购买正式版！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
}
#pragma mark - 方法
- (void)openDonate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/tsx09384ad5mkh65g1irre0"]];
}

- (void)killSpringBoard{
		pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

#pragma mark - setter & getter
- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
}

#pragma mark - lazyload
- (NactroHeaderView *)headerView{
	if (!_headerView) {
			_headerView = [[NactroHeaderView alloc]initWithFrame:CGRectMake(0,0,kWidth,HEADER_HEIGHT) tweakName:tweakName devTeamName:@"Nactro Dev." backgroundColor:[UIColor colorWithHexString:@"#747d8c"]];
	}
	return _headerView;
}
- (void)dealloc{
	NSLog(@"销毁控制器");
}
@end
