//
//  ABUUIDTextField.m
//  AprilBeacon
//
//  Created by liaojinhua on 14-8-8.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "YKSAddressTextField.h"
#import "YKSAreaManager.h"

@interface YKSAddressTextField () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;


@end

@implementation YKSAddressTextField

- (instancetype)init
{
    if (self = [super init]) {
        [self addAssistantView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self addAssistantView];
}

- (void)addAssistantView
{
    self.delegate = self;
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.inputView = self.pickerView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!textField.text || textField.text.length == 0) {
        self.text = [_datas firstObject][@"name"];
        _currentInfo = [_datas firstObject];
        [self.pickerView reloadAllComponents];
    }
    return YES;
}

- (NSString *)text
{
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < _datas.count) {
        self.text = _datas[row][@"name"];
        _currentInfo = _datas[row];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _datas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _datas[row][@"name"];
}


@end
