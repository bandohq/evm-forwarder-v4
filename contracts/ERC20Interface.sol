// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

/**
 * Contract that exposes the needed erc20 token functions
 */

abstract contract ERC20Interface {
  // Send _value amount of tokens to address _to
  function transfer(address _to, uint256 _value)
    public
    virtual
    returns (bool success);

  // Get the account balance of another account with address _owner
  function balanceOf(address _owner)
    public
    view
    virtual
    returns (uint256 balance);

  // Approve the passed address to spend the specified amount of tokens
  function approve(address _spender, uint256 _value)
    public
    virtual
    returns (bool success);
}
