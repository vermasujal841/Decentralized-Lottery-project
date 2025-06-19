// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Lottery {
    address public manager;
    address[] public players;
    address public lastWinner;

    constructor() {
        manager = msg.sender;
    }

    // Enter the lottery by sending ETH
    function enter() public payable {
        require(msg.value == 0.01 ether, "Entry fee is 0.01 ETH");
        players.push(msg.sender);
    }

    // Only manager can pick the winner
    function pickWinner() public restricted {
        require(players.length > 0, "No players have entered");
        uint index = random() % players.length;
        address winner = players[index];
        lastWinner = winner;
        payable(winner).transfer(address(this).balance);
        delete players;
    }

    // Get all players
    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    // Restriction modifier
    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this");
        _;
    }

    // Pseudo-random number generator (not secure for mainnet)
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
}
