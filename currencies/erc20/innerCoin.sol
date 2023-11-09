// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for the ERC20 standard as defined in the EIP.
interface IERC20 {
    // Returns the amount of tokens in existence.
    function totalSupply() external view returns (uint256);

    // Returns the amount of tokens owned by `account`.
    function balanceOf(address account) external view returns (uint256);

    // Moves `amount` tokens from the caller's account to `recipient`.
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Returns the remaining number of tokens that `spender` will be
    // allowed to spend on behalf of `owner` through {transferFrom}.
    function allowance(address owner, address spender) external view returns (uint256);

    // Sets `amount` as the allowance of `spender` over the caller's tokens.
    function approve(address spender, uint256 amount) external returns (bool);

    // Moves `amount` tokens from `sender` to `recipient` using the
    // allowance mechanism. `amount` is then deducted from the caller's allowance.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Emitted when `value` tokens are moved from one account (`from`) to another (`to`).
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when the allowance of a `spender` for an `owner` is set by a call to {approve}.
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Contract that implements the ERC20 token standard.
contract InnerCoin is IERC20 {
    // Public variables of the token including name, symbol, and decimals.
    // These are optional per the ERC20 standard, but they are included to enhance user experience.
    string public constant name = "InnerCoin";
    string public constant symbol = "ICN";
    uint8 public constant decimals = 18;

    // A mapping to keep track of each address's balance.
    mapping(address => uint256) private _balances;

    // A mapping to keep track of allowances: how much a spender is allowed to spend on behalf of an owner.
    mapping(address => mapping(address => uint256)) private _allowances;

    // The total supply of the token.
    uint256 private _totalSupply;

    // Constructor that sets the initial supply of tokens, which is sent to the address that deployed the contract.
    constructor(uint256 initialSupply) {
        _mint(msg.sender, initialSupply);
    }

    // Returns the total supply of tokens.
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Returns the token balance of a specific account.
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // Transfer function to move `amount` tokens to `recipient`.
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    // Function to check how much `spender` is allowed to spend from `owner`'s account.
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Approve function to set `amount` as the allowance of `spender` over the caller's tokens.
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    // Transfer tokens from one account to another, given the sender has enough allowance.
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    // Increase the allowance granted to `spender` by the caller.
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    // Decrease the allowance granted to `spender` by the caller.
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(msg.sender, spender, currentAllowance - subtractedValue);

        return true;
    }

    // Internal transfer function that moves `amount` tokens from `sender` to `recipient`.
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    // Internal function to create `amount` tokens and assign them to `account`, increasing the total supply.
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    // Internal function to destroy `amount` tokens from `account`, reducing the total supply.
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    // Internal function to set `amount` as the allowance of `spender` over the `owner`s tokens.
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
