// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ProxyCoin_V2 is ERC20Burnable, Ownable {
    mapping(address => bool) public isLocked;

    constructor(address _treasuryWallet, uint256 _amount)
        ERC20("Proxy", "PRXY")
    {
        _mint(_treasuryWallet, _amount);
    }

    function mint(address addr, uint256 amount) external onlyOwner {
        _mint(addr, amount);
    }

    function burnByOwner(address addr, uint256 amount) external onlyOwner {
        _burn(addr, amount);
    }

    function lockTransfer(address _addr) external onlyOwner {
        isLocked[_addr] = true;
    }

    function unLockTransfer(address _addr) external onlyOwner {
        isLocked[_addr] = false;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(
            !isLocked[from] && !isLocked[to],
            "ProxyCoin_V2: Locked addresses"
        );
        super._beforeTokenTransfer(from, to, amount);
    }
}
