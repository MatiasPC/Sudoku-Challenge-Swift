//
//  SudokuView.swift
//  Sudoku1
//
//  Created by Matias Peralta Charro on 04/01/2026.
//

import SwiftUI

struct SudokuView: View {
    @StateObject var viewModel = SudokuViewModel()
    
    var body: some View {
            VStack(spacing: 20) {

                // MARK: - Status & Reset
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.puzzleIsWon() ? "Match Complete!" : "Playing...")
                            .font(.caption)
                            .bold()
                            .foregroundColor(viewModel.puzzleIsWon() ? .green : .secondary)

                        if viewModel.showError {
                            Text("Invalid Move")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    Spacer()

                    Button(action: { viewModel.resetGame() }) {
                        Text("Reset")
                            .font(.caption)
                            
                    }
                }
                .padding(.horizontal)

                // MARK: - Sudoku Grid
                SudokuGridView(viewModel: viewModel)

                Spacer()

                // MARK: - Number Pad
                NumberPadView { number in
                    viewModel.setValue(value: number)
                }

                // MARK: - Difficulty Selection
                VStack(spacing: 8) {
                    Text("New Game")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    HStack(spacing: 15) {
                        difficultyButton(label: "Easy", clues: 35, color: .green)
                        difficultyButton(label: "Medium", clues: 25, color: .orange)
                        difficultyButton(label: "Hard", clues: 15, color: .red)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Sudoku")
            .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Difficulty Button Helper
    func difficultyButton(label: String, clues: Int, color: Color) -> some View {
        Button(label) {
            withAnimation {
                viewModel.generateNewPuzzle(n: clues)
            }
        }
        .buttonStyle(.bordered)
        .tint(color)
    }
}

// MARK: - GRID COMPONENT
struct SudokuGridView: View {
    @ObservedObject var viewModel: SudokuViewModel

    private let boardSize: CGFloat = 360
    private let spacing: CGFloat = 1

    var body: some View {
        let cellSize = (boardSize - spacing * 8) / 9

        Grid(horizontalSpacing: 1, verticalSpacing: 1) {
            ForEach(0..<9, id: \.self) { row in
                if row != 0 && row % 3 == 0 {
                    Spacer().frame(height: 1)
                }
                GridRow {
                    ForEach(0..<9, id: \.self) { col in
                        if col != 0 && col % 3 == 0 {
                            Spacer().frame(width: 1)
                        }
                        CellView(
                            value: viewModel.getValue(row, col),
                            isSelected: viewModel.isCellSelected(row, col),
                            isHighlighted: viewModel.isHighlighted(row, col)
                        )
                        .frame(width: cellSize, height: cellSize)
                        .onTapGesture {
                            viewModel.selectCell(row, col)
                        }
                    }
                }
            }
        }
//        .frame(width: boardSize, height: boardSize)
        .padding()
      //  .background(Color.gray.opacity(0.6))
    }
}

// MARK: - CELL COMPONENT
// MARK: - CELL COMPONENT
struct CellView: View {
    let value: Int?
    let isSelected: Bool
    let isHighlighted: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)

            Text(value.map(String.init) ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.blue.opacity(0.25)
        }

        if isHighlighted {
            // Neutral fixed highlight (NO primary)
            return Color.gray.opacity(0.9)
        }

        return Color.gray.opacity(0.5)
    }
}


// MARK: - NUMBER PAD
struct NumberPadView: View {
    var onAction: (Int?) -> Void
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1...9, id: \.self) { num in
                Button {
                    onAction(num)
                } label: {
                    Text("\(num)")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(10)
                }
            }

            Button {
                onAction(nil)
            } label: {
                Image(systemName: "eraser.fill")
                    .font(.title2)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.secondary.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SudokuView()
}
