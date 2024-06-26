// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.23;

import {DataTypes} from './DataTypes.sol';
import {IPool} from './IPool.sol';
import {IPoolDataProvider} from './IPoolDataProvider.sol';

struct Data {
  uint256 liquidityRate; // to calc supply rate, deposit apr, deposit apy
}
