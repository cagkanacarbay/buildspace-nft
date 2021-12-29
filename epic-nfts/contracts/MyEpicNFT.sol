// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract AwesomeSauce3Words is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint maxNftCap = 10;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


    string[] firstWords = ["Awesome", "Great", "Magnificent", "Flamboyant", "Ambivalent", "Stylish", "Elder", "Bold", "Fiery", "Fearful", "Panicky", "Depressed", "Empathetic"];
    string[] secondWords = ["Beans", "Curry", "Burger", "Bread", "Baguette", "Pasta", "Cupcake", "Mushroom", "Soup", "Milkshake", "Sandwich", "Salad"];
    string[] thirdWords = ["King", "Duke", "Starman", "Stargirl", "Champion", "Queen", "Princess", "Gladiator", "Warrior", "Priestess", "Priest", "Bishop", "Legionnaire", "Jester", "Knight", "Blacksmith"];
    
    constructor() ERC721("AwesomeSauce", "3WORDS") {
        console.log("This is my NFT contract. Whoa!");
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // I seed the random generator. More on this in the lesson. 
        uint256 rand = random(string(abi.encodePacked("wohoobrandnewrandoms", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("isanewword", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("thirdWordbutnew", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return _tokenIds.current();
    }

    function makeAnEpicNFT() public payable {
        require(_tokenIds.current() < maxNftCap);
        require(msg.value == 0.01 ether, "Need to pay 0.01 ether for this purchase");

        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        
        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);
    
        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
