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
    
    @Published var winner: Player? = nil
    
    var gameOver: Bool = false
    
    public func reset()
    {
        self.field = .init(repeating: .init(repeating: .init(player: .none), count: GameField.rows), count: GameField.columns)
        
        for column in 0..<GameField.columns {
            for row in 0..<GameField.rows
            {
                self.field[column][row] = .init(player: .none)
            }
        }
        
        playersTurn = .one
        winner = nil
        gameOver = false
    }
    
    public func addMove(player: Player, column: Int)
    {
        if let lastCell = getLastCell(column: column)
        {
            print("col: \(lastCell.column); row: \(lastCell.row)")
            if canMove(player: player, cell: lastCell)
            {
                field[lastCell.column][lastCell.row] = .init(player: player)
                calculateWinner()
                switchPlayer()
            }
        }
    }
    
    public func canMove(player: Player, cell: (row: Int, column: Int)) -> Bool
    {
        return !isCellOccupied(cell) && playersTurn == player && winner == nil
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
    
    private func calculateWinner()
    {
        var winner: Player? = nil
        winner = winner ?? calculateVerticalWinner()
        winner = winner ?? calculateHorizontalWinner()
        winner = winner ?? calculateDiagonalLeftBottomToRightTopWinner()
        winner = winner ?? calculateDiagonalLeftTopToRightBottomWinner()
        winner = winner ?? calculateTie()
        
        if let winner = winner {
            self.winner = winner
        }
    }
    private func calculateTie() -> Player?
    {
        if field.allSatisfy({ x in
            x.allSatisfy { stone in
                stone.player.isPlayer
            }
        })
        {
            return Player.none
        }
        else
        {
            return nil
        }
    }
    private func calculateVerticalWinner() -> Player?
    {
        for column in field
        {
            for i in 0..<column.count
            {
                if(column.count >= i + 4)
                {
                    if column[i].player == column[i+1].player &&
                        column[i].player == column[i+2].player &&
                        column[i].player == column[i+3].player &&
                        column[i].player != .none
                    {
                        return column[i].player
                    }
                }
            }
        }
        
        return nil
    }
    
    private func calculateHorizontalWinner() -> Player?
    {

        for j in 0..<GameField.columns
        {
            for i in 0..<GameField.rows
            {
                if(GameField.columns >= j + 4)
                {
                    if field[j][i].player == field[j+1][i].player &&
                        field[j][i].player == field[j+2][i].player &&
                        field[j][i].player == field[j+3][i].player &&
                        field[j][i].player != .none
                    {
                        return field[j][i].player
                    }
                }
            }
        }
        
        return nil
    }
    
    private func calculateDiagonalLeftBottomToRightTopWinner() -> Player?
    {
        for j in 0..<GameField.columns
        {
            for i in 0..<GameField.rows
            {
                if(GameField.columns >= j + 4 && i - 4 >= 0)
                {
                    if field[j][i].player == field[j+1][i-1].player &&
                        field[j][i].player == field[j+2][i-2].player &&
                        field[j][i].player == field[j+3][i-3].player &&
                        field[j][i].player != .none
                    {
                        return field[j][i].player
                    }
                }
            }
        }
        return nil
    }
    private func calculateDiagonalLeftTopToRightBottomWinner() -> Player?
    {
        for j in 0..<GameField.columns
        {
            for i in 0..<GameField.rows
            {
                if(GameField.rows >= i + 4 && j + 4 <= GameField.columns)
                {
                    if field[j][i].player == field[j+1][i+1].player &&
                        field[j][i].player == field[j+2][i+2].player &&
                        field[j][i].player == field[j+3][i+3].player &&
                        field[j][i].player != .none
                    {
                        return field[j][i].player
                    }
                }
            }
        }
        
        return nil
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
