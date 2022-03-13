//SPDX-License-Identifier:MIT

pragma solidity ^0.8.11;

//import ierc721 interface
import "./IERC721.sol";

contract Market{

    enum ListingStatus{
        Active,
        Sold, 
        Cancelled
    }

    struct Listing{
        ListingStatus status;
        address  seller;
        address token;
        uint tokenId;
        uint price;

    }

    event Listed(
        uint listingId,
        address seller,
        address token,
        uint tokenId,
        uint price
    );

    uint private _listingId = 0;
    mapping(uint=> Listing) _listings;

//SHOW TOKENS AVAILABLE ON THE MARKET PLACE
    function listToken(address token, uint tokenId, uint price) external{
        //transfer token from seller to our address
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

        emit Listed(_listingId, msg.sender, token, tokenId, price);
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

    listing.status = ListingStatus.Sold;

    //transfer token from our address to buyer's address
    IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);
    payable(listing.seller.transfer(listing.price)); 
    
    }

//cancel sell of token
    function cancel(uint listingId) public{
        Listing storage listing = _listings[_listingId];

        require(listing.status==ListingStatus.Active, "Listing is not Active");
        require(msg.sender == listing.seller,"Only seller can cancel listing");

        listing.status = ListingStatus.Cancelled;

        IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);
    }
}