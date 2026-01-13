//
//  SudokuViewModel.swift
//  Sudoku2
//
//  Created by Matias Peralta Charro on 11/01/2026.
//

import Playgrounds
import Combine

class SudokuViewModel: ObservableObject {
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var showError = false
    
    let model = SudokuModel()
    
    
    func getValue(_ row: Int, _ col: Int) -> Int? {
        return model.getValue(row, col)
    }
    
    func getStringValue(_ row: Int, col: Int) -> String {
        if let value = getValue(row,col) {
            return String(value)
        } else {
            return " "
        }
    }
    
    func selectCell(_ row: Int, _ col: Int) {
        selectedCell = (row, col)
        showError = false
    }
    
    func setValue(value: Int?) {
        guard let sSelectedCell = selectedCell else { return }
        
        objectWillChange.send()
        
        let success = model.setValue(value: value, sSelectedCell.row, sSelectedCell.col)
        
        if !success {
            showError = true
        }
        
    }
    
    func resetGame() {
        model.newGrid()
        model.newSubgrid()
        selectedCell = nil
        showError = false
    }
    
    func generateNewPuzzle(n: Int) {
        objectWillChange.send()
        model.generatePuzzle(n: n)
        showError = false
        selectedCell = nil
    }
    
    func isHighlighted(_ row: Int, _ col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        
        if row == selected.row || col == selected.col { return true }
        
        let sRow = row / 3
        let sCol = col / 3
        
        let sgRow = selected.row / 3
        let sgCol = selected.col / 3
        
        return sRow == sgRow && sCol == sgCol
        
    }
    
    func isCellSelected(_ row: Int, _ col: Int) -> Bool {
        guard let selectedCell = selectedCell else { return false }
        return selectedCell.row == row && selectedCell.col == col
    }
    
    func puzzleIsWon() -> Bool {
        return model.puzzleIsComplete()
    }
}

