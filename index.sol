// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ERC20Interface {
    function totalSupply() external view returns (uint256);

    function balanceOf(address tokenOwner)
        external
        view
        returns (uint256 balance);

    function transfer(address to, uint256 amount)
        external
        returns (bool success);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    function approve(address spender, uint256 amount)
        external
        returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract myCoin is ERC20Interface {
    string public name = "MyCoin";
    string public symbol = "MYC";
    uint256 public decimals = 18;
    uint256 public override totalSupply;

    address public founder;
    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        founder = msg.sender;
        totalSupply = 1000000;
        balances[founder] = totalSupply;
    }


   function allowance(address owner, address spender) public override view returns (uint256) {
        return allowed[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        require(balances[msg.sender] >= amount);
        require(amount > 0);
        allowed[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;

    }

    function transferFrom(address from, address to, uint amount) public override returns (bool){
        require(allowed[from][to] >= amount);
        require(balances[from] >= amount);
        balances[from] -= amount;
        balances[to] += amount;
        allowed[from][to] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256 balance)
    {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool success)
    {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);

        return true;
    }
}
