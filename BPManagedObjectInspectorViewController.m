//
//  BPManagedObjectInspectorViewController.m
//
//  Created by Jon Olson on 2/9/10.
//  Copyright 2010 Source14 Platforms. All rights reserved.
//

#import "BPManagedObjectInspectorViewController.h"


@interface BPManagedObjectInspectorViewController (Private)

@end

@implementation BPManagedObjectInspectorViewController

#pragma mark -
#pragma mark Construction and deallocation

- (id)init {
	if (self = [super initWithNibName:nil bundle:nil]) {
		
	}
	
	return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

@synthesize managedObjectContext;

- (NSManagedObject *)managedObject {
	NSAssert(NO, @"Subclasses of BPManagedObjectInspectorViewController must implement managedObject");
	return nil;
}

- (void)setManagedObject:(NSManagedObject *)aManagedObject {
	NSAssert(NO, @"Subclasses of BPManagedObjectInspectorViewController must implement setManagedObject:");
}

#pragma mark -
#pragma mark View loading and unloading

// Subclasses should override this
- (void)loadView {
	UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view = view;
	[view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!self.navigationItem.rightBarButtonItem)
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark View hiding and showing

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateView];
}

#pragma mark -
#pragma mark Rotation is cool with ushort

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Toggling editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	UITableView *tableView = nil;
	if ([self respondsToSelector:@selector(tableView)])
		tableView = [(id)self tableView];
	[tableView beginUpdates];
	if (!self.editing && editing) {
		[self beginEditing];
		if (!self.navigationItem.leftBarButtonItem) {
			showsCancelButton = YES;
			UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rollback:)] autorelease];
			[self.navigationItem setHidesBackButton:YES animated:YES];
			[self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];			
		}
		[super setEditing:YES animated:animated];
	}
	else if (self.editing && !editing) {
		[self updateModel];
		[self update:self];
		if (![self.managedObjectContext hasChanges]) {
			// Update worked, no changes
			if (showsCancelButton) {
				[self.navigationItem setHidesBackButton:NO animated:YES];
				[self.navigationItem setLeftBarButtonItem:nil animated:YES];
				showsCancelButton = NO;
			}
			[super setEditing:NO animated:animated];
			[self endEditing];
		}
	}
	[tableView endUpdates];
}

#pragma mark -
#pragma mark Model-View synchronization

- (void)updateModel {
	// Stub
}

- (void)updateView {
	// Stub
}

#pragma mark -
#pragma mark Editing hooks

- (void)beginEditing {
	// Stub
}

- (void)endEditing {
	// Stub
}

#pragma mark -
#pragma mark CRUD hooks

- (BOOL)beforeSave {
	return YES;
}

- (void)afterSave {
	
}

- (BOOL)beforeCreate {
	return YES;
}

- (void)afterCreate {
	
}

- (BOOL)beforeUpdate {
	return YES;
}

- (void)afterUpdate {
	
}

- (BOOL)beforeDestroy {
	return YES;
}

- (void)afterDestroy {
	
}

#pragma mark -
#pragma mark Default UI actions

- (IBAction)create:(id)sender {
	[self updateModel];
	if (![self beforeCreate])
		return;
	if (![self beforeSave])
		return;
	NSError *error = nil;
	if (![self.managedObjectContext save:&error])
		[[[[UIAlertView alloc] initWithTitle:@"Error Creating Object" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
	else {
		[self afterSave];
		[self afterCreate];
	}
}

- (IBAction)update:(id)sender {
	[self updateModel];
	if (![self beforeUpdate])
		return;
	if (![self beforeSave])
		return;
	NSError *error = nil;
	if (![self.managedObjectContext save:&error])
		[[[[UIAlertView alloc] initWithTitle:@"Error Saving Changes" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];	
	else {
		[self afterSave];
		[self afterUpdate];
	}
}

- (IBAction)rollback:(id)sender {
	[self.managedObjectContext rollback];
	[self setEditing:NO animated:YES];
	[self updateView];
}

- (IBAction)destroy:(id)sender {
	if (![self beforeDestroy])
		return;
	[self.managedObjectContext deleteObject:self.managedObject];
	NSError *error = nil;
	if (![self.managedObjectContext save:&error])
		[[[[UIAlertView alloc] initWithTitle:@"Error Canceling" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];	
	else
		[self afterDestroy];
}

@end
