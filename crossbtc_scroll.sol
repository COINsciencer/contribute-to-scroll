pragma solidity ^0.8.0;

interface IBTCBridge {
    function lock(address recipient, uint256 amount) external payable;
}

contract BRC20Bridge {
    address public btcBridgeAddress;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "只有所有者才能调用此函数");
        _;
    }

    constructor(address _btcBridgeAddress) {
        btcBridgeAddress = _btcBridgeAddress;
        owner = msg.sender;
    }

    function lockBRC20(address recipient, uint256 amount) external {
        // 假设BRC20代币首先转移到此合约
        // 锁定BRC20代币并转移相应数量的BTC
        IBTCBridge btcBridge = IBTCBridge(btcBridgeAddress);
        btcBridge.lock{value: msg.value}(recipient, amount);
    }

    function setBTCBridgeAddress(address _btcBridgeAddress) external onlyOwner {
        btcBridgeAddress = _btcBridgeAddress;
    }

    function withdrawETH(uint256 amount) external onlyOwner {
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}
