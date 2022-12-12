//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

contract OutletPublishing {
    event NewPost(bytes32 post);
    event NewPlayer(uint256 identityCommitment, uint256 charId);
    event NewCharacter(uint256 charId);

    ISemaphore public semaphore;

    constructor(address semaphoreAddress) {
        semaphore = ISemaphore(semaphoreAddress);
    }

    function createCharacter(uint256 _charId) external {
        semaphore.createGroup(_charId, 20, 0, address(this));
        emit NewCharacter(_charId);
    }

    function joinCharacter(uint256 _charId, uint256 identityCommitment)
        external
    {
        semaphore.addMember(_charId, identityCommitment);
        emit NewPlayer(identityCommitment, _charId);
    }

    function post(
        uint256 charId,
        bytes32 post,
        uint256 merkleTreeRoot,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) external {
        semaphore.verifyProof(
            charId,
            merkleTreeRoot,
            post,
            nullifierHash,
            proof
        );
        emit NewPost(post);
    }
}
