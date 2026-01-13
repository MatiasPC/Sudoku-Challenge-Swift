import SwiftUI
import Combine

struct SudokuView: View {
    
    @StateObject var viewModel = SudokuViewModel()
  
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(viewModel.puzzleIsWon() ? "You won": "")
                Text(viewModel.showError ? "Invalid move" : "Select a cell and a value")
                
                Spacer()
                
                Button(action:{
                    viewModel.resetGame()
                }) {
                    Text("Reset Grid")
                }
                
            }
            .padding(.horizontal)
            
            VStack(spacing: 1) {
                
                ForEach(0..<9, id: \.self) { row in
                    if row != 0 && row % 3 == 0 {
                        Spacer().frame(maxHeight: 2)
                    }
                    
                    HStack(spacing: 1) {
                        
                        ForEach(0..<9, id: \.self) { col in
                            if col != 0 && col % 3 == 0 {
                                Spacer().frame(minWidth: 2)
                            }
                            
                            cellView(row, col)
                        }
                        
                    }
                    
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            
            NumericPad { value in
                viewModel.setValue(value: value)
            }
            
            HStack(spacing: 25) {
                Button(action: {viewModel.generateNewPuzzle(n: 35)}) {
                    Text("Easy")
                        .font(.title)
                        .padding()
                        .foregroundStyle(Color.black)
                        .contentShape(Rectangle())
                        .background(Color.green.opacity(0.5))
                        .cornerRadius(8)
                }
                
                Button(action: {viewModel.generateNewPuzzle(n: 20)}) {
                    Text("Medium")
                        .font(.title)
                        .padding()
                        .foregroundStyle(Color.black)
                        .contentShape(Rectangle())
                        .background(Color.orange.opacity(0.5))
                        .cornerRadius(8)
                }
                
                Button(action: {viewModel.generateNewPuzzle(n: 10)}) {
                    Text("Hard")
                        .font(.title)
                        .padding()
                        .foregroundStyle(Color.black)
                        .contentShape(Rectangle())
                        .background(Color.red.opacity(0.5))
                        .cornerRadius(8)
                }
            }
          
            
            .padding()
        }
    }
    
    @ViewBuilder
    func cellView(_ row: Int, _ col: Int) -> some View {
        ZStack {
            if viewModel.isCellSelected(row, col) {
                Color.blue.opacity(0.8)
            } else if viewModel.isHighlighted(row, col) {
                Color.gray.opacity(0.5)
            } else {
                Color.gray.opacity(0.2)
            }
            Text(viewModel.getStringValue(row, col: col))
        }
        .frame(width: 40, height: 40)
        .onTapGesture {
            viewModel.selectCell(row, col)
        }
    }
    
}


struct NumericPad: View {
    var onAction: (Int?) -> Void
    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(1...9, id: \.self) { num in
                Button(action: { onAction(num) }) {
                    Text("\(num)")
                        .font(.title)
                        .clipShape(Rectangle())
                        .foregroundStyle(Color.black)
                        .cornerRadius(8)
                        .frame(width: .infinity, height: 60)
                }

            }
            Button(action: { onAction(nil) }) {
                Text("Delete")
            }
        }
        
    }
}

#Preview {
    SudokuView()
}
