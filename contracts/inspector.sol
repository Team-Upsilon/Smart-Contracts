pragma solidity ^0.8.0;

contract inspector{
    address inspector;

    modifier onlyinspector(){
        require(msg.sender==inspector,"only inspector can call this function");
        _;
    }

    event qualitychecked(uint256 packageid,uint256 grade);  
    event packagegrade(uint256 packageid,uint256 grade);

    struct report{
        uint256 packageid;
        uint256 grade;
        uint256 timestamp;
        uint256 reportid;
        bool isinspected;
    }      

    mapping (address=>report[]) public reports;

    constructor(address _inspector){
        inspector=_inspector;
    }

    function checkquality(uint256 _packageid,uint256 a,uint256 b,uint256 c,uint256 qa,uint256 qb,uint256 qc) public onlyinspector {
        uint256 grade=((a*qa)+(b*qb)+(c*qc))/(qa+qb+qc);
        emit packagegrade(_packageid,grade);
        require(grade>=7,"package rejected due to poor quality");
        emit qualitychecked(_packageid,grade);
        //generate report 
        reports[msg.sender].push(report(_packageid,grade,block.timestamp,reports[msg.sender].length+1,true));

       
    }

    function getreport (address _inspector,uint256 _reportid) public view returns(uint256,uint256,uint256,uint256){
        return (reports[_inspector][_reportid-1].packageid,reports[_inspector][_reportid-1].grade,reports[_inspector][_reportid-1].timestamp,reports[_inspector][_reportid-1].reportid,reports[_inspector][_reportid-1].isinspected);
    }

    
}