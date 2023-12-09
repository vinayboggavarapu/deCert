// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

contract userProfile{
    struct detail {
        string _userName;
        string _email;
    }
    mapping(address=>detail) private _details;

    function addDetails(address userAddress, string memory userName, string memory email) external{
        detail memory _detail=detail({
            _userName=userName;
            _email=email;
        })

        _details[userAddress]=_detail;
    }

}