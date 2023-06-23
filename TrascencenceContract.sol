// SPDX-License-Identifier: MIT LICENSE



import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

pragma solidity ^0.8.19;

contract Transcendence is ERC721Enumerable, Ownable {

    
    using Strings for uint256;
    string public baseURI;
    uint256 public maxSupply = 30;
    uint256 public maxMintAmount = 1;
    bool public paused = false;
    
function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;

    }
    
    struct baseuritoken {
    uint24 tokenId;
    uint48 timestamp;
    address creator;
    string URIid;
   
    
  }

   mapping(uint256 => baseuritoken) public vault; 
    
    constructor() ERC721("Transcendence", "TRS") {}

   
    
    function mint(uint256 _mintAmount, string calldata _base, uint24 _tokenId) public onlyOwner()  {
            uint256 supply = totalSupply();
            uint24 tokenId = _tokenId;
            string memory baseURItemp = _base;
            require(!paused);
            require(_mintAmount > 0);
            require(_mintAmount <= maxMintAmount);
            require(supply + _mintAmount <= maxSupply);
            
                
                _safeMint(msg.sender, supply + 1);
            
           
                 vault[tokenId] = baseuritoken({
        tokenId: uint24(tokenId),
        timestamp: uint48(block.timestamp),
        creator: address(msg.sender),
        URIid: string(baseURItemp)
        
       
      });
    }


        function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
        {
            uint256 ownerTokenCount = balanceOf(_owner);
            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
            for (uint256 i; i < ownerTokenCount; i++) {
                tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return tokenIds;
        }
    
        
        function tokenURI(uint256 tokenIds)
        public
        view
        virtual
        override
        returns (string memory) {
            require(
                _exists(tokenIds),
                "ERC721Metadata: URI query for nonexistent token"
                );
                
                
                return
                bytes(vault[tokenIds].URIid).length > 0 
                ? string(abi.encodePacked(vault[tokenIds].URIid))
                : "";
        }



        // only owner
        
        function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
            maxMintAmount = _newmaxMintAmount;
        }
        
        function setBaseURI(uint24 _tokenId, string memory _newBaseURI) public onlyOwner() {
             uint24 TkId = _tokenId;
            require (vault[TkId].creator == ownerOf(TkId));
           
            vault[TkId].URIid = _newBaseURI;
            
        }
        
                
        function pause(bool _state) public onlyOwner() {
            paused = _state;
        }
        
}
