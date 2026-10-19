// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;
interface IOrbitBadge {
    function mintBadge(address user, uint256 badgeId) external;
    function hasBadge(address user, uint256 badgeId) external view returns (bool);
}
