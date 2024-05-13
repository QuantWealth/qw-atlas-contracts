// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Data, IPoolManager} from '../interfaces/IPoolManager.sol';

contract PoolManager is IPoolManager {
  uint256 private constant _FAKE_LIQUIDITY = 10_000;
  uint256 private constant _FAKE_NUM_POOLS = 50;

  /// @inheritdoc IPoolManager
  function queryPool(uint256 _poolId) public pure returns (Data memory _pool) {
    return Data({id: _poolId, liquidity: _FAKE_LIQUIDITY});
  }

  /// @inheritdoc IPoolManager
  function numPools() external pure returns (uint256 _numPools) {
    return _FAKE_NUM_POOLS;
  }
}
