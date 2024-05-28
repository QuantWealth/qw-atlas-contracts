// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Data, IPoolDataProvider} from '../interfaces/aave-v3/IAaveV3.sol';

/**
 * To calculate deposit apy/apr from this data
 * RAY = 10**27
 * SECONDS_PER_YEAR = 31536000
 * depositAPR = liquidityRate/RAY
 * depositAPY = ((1 + (depositAPR / SECONDS_PER_YEAR)) ^ SECONDS_PER_YEAR) - 1
 */
contract BatchAaveV3DataRequest {
  // This contract is used to fetch apy data points from aave
  constructor(IPoolDataProvider _poolDataProvider, address[] memory _assets) {
    // create an array to store return data
    Data[] memory _returnData = new Data[](_assets.length);

    for (uint256 i = 0; i < _assets.length; i++) {
      (,,,,, uint256 liquidityRate,,,,,,) = _poolDataProvider.getReserveData(_assets[i]);
      _returnData[i] = Data({liquidityRate: liquidityRate});
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
