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
    RentalDay[366][10] public rentalCalendar;
    function SetRentalPriceByYearDay(uint _year, uint _day, uint _price) {
        rentalCalendar[_year-1][_day-1].price = _price;
    }
    function GetRentalPriceByYearDay(uint _year, uint _day) returns (uint) {
        return rentalCalendar[_year-1][_day-1].price;
    }
    function SetRentalPriceByYearPeriod(uint _year, uint _dayFrom, uint _numOfDays, uint _price) {
        for (uint x = 0; x < _numOfDays; x++){
            rentalCalendar[_year-1][_dayFrom-1+x].price = _price;
        }
    }
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
    uint numOfProperty;
    function RentalService() {
        controller = msg.sender;
    }
    mapping (uint => Property) propertyList;
//    Property[] propertyList;
    function AddProperty (address _owner, bytes32 _description, uint _pricePerDay) returns (uint) {
        Property newProperty = new Property(msg.sender, _description, _pricePerDay, numOfProperty);
        propertyList[numOfProperty++] = newProperty;
        return numOfProperty;
    }
    function GetPropertyDescriptionById(uint _id) returns (bytes32) {
        return propertyList[_id].GetDescription();
    }
    function SetPropertyRentalPriceByYearDay (uint _propertyId, uint _year, uint _day, uint _price) payable {
        require(propertyList[_propertyId].owner() == msg.sender);
        propertyList[_propertyId].SetRentalPriceByYearDay(_year, _day, _price);
    }
    function GetPropertyRentalPriceByYearDay(uint _propertyId, uint _year, uint _day) returns (uint) {
        return propertyList[_propertyId].GetRentalPriceByYearDay(_year, _day);
    }
    function SetPropertyRentalPriceByYearPeriod (uint _propertyId, uint _year, uint _dayFrom, uint _numOfDays, uint _price) payable {
        require(propertyList[_propertyId].owner() == msg.sender);
        propertyList[_propertyId].SetRentalPriceByYearPeriod(_year, _dayFrom, _numOfDays, _price);
    }
}
