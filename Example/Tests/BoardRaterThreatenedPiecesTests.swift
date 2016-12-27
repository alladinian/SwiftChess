//
//  BoardRaterThreatenedPiecesTests.swift
//  Example
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterThreatenedPiecesTests: XCTestCase {
    
    var boardRater = BoardRaterThreatenedPieces()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        boardRater = BoardRaterThreatenedPieces()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardRaterThreatededPiecesReturnsNoThreatIfNoOpponants() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - Q - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)

        XCTAssertEqualWithAccuracy(rating, 0, accuracy: 0.01)
    }
    
    func testBoardRaterThreatenedPiecesReturnsNoThreatIfOnlySameColorPieces() {
        
        let board = ASCIIBoard(pieces:  "- R - - - - - -" +
                                        "- - - - - K - -" +
                                        "- - - - - - - -" +
                                        "- - - G - - - P" +
                                        "- - Q - - - - -" +
                                        "- - - - - - - -" +
                                        "- P - - - B - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertEqualWithAccuracy(rating, 0, accuracy: 0.01)
    }
    
    func testBoardRaterThreatenedPiecesReturnsNegativeValueIfThreatened() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "q - - - - - K -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        
        XCTAssert(rating < 0);
    }
    
    func testBoardRaterThreatenedPiecesReturnsPositiveValueIfThreateningOpponant() {

        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "Q - - - - - k -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        
        XCTAssert(rating > 0);
    }
    
    func testBoardRaterThreatenedPiecesReturnsHigherThreatValueForHigherValuePieces() {
        
        let queenBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "q - - - - - Q -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" )
        
        let queenIndex = queenBoard.indexOfCharacter("Q")
        let queenLocation = BoardLocation(index: queenIndex)
        let queenRating = boardRater.threatRatingForPiece(at: queenLocation,
                                                          board: queenBoard.board)
        
        
        
        let knightBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "q - - - - - K -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" )
        
        let knightIndex = knightBoard.indexOfCharacter("K")
        let knightLocation = BoardLocation(index: knightIndex)
        let knightRating = boardRater.threatRatingForPiece(at: knightLocation,
                                                           board: knightBoard.board)
        
        XCTAssert(queenRating > knightRating);
    }
    
    func testOwnPiecesMultiplerShouldIncreaceValueOfIncomingThreats() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "q - - - - - Q -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        boardRater.ownPiecesMultipler = 1
        let expectedLowRating = boardRater.ratingfor(board: board.board, color: .white)
        
        boardRater.ownPiecesMultipler = 2
        let expectedHighRating = boardRater.ratingfor(board: board.board, color: .white)
        
        // Higher threat levels result in negative ratings!
        XCTAssert(expectedHighRating < expectedLowRating)
    }
    
    func testGetProtectingPiecesReturnsProtectingPieces() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - K - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - Q -" +
                                        "- - - - - - - -" +
                                        "- - - - - - R -" +
                                        "- - - B - - - -" )
        
       
        let expectedIndexes = [
            board.indexOfCharacter("K"),
            board.indexOfCharacter("R"),
            board.indexOfCharacter("B"),
        ]
        
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        
        let protectingLocations = boardRater.protectingPiecesLocationsforPiece(at: queenLocation,
                                                                               on: board.board)
        
        // Check all of the expected locations appeared in the protecting locations array
        for expectedIndex in expectedIndexes {
            var foundIndex = false
            
            for location in protectingLocations {
                if location == BoardLocation(index: expectedIndex) {
                    foundIndex = true
                }
            }
            
            XCTAssertTrue(foundIndex, "Failed to find expected index \(expectedIndex)")
        }
    
        // Check all of the protecting locations were expected
        for location in protectingLocations {
            var wasExpected = false
            
            for expectedIndex in expectedIndexes {
                if location == BoardLocation(index: expectedIndex) {
                    wasExpected = true
                }
            }
            
            XCTAssertTrue(wasExpected, "Found unexpected protecting location \(location)");
        }
    }
    
    func testGetProtectingPiecesDoesntReturnNonProtectingPiecesOfSameColor() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - K - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - Q -" +
                                        "- - - - - - - -" +
                                        "R - - - - - - -" +
                                        "- B - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        
        let protectingLocations = boardRater.protectingPiecesLocationsforPiece(at: queenLocation,
                                                                               on: board.board)
        
        // None of the pieces are protecting the queen, so expect count to be zero
        XCTAssertTrue(protectingLocations.count == 0)
    }
    
    func testGetProtectingPiecesDoesntReturnThreateningPiecesOfOppositeColor() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - k - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - Q -" +
                                        "- - - - - - - -" +
                                        "- - - - - - r -" +
                                        "- - - b - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        
        let protectingLocations = boardRater.protectingPiecesLocationsforPiece(at: queenLocation,
                                                                               on: board.board)
        
        // The black pieces cannot protect the whitequeen, so expect count to be zero
        XCTAssertTrue(protectingLocations.count == 0)
    }

}
