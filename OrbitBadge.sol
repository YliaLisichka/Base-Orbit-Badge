// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract OrbitBadge {
    struct Badge {
        string title;
        uint256 tier;
        uint256 issuedAt;
        bool isActive;
    }

    address public registryAdmin;
    uint256 public totalBadgesIssued;

    mapping(address => Badge) public userBadges;
    mapping(address => string) public userBios;

    event BadgeIssued(address indexed recipient, string title, uint256 tier);
    event BadgeUpgraded(address indexed recipient, uint256 newTier);
    event BadgeRevoked(address indexed recipient);
    event BioUpdated(address indexed user, string newBio);

    modifier onlyAdmin() {
        require(msg.sender == registryAdmin, "OrbitBadge: Not an admin");
        _;
    }

    constructor() {
        registryAdmin = msg.sender;
    }

    // 1. Выдать бейдж пользователю
    function issueBadge(address recipient, string calldata title, uint256 tier) external onlyAdmin {
        require(recipient != address(0), "OrbitBadge: Zero address rejected");
        require(tier > 0, "OrbitBadge: Tier must be positive");

        userBadges[recipient] = Badge({
            title: title,
            tier: tier,
            issuedAt: block.timestamp,
            isActive: true
        });

        totalBadgesIssued++;
        emit BadgeIssued(recipient, title, tier);
    }

    // 2. Повысить тир бейджа
    function upgradeBadgeLevel(address recipient, uint256 additionalTiers) external onlyAdmin {
        require(userBadges[recipient].isActive, "OrbitBadge: Badge is not active");
        require(additionalTiers > 0, "OrbitBadge: Increment must be positive");

        userBadges[recipient].tier += additionalTiers;
        emit BadgeUpgraded(recipient, userBadges[recipient].tier);
    }

    // 3. Установить статусную фразу своего профиля (может вызывать любой кошелек)
    function setStatusBio(string calldata bio) external {
        require(bytes(bio).length > 0 && bytes(bio).length <= 140, "OrbitBadge: Length must be 1-140 chars");
        userBios[msg.sender] = bio;
        emit BioUpdated(msg.sender, bio);
    }

    // 4. Отозвать / деактивировать бейдж
    function revokeBadge(address recipient) external onlyAdmin {
        require(userBadges[recipient].isActive, "OrbitBadge: Already inactive");
        userBadges[recipient].isActive = false;
        emit BadgeRevoked(recipient);
    }

    // Чтение информации о профиле
    function getProfile(address user) external view returns (
        string memory title,
        uint256 tier,
        uint256 issuedAt,
        bool isActive,
        string memory bio
    ) {
        Badge memory b = userBadges[user];
        return (b.title, b.tier, b.issuedAt, b.isActive, userBios[user]);
    }
}