//
//  SudokuModel.swift
//  Sudoku2
//
//  Created by Matias Peralta Charro on 11/01/2026.
//
import Playgrounds
class SudokuModel {
    
    var grid: [[Int?]] = []
    var subgrids: [[Set<Int>]] = []
    var count = 0
    var size = 9
    
    
    init() {
        newGrid()
        newSubgrid()
    }
    
    func newGrid() {
        grid = Array(repeating: Array(repeating: nil, count: 9),count: 9)
        count = 0
    }
    
    func newSubgrid() {
        for _ in 0..<3 {
            var row = [Set<Int>]()
            for _ in 0..<3 {
                let set = Set<Int>()
                row.append(set)
            }
            subgrids.append(row)
        }
    }
    
    private func isValidMove(value: Int?, _ row: Int, _ col: Int) -> Bool {
        guard let validValue = value, value != grid[row][col] else {
            return true
        }
        
        // check row
        guard !grid[row].contains(value) else {
            return false
        }
        
        // check col
        guard !grid.contains(where: { $0[col] == value }) else {
            return false
        }
        
        
//        check subgrid
        let sRow = row / 3
        let sCol = col / 3
        
        return !subgrids[sRow][sCol].contains(validValue)
    }
    
    
    func setValue(value: Int?, _ row: Int, _ col: Int) -> Bool {
        
        // if previous return
        guard isValidMove(value: value, row, col) else {
            return false
        }
        // if it is nil, clean cell
        
        guard let validValue = value else {
            cleanCell(row, col)
            return true
        }
        
        //add value
        
        addValue(value: validValue, row, col)
        return true
    }
    
    private func cleanCell(_ row: Int, _ col: Int) {
        guard let prevValue = grid[row][col] else {
            return
        }
        
        let sRow = row / 3
        let sCol = col / 3
        
        subgrids[sRow][sCol].remove(prevValue)
        
        grid[row][col] = nil
        count -= 1
    }
    
    private func addValue(value: Int, _ row: Int, _ col: Int) {
        if grid[row][col] != nil {
            cleanCell(row,col)
        }
        
        let sRow = row / 3
        let sCol = col / 3
        
        subgrids[sRow][sCol].insert(value)
        
        grid[row][col] = value
        count += 1
        
    }
    
    func getValue(_ row: Int, _ col: Int) -> Int? {
        grid[row][col]
    }
    
    func generatePuzzle(n: Int) {
        newGrid()
        subgrids = []
        newSubgrid()
        var count = 0
        
        while count < n {
            
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            let value = Int.random(in: 1...9)

            if isValidMove(value: value, row, col) {
                count += 1
                addValue(value: value, row, col)
            }
            
        }
    }
    
    func puzzleIsComplete() -> Bool {
        return count == (size * size)
    }
    
}
