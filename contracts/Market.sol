//SPDX-License-Identifier:MIT

contract Market{

    struct Listing{
        address token;
        uint tokenId;
        uint price;
    }

    uint private _listingId = 0;
    mapping(uint=> Listing) _listings;

    function listToken(address token, uint tokenId, uint price) external{
        Listing memory listing = Listing(token, tokenId,price);
        _listingId++;
        _listings[_listingId] = listing;
    }
}