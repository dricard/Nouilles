//
//  FirebaseEvent.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-03-01.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

enum Names {
    
    // MARK: - Nouilles detail view
    
    static let timerStartedEvent = "detail_start_timer"
    static let editButtonTappedEvent = "detail_edit_tapped"
    static let availableButtonTappedEvent = "detail_available_tapped"
    static let mealSizeButtonTappedEvent = "detail_meal_size_tapped"
    static let segmentedControlTappedEvent = "detail_segmented_tapped"
    static let pictureTappedEvent = "detail_picture_tapped"
    static let longNoodlesUnitsButtonTappedEvent = "detail_long_noodles_portion_tapped"

    // MARK: - Add Noodle view
    
    static let scanBarcodeButtonTapped = "add_barcode_tapped"
    static let saveNoodleButtonTapped = "add_save_tapped"
    static let cancelSaveNoodleButtonTapped = "add_cancel_tapped"
    
    // MARK: - Filter view
    
    static let selectFilterEvent = "filter_select_section_row"
    static let filterSelectedKey = "filter_selected"
    
    // MARK: - About VC
    
    static let viewAboutPageEvent = "about_view"
    static let helpButtonTappedEvent = "about_help_tapped"
    static let supportButtonTappedEvent = "about_support_tappedf"
    
    // MARK: - Edit view
    
    static let editParameterSelectedEvent = "edit_parameter_selected"
    static let parameterSelectedKey = "parameter_selected"
    
    // MARK: - Edit value view
    
    static let saveChangesButtonTapped = "change_save_tapped"
    static let cancelChangesButtonTapped = "change_cancel_tapped"
    
    // MARK: - Timer view
    
    static let timerPausePlayButtonTapped = "timer_pause_play_tapped"
    static let timerCancelButtonTapped = "timer_cancel_tapped"
    
    // MARK: - List view
    
    static let listSwipeDelete = "list_swipe_delete_action"
    static let listSwipeAvailable = "list_swipe_available_action"
    static let listSwipePausePlay = "list_pause_play_action"
    static let listSwipeStartTimer = "list_start_timer_action"
    static let listSwipeCancelTimer = "list_cancel_timer_action"
    static let listPresentNotificationsReminder = "list_notification_reminder_view"
    static let listDoNotRemindEverSelected = "list_do_not_remind_selected"
    
    // MARK: - Take Picture view
    
    static let pictureCameraTapped = "picture_camera_tapped"
    static let pictureAlbumTapped = "picture_album_tapped"
    
}
