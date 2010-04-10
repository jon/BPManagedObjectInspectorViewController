//
//  BPManagedObjectInspectorViewController.h
//
//  Created by Jon Olson on 2/9/10.
//  Copyright 2010 Source14 Platforms. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BPManagedObjectInspectorViewController : UIViewController {
	NSManagedObjectContext *managedObjectContext;	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObject *managedObject;

- (void)beginEditing;
- (void)endEditing;

- (void)updateView;
- (void)updateModel;

- (BOOL)beforeSave;
- (void)afterSave;
- (BOOL)beforeCreate;
- (void)afterCreate;
- (BOOL)beforeUpdate;
- (void)afterUpdate;
- (BOOL)beforeDestroy;
- (void)afterDestroy;

- (IBAction)create:(id)sender;
- (IBAction)rollback:(id)sender;
- (IBAction)update:(id)sender;
- (IBAction)destroy:(id)sender;

@end
