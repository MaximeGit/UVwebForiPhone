//
//  AddCommentViewController.m
//  UVweb
//
//  Created by Maxime on 25/06/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()

//UI view models
@property (nonatomic, strong) NSArray *interestPedagogyLabels;
@property (nonatomic, strong) NSArray *utilityLabels;
@property (nonatomic, strong) NSArray *workAmountLabels;
@property (nonatomic, strong) NSArray *semesters;

@end

@implementation AddCommentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Disabling possibility to send comment while comment text field is empty
    _validateCommentButton.enabled = NO;
    
    //Getting text data for multiple choice UI elements
    _interestPedagogyLabels = [UVwebCommentData interestPedagogyData];
    _utilityLabels = [UVwebCommentData utilityData];
    _workAmountLabels = [UVwebCommentData workAmountData];
    
    _semesters = [UVwebCommentData mostRecentSemesters];
    
    //Setting initial label texts for multiple choice UI elements
    [_interestLabel setText:[_interestPedagogyLabels lastObject]];
    [_pedagogyLabel setText:[_interestPedagogyLabels lastObject]];
    [_utilityLabel setText:[_utilityLabels lastObject]];
    [_workAmountLabel setText:[_workAmountLabels lastObject]];
    
    //Listening to global rate text field changes
    [_globalRateTextField addTarget:self action:@selector(globalRateTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_globalRateTextField addTarget:self action:@selector(globalRateTextFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    //Listening to sliders' changes
    [_interestSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [_pedagogySlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [_utilitySlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [_workAmountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //Listening to text view changes to enable user comment submission if the comment is not empty
    _commentTextView.delegate = self;
    
    //Tap gesture recognizer used to dismiss keyboard when user single taps outside a text field
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    
    [self.tableView addGestureRecognizer:singleTap1];
    [self.navigationController.navigationBar addGestureRecognizer:singleTap2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *___________________________________________________
 * Functions handling UI widget changes
 */

- (IBAction)globalRateTextFieldDidChange:(id)sender
{
    int globalRate = [_globalRateTextField.text intValue];
    
    if(globalRate > 10)
    {
        globalRate = 10;
    }
    else if(globalRate < 0)
    {
        globalRate = 0;
    }
    
    //Removing "0" before numbers if the user tries to enter "01" for instance
    _globalRateTextField.text = [NSString stringWithFormat:@"%i", globalRate];
}

- (IBAction)globalRateTextFieldDidEndEditing:(id)sender
{
    if([_globalRateTextField.text length] == 0)
    {
        _globalRateTextField.text = @"0";
    }
}

//Sliders' changes
- (IBAction)sliderValueDidChange:(UISlider*)sender
{
    float sliderNewValue = ceilf(sender.value);
    
    [sender setValue:sliderNewValue];
    
    NSString *textFieldNewValue = [NSString stringWithFormat:@"%i", (int)sliderNewValue];
    
    if(sender == _interestSlider)
    {
        [_interestTextField setText:textFieldNewValue];
        [_interestLabel setText:[_interestPedagogyLabels objectAtIndex:(int)sliderNewValue - 1]];
    }
    else if(sender == _pedagogySlider)
    {
        [_pedagogyTextField setText:textFieldNewValue];
        [_pedagogyLabel setText:[_interestPedagogyLabels objectAtIndex:(int)sliderNewValue - 1]];
    }
    else if(sender == _utilitySlider)
    {
        [_utilityTextField setText:textFieldNewValue];
        [_utilityLabel setText:[_utilityLabels objectAtIndex:(int)sliderNewValue - 1]];
    }
    else if(sender == _workAmountSlider)
    {
        [_workAmountTextField setText:textFieldNewValue];
        [_workAmountLabel setText:[_workAmountLabels objectAtIndex:(int)sliderNewValue - 1]];
    }
}

//Comment TextView delegate's methods
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == _commentTextView)
    {
        if([_commentTextView.text length] != 0)
        {
            _validateCommentButton.enabled = YES;
        }
        else
        {
            _validateCommentButton.enabled = NO;
        }
    }
}

/**
 *___________________________________________________
 * UIAction sheet for semester methods
 */
//Action sheet to chose a semester
- (IBAction)showSemesterActionSheet:(id)sender
{
    UIActionSheet *semesterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Semestre"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:nil];
    
    for (NSString* semesterName in _semesters) {
        [semesterActionSheet addButtonWithTitle:semesterName];
    }
    
    [semesterActionSheet addButtonWithTitle:@"Annuler"];
    semesterActionSheet.cancelButtonIndex = [_semesters count];
    
    [semesterActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    //Updating the semester button's text
    [_semesterButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
}

/**
 * Green UVweb color for action sheet buttons
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor uvwebColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor uvwebColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor uvwebColor] forState:UIControlStateHighlighted];
        }
    }
}

/**
 *__________________________________________________
 *
 */
- (IBAction)sendCommentToServer:(id)sender
{
    //Passed should be lowercased for the server DB
    NSString *passed = [[_obtainedUvSegmentedControl titleForSegmentAtIndex:[_obtainedUvSegmentedControl selectedSegmentIndex]] lowercaseString];
    
    NSDictionary *newComment = @{
                                 @"comment": _commentTextView.text,
                                 @"interest": _interestLabel.text,
                                 @"utility": _utilityLabel.text,
                                 @"workAmount": _workAmountLabel.text,
                                 @"pedagogy": _pedagogyLabel.text,
                                 @"semester": _semesterButton.titleLabel.text,
                                 @"passed": passed,
                                 @"globalRate": _globalRateTextField.text
                                 };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newComment
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", jsonString);
    }
    
    //Sending comment to server
    [[UVwebSessionManager sharedSessionManager] sendCommentToServer:newComment username:_username password:_password uv:_uv delegate:self];
}

/**
 *___________________________________________________
 * Server replies delegate
 */
- (void)serverDidNotAcceptComment:(int)statusCode answer:(NSString*)answer
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:answer delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [errorAlertView show];
}

- (void) serverDidAcceptComment
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Merci !" message:@"Commentaire ajouté avec succès. Il sera bientôt validé !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [errorAlertView show];
}

//Only called when server validated comment: return
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self cancel:self];
}

/**
 *___________________________________________________
 * Functions handling cancel and done actions
 */
- (IBAction)cancel:(id)sender
{
    [_delegate addCommentViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [_delegate addCommentViewControllerDidAddComment:self];
}

/**
 *___________________________________________________
 * Tap gesture for keyboard function
 */
-(void)singleTap:(UITapGestureRecognizer *)sender
{
    //Dismissing keyboard after single tap.
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.reuseIdentifier isEqualToString:@"obtainedCell"] || [cell.reuseIdentifier isEqualToString:@"semesterCell"] || [cell.reuseIdentifier isEqualToString:@"utilityCell"] || [cell.reuseIdentifier isEqualToString:@"interestCell"] || [cell.reuseIdentifier isEqualToString:@"pedagogyCell"] || [cell.reuseIdentifier isEqualToString:@"workAmountCell"]) {
        cell.backgroundColor = [UIColor uvwebColor];
    }
}


@end
