// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

struct Data {
  uint256 id;
  uint256 liquidity;
}

interface IPoolManager {
  /**
   * @notice Query a pool
   * @param _poolId The pool ID
   * @return _pool The pool data
   */
  function queryPool(uint256 _poolId) external returns (Data memory _pool);

  /**
   * @notice Get the number of pools
   * @return _numPools The number of pools
   */
  function numPools() external returns (uint256 _numPools);
}
