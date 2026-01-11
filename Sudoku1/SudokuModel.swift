//
//  SudokuModel.swift
//  Sudoku1
//
//  Created by Matias Peralta Charro on 04/01/2026.
//

import Foundation
import Playgrounds

class SudokuModel {
    
    // MARK: - 1. Properties (Game State)
    
    // 🗣️ Cue: "I'll use a 2D array of Optionals for the grid, where nil represents an empty cell."
    var grid: [[Int?]] = []
    
    // 🗣️ Cue: "For the 3x3 subgrids, I'll use a matrix of Sets. This gives me O(1) lookup time when checking constraints."
    var subgrids: [[Set<Int>]] = []
    
    // 🗣️ Cue: "A simple counter helps me track game progress without iterating the whole grid every time."
    var completedCells: Int = 0
    let size = 9
    
    // MARK: - 2. Initialization
    
    init() {
        // 🗣️ Cue: "I'll initialize the data structures immediately."
        newGrid()
        newSubgrids()
    }
    
    // MARK: - 3. Setup Methods (Private)
    
    // 🗣️ Cue: "This helper resets the grid to a 9x9 matrix of nils."
    func newGrid() {
        grid = Array(repeating: Array(repeating: nil, count: size), count: size)
        completedCells = 0
    }
    
    // 🗣️ Cue: "Here I build the 3x3 matrix of empty Sets to track the subgrid constraints."
    func newSubgrids() {
        subgrids = [] // Important: clear previous state to prevent appending infinitely
        for _ in 0..<3 {
            var row = [Set<Int>]()
            for _ in 0..<3 {
                row.append(Set<Int>())
            }
            subgrids.append(row)
        }
    }
    
    // MARK: - 4. Validation Logic (Core)
    
    // 🗣️ Cue: "This is the core logic. I need to check row, column, and subgrid constraints before allowing a move."
    private func isValidMove(value: Int?, _ row: Int, _ col: Int) -> Bool {
        // 1. If value is nil (clearing), it's always valid.
        // 2. If it's the same value currently in the cell, no change needed.
        guard let value = value, value != grid[row][col] else { return true }
        
        // 🗣️ Cue: "Check the Row..."
        guard !grid[row].contains(value) else { return false }
        
        // 🗣️ Cue: "Check the Column..."
        guard !grid.contains(where: { $0[col] == value }) else { return false }
        
        // 🗣️ Cue: "Check the 3x3 Subgrid..."
        guard !getSubgrid(row, col).contains(value) else { return false }
        
        return true
    }
    
    // Helper to get the correct Set for a coordinate
    private func getSubgrid(_ row: Int, _ col: Int) -> Set<Int> {
        let sRow = row / 3
        let sCol = col / 3
        return subgrids[sRow][sCol]
    }
    
    // MARK: - 5. Value Management (Public API)
    
    // 🗣️ Cue: "This is the main public method. It handles validation, overwriting, and deletion."
    func setValue(value: Int?, _ row: Int, _ col: Int) -> Bool {
        
        // 1. Validate the move
        guard isValidMove(value: value, row, col) else { return false }
        
        // 2. Handle deletion (nil) vs insertion
        guard let value = value else {
            cleanCell(row, col)
            return true
        }
        
        // 3. Add value
        addValue(value: value, row, col)
        return true
    }
    
    // 🗣️ Cue: "When adding a value, I handle the edge case where we overwrite an existing number."
    private func addValue(value: Int, _ row: Int, _ col: Int) {
        if grid[row][col] != nil {
            cleanCell(row, col) // Remove old value first to keep counts correct
        }
        
        grid[row][col] = value
        
        let sRow = row / 3
        let sCol = col / 3
        subgrids[sRow][sCol].insert(value)
        
        completedCells += 1
    }
    
    // 🗣️ Cue: "Cleaning a cell involves removing it from the grid, the subgrid Set, and decrementing the counter."
    private func cleanCell(_ row: Int, _ col: Int) {
        guard let prevValue = grid[row][col] else { return }
        
        grid[row][col] = nil
        
        let sRow = row / 3
        let sCol = col / 3
        subgrids[sRow][sCol].remove(prevValue)
        
        completedCells -= 1
    }
    
    // MARK: - 6. Helpers (Utilities)
    
    // 🗣️ Cue: "Simple getters to expose data to the ViewModel safely."
    func getValue(_ row: Int, _ col: Int) -> Int? {
        return grid[row][col]
    }
    
    // MARK: - 7. Puzzle Generation
    
    // 🗣️ Cue: "I generate random numbers inside the loop to avoid infinite loops and mark clues as fixed."
    func generatePuzzle(n: Int) {
        newGrid()
        newSubgrids()
        
        var count = 0
        while count < n {
            let rRow = Int.random(in: 0..<9)
            let rCol = Int.random(in: 0..<9)
            let val = Int.random(in: 1...9)
            
            // Only add if empty and valid
            if grid[rRow][rCol] == nil && isValidMove(value: val, rRow, rCol) {
                addValue(value: val, rRow, rCol)
                count += 1
            }
        }
    }
    
    // MARK: - 8. Game State
    
    // 🗣️ Cue: "Since I maintain a running counter, checking for victory is an O(1) operation."
    func puzzleIsComplete() -> Bool {
        return completedCells == (size * size)
    }
}
