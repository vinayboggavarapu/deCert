// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IAnonAadhaarVerifier.sol";

error DeCert__OnlyIssuerRequired();
error DeCert__OnlyUser();
error DeCert__Invalid__User();
error DeCert__AlreadyExists();
error DeCert__Invalid__Proof();

contract DeCert {
    struct Detail {
        string userName;
        string email;
        bool prover;
        bool isIssuer;
    }

    mapping(address => Detail) private s_details;
    mapping(string => string[]) private s_userData;

    address private anonAadhaarVerifierAddr;

    event UserSignIn(address indexed _userAddress, string _userName);

    constructor(address _verifierAddr) {
        anonAadhaarVerifierAddr = _verifierAddr;
    }

    function verify(
        uint256[2] calldata _pA,
        uint256[2][2] calldata _pB,
        uint256[2] calldata _pC,
        uint256[34] calldata _pubSignals
    ) public view returns (bool) {
        return
            IAnonAadhaarVerifier(anonAadhaarVerifierAddr).verifyProof(
                _pA,
                _pB,
                _pC,
                _pubSignals
            );
    }

    function addDetails(
    address _userAddress,
    string memory _userName,
    string memory _email,
    bool _ofIssuer,
    uint256[2] calldata _pA,
    uint256[2][2] calldata _pB,
    uint256[2] calldata _pC,
    uint256[34] calldata _pubSignals
) external IsNotExisting(_userAddress) {
    // Assuming `verify` is a function that returns a boolean
    bool isProver = verify(_pA, _pB, _pC, _pubSignals);

    Detail memory userDetail = Detail({
        userName: _userName,
        email: _email,
        prover: isProver,
        isIssuer: _ofIssuer
    });

    s_details[_userAddress] = userDetail;
    emit UserSignIn(_userAddress, _userName);
}

    function makeProverTrue() internal {
        s_details[msg.sender].prover = true;
    }

    // Fetch Details of any particular address
    function fetchDetail(address userAddress)
        external
        view
        returns (Detail memory)
    {
        if (!checkDetail(userAddress)) revert DeCert__Invalid__User();
        return s_details[userAddress];
    }

    // Fetch User's Data/Certifications
    function fetchUserData(string memory _email)
        external
        view
        returns (string[] memory)
    {
        return s_userData[_email];
    }

    function checkDetail(address userAddress) internal view returns (bool) {
        bytes memory userNameBytes = bytes(s_details[userAddress].userName);
        return (userNameBytes.length > 0);
    }

    modifier IsNotExisting(address userAddress) {
        if (bytes(s_details[userAddress].userName).length > 0) {
            revert DeCert__AlreadyExists();
        } else {
            _;
        }
    }

    function addUserData(string memory _email, string memory _data) external {
        if (s_details[msg.sender].isIssuer) revert DeCert__OnlyIssuerRequired();
        s_userData[_email].push(_data);
    }

    function updateDetailsByUser(
        string memory _changeUserName,
        string memory _changeEmail
    ) external {
        s_details[msg.sender].userName = _changeUserName;
        s_details[msg.sender].email = _changeEmail;
    }
}
