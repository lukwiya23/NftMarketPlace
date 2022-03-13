//SPDX-License-Identifier:MIT

pragma solidity ^0.8.11;

//import ierc721 interface
import "./IERC721.sol";

contract Market{

    enum ListingStatus{
        Active,
        Solid, 
        Cancelled
    }

    struct Listing{
        ListingStatus status;
        address seller;
        address token;
        uint tokenId;
        uint price;

    }

    uint private _listingId = 0;
    mapping(uint=> Listing) _listings;

//SHOW TOKENS AVAILABLE ON THE MARKET PLACE
    function listToken(address seller,address token, uint tokenId, uint price) external{
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);

        Listing memory listing = Listing(
            ListingStatus.Active,
            msg.sender,
            token,
             tokenId,
             price
             
             );

        _listingId++;

        _listings[_listingId] = listing;
    }

//BUY AVAILALBLE TOKEN ON THE MARKET PLACE
    function buyToken(uint listingId) external payable{
        Listing storage listing = _listings[_listingId];

//make sure listing status is set to Active
        require(listing.status == ListingStatus.Active, "Listing is not currently Active");
        //make sure seller is not the buyer
        require(msg.sender != listing.seller, "Seller cannot be the buyer idiot");

    //check buyer's balance before transaction
    require(msg.value >= listing.price, "You have insufficient ether in your wallet");

    //buy token
    
    }
}