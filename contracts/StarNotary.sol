pragma solidity >=0.4.22 <0.9.0;

//Importing openzeppelin-solidity ERC-721 implemented Standard
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";




contract StarNotary is ERC721 {
    
    constructor (string memory _name, string memory _symbol) public  {

    }



    struct Star {
        string name;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;
    mapping(uint256 => uint256) public starPrice;

    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sell the Star you don't own");
        starsForSale[_tokenId] = _price;
        starPrice[_tokenId] = _price;
    }

    function lookUptokenIdToStarInfo(uint256 _tokenId) public view returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        return tokenIdToStarInfo[_tokenId].name;
    }

    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        address owner1 = ownerOf(_tokenId1);
        address owner2 = ownerOf(_tokenId2);

        require(owner1 == msg.sender || owner2 == msg.sender, "You can only exchange your own Stars");

        emit Transfer(owner1, owner2, _tokenId1);
        emit Transfer(owner2, owner1, _tokenId2);
    }

    function transferStar(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(owner == msg.sender, "You can only transfer your own Star");
        emit Transfer(owner, _to, _tokenId);
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value >= starCost, "Insufficient funds to buy the Star");

        emit Transfer(ownerAddress, msg.sender, _tokenId);
        starPrice[_tokenId] = 0;
        starsForSale[_tokenId] = 0;

        // Transfer excess funds back to the buyer
     
    }
}
