// SPDX-License-Identifier: NO LICENSE
pragma solidity 0.7.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract ProxyCoin is ERC20Burnable, Ownable {
  using SafeMath for uint256;
  uint256 public perBlockSupply = 2391000 * 1e18;
  address public stakingContrAddr;
  uint256 public lastMintBlock;
  uint256 public mintDuration = 210000;
  address public treasuryWallet;
  uint256 public mintCycle;
  uint256 public mintCycleCap = 20;

  constructor (address _treasuryWallet) ERC20("Proxy Coin", "PRXY") {
    _setupDecimals(18);
    lastMintBlock = block.timestamp;
    treasuryWallet = _treasuryWallet;
    _mint(treasuryWallet, perBlockSupply);
    mintCycle++;
  }

  function startMinting() public onlyOwner {
    require(!mintingFinished(), "Err: Minting Finished");
    require(getMintingStatus(), "Err: Minting not allowed");
    lastMintBlock = block.timestamp;
    perBlockSupply = (perBlockSupply * 10).div(9);
    _mint(treasuryWallet, perBlockSupply);
  }

  function mint(address addr, uint256 amount) public virtual onlyOwner {
    _mint(addr, amount);
  }

  function changeMintCycleCap(uint256 _mintCycleCap) public virtual onlyOwner {
    mintCycleCap = _mintCycleCap;
  }

  function changeMintDuration(uint256 _mintDuration) public virtual onlyOwner {
    mintDuration = _mintDuration;
  }

  function getMintingStatus() public view returns(bool) {
    return ((lastMintBlock + mintDuration) > block.timestamp);
  }

  function mintingFinished() public view returns(bool) {
    return (mintCycle > mintCycleCap);
  }
}