// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Data, IPoolManager} from '../interfaces/IPoolManager.sol';

contract BatchPoolManagerData {
  // This contract is used to fetch multiple pools from the PoolManager contract
  constructor(IPoolManager _poolManager) {
    // create an array to store return data
    uint256 _poolsToFetch = _poolManager.numPools();
    Data[] memory _returnData = new Data[](_poolsToFetch);

    // fetch pools
    for (uint256 _i = 0; _i < _poolsToFetch; _i++) {
      _returnData[_i] = _poolManager.queryPool(_i);
    }

    // encode return data
    bytes memory _data = abi.encode(_returnData);

    // force constructor to return data via assembly
    assembly {
      // abi.encode adds an additional offset (32 bytes) that we need to skip
      let _dataStart := add(_data, 32)
      // msize() gets the size of active memory in bytes.
      // if we subtract msize() from _dataStart, the output will be
      // the amount of bytes from _dataStart to the end of memory
      // which due to how the data has been laid out in memory, will coincide with
      // where our desired data ends.
      let _dataEnd := sub(msize(), _dataStart)
      // starting from _dataStart, get all the data in memory.
      return(_dataStart, _dataEnd)
    }
  }
}
