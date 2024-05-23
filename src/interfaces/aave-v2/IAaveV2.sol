// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.23;

import {DataTypes} from './DataTypes.sol';
import {IIncentivesController} from './IIncentivesController.sol';
import {ILendingPool} from './ILendingPool.sol';

struct Data {
  uint256 currentLiquidityRate;
  address aTokenAddress;
  uint256 aEmissionPerSecond;
}
