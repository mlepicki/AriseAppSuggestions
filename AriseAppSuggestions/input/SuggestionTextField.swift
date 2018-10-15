//
//  SuggestionTextField.swift
//  AriseAppSuggestions
//
//  Created by Marcin Lepicki on 15/10/2018.
//  Copyright © 2018 Marcin Łępicki. All rights reserved.
//

import UIKit

enum SuggestionTextFieldInputMode {
    case text
    case suggestions
}

class SuggestionTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let toolbar = UIToolbar()
    private let textInputBarButtonItem = UIBarButtonItem(title: "Type value", style: .plain, target: self, action: #selector(textModeSelected))
    private let suggestionsBarButtonItem = UIBarButtonItem(title: "Choose value", style: .plain, target: self, action: #selector(suggestionsModeSelected))
    private let spacerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneSelected))
    
    private var mode: SuggestionTextFieldInputMode = .text {
        didSet {
            updateToolbarActions()
            updateTextInputView()
        }
    }
    
    // Make it configurable so view can be reused
    private var suggestions: [String?] = [nil, "10g", "20g", "50g", "200g"]

    // MARK: initializers and view setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupInputAccessoryView()
        updateToolbarActions()
    }
    
    private func setupInputAccessoryView() {
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // MARK: updating to mode
    private func updateToolbarActions() {
        switch mode {
        case .text:
            toolbar.items = [suggestionsBarButtonItem, spacerBarButtonItem, doneBarButtonItem]
        case .suggestions:
            toolbar.items = [textInputBarButtonItem, spacerBarButtonItem, doneBarButtonItem]
        }
    }
    
    private func updateTextInputView() {
        switch mode {
        case .text:
            inputView = nil
            
        case .suggestions:
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.showsSelectionIndicator = true
            inputView = pickerView
        }
        reloadInputViews()
    }
    
    // MARK: bar button item handlers
    @objc func suggestionsModeSelected() {
        mode = .suggestions
    }
    
    @objc func textModeSelected() {
        mode = .text
    }
    
    @objc func doneSelected() {
        resignFirstResponder()
    }

    
    // MARK: UIPickerViewDataSource and UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return suggestions.count
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return suggestions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = suggestions[row]
    }

}
