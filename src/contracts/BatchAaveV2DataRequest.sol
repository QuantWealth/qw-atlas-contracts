// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Data, DataTypes, IIncentivesController, ILendingPool} from '../interfaces/aave-v2/IAaveV2.sol';

/**
 * To calculate deposit apy/apr from this data
 * https://docs.aave.com/developers/v/2.0/guides/apy-and-apr#compute-data
 */
contract BatchAaveV2DataRequest {
  // This contract is used to fetch apy data points from aave
  constructor(ILendingPool _lendingPool, IIncentivesController _incentivesController, address[] memory _assets) {
    // create an array to store return data
    Data[] memory _returnData = new Data[](_assets.length);

    for (uint256 i = 0; i < _assets.length; i++) {
      DataTypes.ReserveData memory _reserveData = _lendingPool.getReserveData(_assets[i]);
      uint256 currentLiquidityRate = _reserveData.currentLiquidityRate;
      address aTokenAddress = _reserveData.aTokenAddress;

      // asset is the ERC20 supplied or borrowed, eg. DAI, WETH
      (, uint256 aEmissionPerSecond,) = _incentivesController.getAssetData(aTokenAddress);

      _returnData[i] = Data({
        currentLiquidityRate: currentLiquidityRate,
        aTokenAddress: aTokenAddress,
        aEmissionPerSecond: aEmissionPerSecond
      });
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
