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
    
}
