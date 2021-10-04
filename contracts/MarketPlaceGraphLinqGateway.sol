//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./interfaces/IERC20.sol";

struct TemplateInfos {
    address     owner;
    uint256     price;
    bool        state; // public or private template
    address[]   customers;
}

contract MarketPlaceGraphLinqGateway {
    mapping(uint256 => TemplateInfos) templates;
    mapping(address => mapping(uint256 => bool)) access;

    /*
    ** Manager of the contract to revoke or grant special access to template
    */
    address private _glqManager;

    /*
    ** Address of the GLQ token hash: 0x9F9c8ec3534c3cE16F928381372BfbFBFb9F4D24
    */
    address private _glqTokenAddress;

    constructor(address glqAddress, address manager) {
        _glqTokenAddress = glqAddress;
        _glqManager = manager;
    }

    
    /* Getter ---- Read-Only */
    function hasAccess(uint256 templateId) public view returns(bool) {
        require(
            templates[templateId].owner != address(0),
            "GLQ Template Id invalid");
        require(
            templates[templateId].state != false,
            "Template is currently in private state, please contact the owner.");

        return access[msg.sender][templateId] != false;
    }

    function fetchCustomers(uint256 templateId) public view returns(address[] memory) {
        require(
            templates[templateId].owner != address(0),
            "GLQ Template Id invalid");
        return templates[templateId].customers;
    }

    /* Getter ---- Read-Only */

    /* Setter - Read & Modifications */

    /*
    ** Super access to grant or revoke access to a specific address on a template
    */
    function superChangeState(uint256 templateId, address toAddress, bool state) public {
        require(
            msg.sender == _glqManager,
            "Restricted to the GLQ Manager"
        );
        access[toAddress][templateId] = state;
    }

    /*
    ** Add a new template to the marketplace contract 
    */
    function addTemplate(uint256 templateId, uint256 glqPrice, bool state) public {
         require(
             templates[templateId].owner == address(0),
            "Template already exist");
        templates[templateId].owner = msg.sender;
        templates[templateId].price = glqPrice;
        templates[templateId].state = state;
    }

    /*
    ** Update status and price of an already existing and owned templates
    */
    function updateTemplate(uint256 templateId, uint256 newPrice, bool state) public {
         require(
             templates[templateId].owner == msg.sender,
            "Only the owner of the template can update the values");
        templates[templateId].price = newPrice;
        templates[templateId].state = state;
    }

    /* *************************************************** */


    /*
    ** Buy function to get a new template directly from the Marketplace
    */
    function buyTemplate(uint256 templateId) public returns(bool) {
        IERC20 glqToken = IERC20(_glqTokenAddress);
        address owner = templates[templateId].owner;
        uint256 price = templates[templateId].price;

        require(
            owner != address(0),
            "GLQ Template Id invalid");
        require(
            glqToken.balanceOf(msg.sender) >= price,
            "Not enough GLQ funds on the wallet to buy this template");

        require(
            glqToken.transferFrom(msg.sender, owner, price) == true,
            "Error on transfering GLQ to the template owner"
        );
        
        // set access to the template
        access[msg.sender][templateId] = true;
        templates[templateId].customers.push(msg.sender);

        return true;
    }

    /* Setter - Read & Modifications */

}