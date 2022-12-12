//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

contract Greeter {
    event NewGreeting(bytes32 greeting);
    event NewUser(uint256 identityCommitment, bytes32 username);
    event NewGroup(uint256 groupId);

    ISemaphore public semaphore;

    mapping(uint256 => bytes32) public users;

    constructor(address semaphoreAddress, uint256 groupId) {
        semaphore = ISemaphore(semaphoreAddress);
        semaphore.createGroup(groupId, 20, 0, address(this));
    }

    function joinGroup(
        uint256 _groupId,
        uint256 identityCommitment,
        bytes32 username
    ) external {
        semaphore.addMember(_groupId, identityCommitment);
        //users[identityCommitment] = username;
        emit NewUser(identityCommitment, username);
    }

    function createGroup(uint256 _groupId) external {
        semaphore.createGroup(_groupId, 20, 0, address(this));
        emit NewGroup(_groupId);
    }

    function greet(
        uint256 groupId,
        bytes32 greeting,
        uint256 merkleTreeRoot,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) external {
        semaphore.verifyProof(
            groupId,
            merkleTreeRoot,
            greeting,
            nullifierHash,
            groupId,
            proof
        );
        emit NewGreeting(greeting);
    }
}
