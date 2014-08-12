//
//  ViewController.m
//  MCMS
//
//  Created by I-Horng Huang on 29/07/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ViewController.h"
#import "MagicalCreature.h"
#import "CreatureViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MagicalCreature *creature1 = [[MagicalCreature alloc]initWithName:@"creature1" image:[UIImage imageNamed:@"one"] andDescription:@"des1"];
    MagicalCreature *creature2 = [[MagicalCreature alloc]initWithName:@"creature2" image:[UIImage imageNamed:@"two"] andDescription:@"des2"];
    MagicalCreature *creature3 = [[MagicalCreature alloc]initWithName:@"creature3" image:[UIImage imageNamed:@"three"] andDescription:@"des3"];

    self.creatures = [NSMutableArray arrayWithObjects:creature1, creature2, creature3, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - action

- (IBAction)addButtonPressed:(id)sender {

    MagicalCreature *creature = [MagicalCreature new];
    creature.name = self.textField.text;
    [self.creatures addObject:creature];

    [self.tableView reloadData];
    [self.textField resignFirstResponder];
    self.textField.text = @"";
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"ShowCreatureSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MagicalCreature *creature = [self.creatures objectAtIndex:indexPath.row];
        CreatureViewController *vc = segue.destinationViewController;
        vc.creature = creature;
    }
}


#pragma mark - delegation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.creatures.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    MagicalCreature *creature = [self.creatures objectAtIndex:indexPath.row];
    cell.textLabel.text = creature.name;
    cell.detailTextLabel.text = creature.description;
    return cell;
}



@end
