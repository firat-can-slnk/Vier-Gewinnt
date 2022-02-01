//
//  GameModel.swift
//  Vier Gewinnt
//
//  Created by Firat Sülünkü on 01.02.22.
//

import Foundation
import SwiftUI

public class GameModel
{
    let gameField: GameField = .init()
}

public class GameField: ObservableObject
{
    public static let rows = 6
    public static let columns = 7
    
    internal init() {
        
        self.field = .init(repeating: .init(repeating: .init(player: .none), count: GameField.rows), count: GameField.columns)
        
        for column in 0..<GameField.columns {
            for row in 0..<GameField.rows
            {
                self.field[column][row] = .init(player: .none)
            }
        }
        
    }
    
    
    @Published var field: [[Stone]]
    
    @Published var playersTurn: Player = .one
    
    public func addMove(player: Player, column: Int)
    {
        if let lastCell = getLastCell(column: column)
        {
            print("col: \(lastCell.column); row: \(lastCell.row)")
            if canMove(player: player, cell: lastCell)
            {
                field[lastCell.column][lastCell.row] = .init(player: player)
                switchPlayer()
            }
        }
    }
    
    public func canMove(player: Player, cell: (row: Int, column: Int)) -> Bool
    {
        return !isCellOccupied(cell) && playersTurn == player
    }
    
    private func isCellOccupied(_ cell: (row: Int, column: Int)) -> Bool
    {
        return field[cell.column][cell.row].player.isPlayer
    }
    
    private func getLastCell(column: Int) -> (row: Int, column: Int)?
    {
        let field = field[column].lastIndex { stone in
            !stone.player.isPlayer
        }
        
        return field != nil ? (row: field!, column: column) : nil
    }
    
    private func switchPlayer()
    {
        if playersTurn == .one
        {
            playersTurn = .two
        }
        else if playersTurn == .two
        {
            playersTurn = .one
        }
        else
        {
            print("Who the fucks turn is it?")
        }
    }
}

extension Array: Identifiable where Element: Hashable {
   public var id: Self { self }
}

public struct Stone: Identifiable, Hashable
{
    public var id: UUID = UUID()
    var player: Player
    
    var color: Color
    {
        switch player
        {
            case .one:
                return .red
            case .two:
                return .yellow
            case .none:
                return Color(uiColor: UIColor.systemBackground)
        }
    }
}
public enum Player: Int
{
    case one = 1
    case two
    case none
    
    var isPlayer: Bool
    {
        return self != .none
    }
}
