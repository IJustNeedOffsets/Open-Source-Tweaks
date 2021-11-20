#import "AvimojiViewController.h"

@implementation AvimojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorNamed:@"Primary"];
    
    self.accentColour = UIColor.systemBlueColor;
    
    self.view.tintColor = self.accentColour;
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    window.tintColor = self.accentColour;
    
    self.stickersArray = [[TDAvatarIdentityPickerDataSource sharedInstance] stickersData];
    self.emojisArray = [[TDAvatarIdentityPickerDataSource sharedInstance] emojiData];
    
    [self layoutHeaderView];
    [self layoutCollectionView];
}


-(void)layoutHeaderView {
    
    self.headerView = [[TDHeaderView alloc] initWithTitle:@"Avimoji" accent:UIColor.systemBlueColor leftIcon:@"chevron.left" leftAction:@selector(dismissVC) rightIcon:@"paperplane.fill" rightAction:nil];
    self.headerView.grabberView.alpha = 0;
    self.headerView.leftButton.backgroundColor = [UIColor colorNamed:@"Secondary"];
    self.headerView.rightButton.backgroundColor = self.accentColour;
    self.headerView.rightButton.tintColor = UIColor.whiteColor;
    self.headerView.rightButton.alpha = 0;
    self.headerView.rightButton.menu = [self optionsManager];
    self.headerView.rightButton.showsMenuAsPrimaryAction = true;
    [self.view addSubview:self.headerView];
    
    [self.headerView size:CGSizeMake(self.view.frame.size.width, 55)];
    [self.headerView x:self.view.centerXAnchor];
    [self.headerView top:self.view.safeAreaLayoutGuide.topAnchor padding:0];
    
    
    self.preview = [[UIView alloc] init];
    self.preview.backgroundColor = [self colorWithHexString:@"a8e6cf"];
    self.preview.layer.cornerRadius = 125;
    self.preview.clipsToBounds = YES;
    self.preview.layer.masksToBounds = YES;
    [self.view addSubview:self.preview];
    
    [self.preview size:CGSizeMake(250, 250)];
    [self.preview x:self.view.centerXAnchor];
    [self.preview top:self.headerView.bottomAnchor padding:20];
    
    
    self.previewImage = [[UIImageView alloc] init];
    self.previewImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.preview addSubview:self.previewImage];
    
    [self.previewImage size:CGSizeMake(250, 250)];
    [self.previewImage x:self.preview.centerXAnchor y:self.preview.centerYAnchor];
    
    
    self.stickerImage = [[UIImageView alloc] init];
    self.stickerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.stickerImage.alpha = 0;
    [self.preview addSubview:self.stickerImage];
    
    [self.stickerImage size:CGSizeMake(200, 200)];
    [self.stickerImage x:self.preview.centerXAnchor y:self.preview.centerYAnchor];
    
    
    self.emojiLabel = [[UILabel alloc] init];
    self.emojiLabel.textAlignment = NSTextAlignmentCenter;
    self.emojiLabel.font = [UIFont systemFontOfSize:170];
    self.emojiLabel.text = @"😀";
    [self.preview addSubview:self.emojiLabel];
    
    [self.emojiLabel x:self.preview.centerXAnchor y:self.preview.centerYAnchor];
    
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = UIColor.clearColor;
    self.textField.tintColor = self.accentColour;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.font = [UIFont systemFontOfSize:100 weight:UIFontWeightBold];
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.alpha = 0;
    [self.preview addSubview:self.textField];
    
    [self.textField size:CGSizeMake(230, 230)];
    [self.textField x:self.preview.centerXAnchor y:self.preview.centerYAnchor];
}


-(void)layoutCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView registerClass:[TDAvatarIdentityToolsCell class] forCellWithReuseIdentifier:@"ToolsCell"];
    [self.collectionView registerClass:[TDAvatarIdentityStickerCell class] forCellWithReuseIdentifier:@"StickerCell"];
    [self.collectionView registerClass:[TDAvatarIdentityEmojiCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    [self.collectionView registerClass:[TDAvatarIdentityCellHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView top:self.preview.bottomAnchor padding:20];
    [self.collectionView bottom:self.view.bottomAnchor padding:-20];
    [self.collectionView leading:self.view.leadingAnchor padding:0];
    [self.collectionView trailing:self.view.trailingAnchor padding:0];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 3;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 45);
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 7;
    } else if (section == 1) {
        return self.stickersArray.count;
    } else {
        return self.emojisArray.count;
    }
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        TDAvatarIdentityCellHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSArray *titleArray = [[NSArray alloc] initWithObjects:@"", @"Stickers", @"More", nil];
        
        headerView.headerLabel.text = [titleArray objectAtIndex:indexPath.section];
        reusableview = headerView;
    }
    
    return reusableview;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        TDAvatarIdentityToolsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToolsCell" forIndexPath:indexPath];
        
        cell.baseView.backgroundColor = [self.accentColour colorWithAlphaComponent:0.4];
        cell.baseView.layer.borderWidth = 0.8;
        cell.baseView.layer.borderColor = [self.accentColour colorWithAlphaComponent:0.7].CGColor;
        cell.iconImage.tintColor = self.accentColour;
        
        if (indexPath.row == 0) {
            cell.iconImage.image = [UIImage systemImageNamed:@"photo.fill.on.rectangle.fill"];
        } else if (indexPath.row == 1) {
            cell.iconImage.image = [UIImage systemImageNamed:@"paintpalette.fill"];
        } else if (indexPath.row == 2) {
            cell.iconImage.image = [UIImage systemImageNamed:@"face.smiling.fill"];
        } else if (indexPath.row == 3) {
            cell.iconImage.image = [UIImage systemImageNamed:@"textformat"];
        } else if (indexPath.row == 4) {
            cell.iconImage.image = [UIImage systemImageNamed:@"squareshape.fill"];
        } else if (indexPath.row == 5) {
            cell.iconImage.image = [UIImage systemImageNamed:@"square.fill"];
        } else if (indexPath.row == 6) {
            cell.iconImage.image = [UIImage systemImageNamed:@"circle.fill"];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        TDAvatarIdentityStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
        
        cell.iconImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Avatar/Stickers/%@", [self.stickersArray objectAtIndex:indexPath.row]]];
        return cell;
        
    } else {
        
        TDAvatarIdentityEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
        
        TDAvatarIdentityPickerEmojiDataModel *emojiData = [self.emojisArray objectAtIndex:indexPath.row];
        
        cell.baseView.backgroundColor = [self colorWithHexString:emojiData.colour];
        cell.emojiLabel.text = emojiData.emoji;
        
        return cell;
    }
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,20,0,20);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/4-20, self.view.frame.size.width/4-20);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.modalInPresentation = YES;
    self.headerView.rightButton.alpha = 1;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self presentPhotoPickerVC];
        } else if (indexPath.row == 1) {
            [self presentColourPickerVC];
        } else if (indexPath.row == 2) {
            [self presentEmojiPickerVC];
        } else if (indexPath.row == 3) {
            [self presentKeyboardEditing];
        } else if (indexPath.row == 4) {
            self.preview.layer.cornerRadius = 0;
        } else if (indexPath.row == 5) {
            self.preview.layer.cornerRadius = 25;
        } else if (indexPath.row == 6) {
            self.preview.layer.cornerRadius = 125;
        }
        
    } else if (indexPath.section == 1) {
        
        [self.textField resignFirstResponder];
        //self.previewImage.alpha = 0;
        self.emojiLabel.alpha = 0;
        self.stickerImage.alpha = 1;
        self.textField.alpha = 0;
        self.stickerImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Avatar/Stickers/%@", [self.stickersArray objectAtIndex:indexPath.row]]];
        
    } else if (indexPath.section == 2) {
        
        [self.textField resignFirstResponder];
        self.previewImage.alpha = 0;
        self.emojiLabel.alpha = 1;
        self.stickerImage.alpha = 0;
        self.textField.alpha = 0;
        
        TDAvatarIdentityPickerEmojiDataModel *emojiData = [self.emojisArray objectAtIndex:indexPath.row];
        self.preview.backgroundColor = [self colorWithHexString:emojiData.colour];
        self.emojiLabel.text = emojiData.emoji;
    }
    
    
}


-(void)presentPhotoPickerVC {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = false;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [self.textField resignFirstResponder];
    self.previewImage.alpha = 1;
    //self.stickerImage.alpha = 0;
    //self.emojiLabel.alpha = 0;
    //self.textField.alpha = 0;
    
    self.previewImage.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)presentColourPickerVC {
    [self.textField resignFirstResponder];
    UIColorPickerViewController *colourPickerVC = [[UIColorPickerViewController alloc] init];
    colourPickerVC.delegate = self;
    colourPickerVC.selectedColor = self.preview.backgroundColor;
    colourPickerVC.supportsAlpha = NO;
    [self presentViewController:colourPickerVC animated:YES completion:nil];
}


- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController{
    self.previewImage.alpha = 0;
    UIColor *cpSelectedColour = viewController.selectedColor;
    self.preview.backgroundColor = cpSelectedColour;
}


- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController{
    self.previewImage.alpha = 0;
    UIColor *cpSelectedColour = viewController.selectedColor;
    self.preview.backgroundColor = cpSelectedColour;
}


-(void)presentEmojiPickerVC {
    [self.textField resignFirstResponder];
    TDEmojiPickerViewController *vc = [[TDEmojiPickerViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)presentKeyboardEditing {
    
    self.emojiLabel.alpha = 0;
    //self.previewImage.alpha = 0;
    self.textField.alpha = 1;
    self.stickerImage.alpha = 0;
    self.emojiLabel.text = 0;
    
    [self.textField becomeFirstResponder];
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 2 && range.length == 0) {
        return NO;
    } else {
        return YES;
        
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.userInteractionEnabled = NO;
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    textField.userInteractionEnabled = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length >= 1) {
        [textField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void)didSelectEmoji:(NSString *)emoji {
    self.emojiLabel.alpha = 1;
    //self.previewImage.alpha = 0;
    self.textField.alpha = 0;
    self.stickerImage.alpha = 0;
    self.emojiLabel.text = emoji;
}


-(void)didDismissedEmojiPicker {
    NSLog(@"Emoji picker dismissed");
}


-(void)applyAvatar {
    
}


-(UIImage *)avatarSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(self.preview.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.preview.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    return snapshotImage;
}


-(UIColor*)colorWithHexString:(NSString*)hex {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


-(void)dismissVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(UIMenu *)optionsManager {
    
    UIAction *saveAction = [UIAction actionWithTitle:@"Save to photo library" image:[UIImage systemImageNamed:@"photo.fill"] identifier:nil handler:^(UIAction *action) {
        [self saveSticker];
    }];
    
    UIAction *shareAction = [UIAction actionWithTitle:@"Share" image:[UIImage systemImageNamed:@"square.and.arrow.up.fill"] identifier:nil handler:^(UIAction *action) {
        [self shareSticker];
    }];
    
    UIAction *resetAction = [UIAction actionWithTitle:@"Reset" image:[UIImage systemImageNamed:@"trash.fill"] identifier:nil handler:^(UIAction *action) {
        [self resetSticker];
    }];
    resetAction.attributes = UIMenuElementAttributesDestructive;
    
    return [UIMenu menuWithTitle:@"" children:@[saveAction, shareAction, resetAction]];
}


-(void)saveSticker {
    
    UIGraphicsBeginImageContextWithOptions(self.preview.frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.preview.layer renderInContext:context];
    UIImage *contextImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(contextImage, nil, nil, nil);
    
    [self showAlertWithTitle:@"Successful!" subtitle:@"Your Avimoji was saved to your photo library."];
}


-(void)shareSticker {
    
    UIGraphicsBeginImageContextWithOptions(self.preview.frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.preview.layer renderInContext:context];
    UIImage *contextImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSString *title = @"Avimoji";
    NSArray *dataToShare = @[contextImage, title];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:dataToShare applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:controller animated:YES completion:nil];
    
    
    [controller setCompletionWithItemsHandler:^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
    }];
    
}


-(void)resetSticker {
    self.preview.backgroundColor = [self colorWithHexString:@"a8e6cf"];
    self.preview.layer.cornerRadius = 125;
    self.previewImage.image = nil;
    self.stickerImage.image = nil;
    self.stickerImage.alpha = 0;
    self.emojiLabel.alpha = 1;
    self.emojiLabel.text = @"😀";
    self.textField.text = @"";
    self.textField.alpha = 0;
}


-(void)showAlertWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:subtitle preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
