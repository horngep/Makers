//
//  CreatureViewController.m
//  MCMS
//
//  Created by I-Horng Huang on 29/07/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "CreatureViewController.h"

@interface CreatureViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end

@implementation CreatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameTextField.text = self.creature.name;
    self.descriptionTextField.text = self.creature.description;
    self.imageView.image =  self.creature.image;

}

- (IBAction)onEditButtonPressed:(id)sender {
    if ([self.editButton.titleLabel.text isEqualToString:@"Edit"]) {
        self.nameTextField.enabled = YES;
        self.descriptionTextField.enabled = YES;
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        self.nameTextField.enabled = NO;
        self.descriptionTextField.enabled = NO;
        self.creature.name = self.nameTextField.text;
        self.creature.description = self.descriptionTextField.text;
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

@end
