pragma solidity ^0.4.8;
contract Property {
    address public owner;
    bytes32 public description;
    uint public pricePerDay;
    uint public id;
    enum PropertyStatus {Active, Created, Sold}
    enum RentalStatus {Free, Booked, Paid, Unavailable}
    struct RentalDay {
        RentalStatus rentalStatus;
        uint price;
    }
    PropertyStatus status;
    RentalDay[10][366] rentalCalendar;
    function Property(address _owner, bytes32 _description, uint _pricePerDay, uint _id) {
        owner = _owner;
        description = _description;
        pricePerDay = _pricePerDay;
        status = PropertyStatus.Created;
        id = _id;
    }
    function ChangeOwner(address _newOwner) {
        require(msg.sender == owner);
        owner = _newOwner;
    }
    function GetDescription() constant returns (bytes32){
        return description;
    }
}
contract RentalService {
    address public controller;
    function RentalService() {
        controller = msg.sender;
    }
    Property[] propertyList;
    function AddProperty (address _owner, bytes32 _description, uint _pricePerDay) returns (uint) {
        uint x = propertyList.length;
        propertyList.push(new Property(msg.sender, _description, _pricePerDay, x));
        return x;
    }
    function GetPropertyDescriptionById(uint _id) returns (bytes32) {
        return propertyList[_id].GetDescription();
    }
    
}
