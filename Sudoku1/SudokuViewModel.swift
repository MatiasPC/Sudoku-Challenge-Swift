
//
//  SudokuViewModel.swift
//  Sudoku1
//
//  Created by Matias Peralta Charro on 04/01/2026.
//

import Foundation
import Combine
import Playgrounds

class SudokuViewModel: ObservableObject {
    
    // MARK: - 1. Properties (State)
    
    // 🗣️ Cue: "The ViewModel owns the Model. Since the Model is a class, I need to manually notify the View when it changes."
    let model: SudokuModel = SudokuModel()
    
    // 🗣️ Cue: "I use a Tuple (row, col) to track the currently selected cell. If nil, nothing is selected."
    @Published var selectedCell: (row: Int, col: Int)? = nil
    
    // 🗣️ Cue: "This boolean triggers visual feedback (like red text) when the user makes an invalid move."
    @Published var showError = false
    
    // MARK: - 2. Data Access (Getters)
    
    // 🗣️ Cue: "The View shouldn't access the Model directly. These pass-through methods keep the architecture clean."
    func getValue(_ row: Int, _ col: Int) -> Int? {
        return model.getValue(row, col)
    }
    
    // MARK: - 2. User Intents (Actions)
    
    // 🗣️ Cue: "When the user taps a cell, I update the selection and clear any previous error states."
    func selectCell(_ row: Int, _ col: Int) {
        selectedCell = (row, col)
        showError = false
    }
    
    // 🗣️ Cue: "This is the primary action. It accepts an Optional Int so we can handle both numbers and the 'Erase' action."
    func setValue(value: Int?) {
        guard let selected = selectedCell else { return }
        showError = false
        
        // 🗣️ Cue: "Crucial Step: Since 'grid' inside the model isn't @Published, I must manually trigger the UI update."
        objectWillChange.send()
        
        let success = model.setValue(value: value, selected.row, selected.col)
        
        if !success {
            showError = true
        }
    }
    
    // MARK: - 3. Game Management
    
    // 🗣️ Cue: "Resets the game state locally and in the model."
    func resetGame() {
    //    objectWillChange.send()
        model.newGrid()
        model.newSubgrids()
        selectedCell = nil
        showError = false
    }
    
    // 🗣️ Cue: "Generates a new puzzle based on difficulty (number of clues)."
    func generateNewPuzzle(n: Int) {
        objectWillChange.send()
        model.generatePuzzle(n: n)
        selectedCell = nil
        showError = false
    }
    
    // MARK: - 4. Visual Logic (The "Smart" UI Helpers)
    
    // 🗣️ Cue: "This logic determines if a cell should be highlighted. It checks Row, Column, and the 3x3 Subgrid."
    func isHighlighted(_ row: Int, _ col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        
        // 1. Same Row or Column
        if row == selected.row || col == selected.col { return true }
        
        // 2. Same 3x3 Block logic
        let selectedRowBlock = selected.row / 3
        let selectedColBlock = selected.col / 3
        
        let currentRowBlock = row / 3
        let currentColBlock = col / 3
        
        return selectedRowBlock == currentRowBlock && selectedColBlock == currentColBlock
    }
    
    // 🗣️ Cue: "Helper to tell the view exactly which cell is the active one."
    func isCellSelected(_ row: Int, _ col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        return selected.row == row && selected.col == col
    }
    
    // MARK: - 5. Win State
    
    // 🗣️ Cue: "I check if the puzzle is complete and ensure no error flags are currently active."
    func puzzleIsWon() -> Bool {
        return !showError && model.puzzleIsComplete()
    }
}
