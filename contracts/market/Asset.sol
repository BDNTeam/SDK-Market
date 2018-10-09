pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../token/BDNToken.sol";

contract Asset {
  using SafeMath for uint;

  BDNToken bdn;

  string public assetId;
  uint public expectPrice;

  address public seller;
  address[] public buyers;
  mapping(address => uint) public buyerIndexes;

  address public referee;

  mapping(address => uint) public paidPrices;

  /// for why not using an automatic refund see:
  /// http://solidity.readthedocs.io/en/v0.4.24/common-patterns.html
  mapping(address => uint) public pendingWithdrawals;

  event NewBuyer(string asset, address seller, address buyer);

  constructor(address _bdn, address _referee, address _seller, string _assetId, uint _price) public {
    bdn = BDNToken(_bdn);
    referee = _referee;
    seller = _seller;
    assetId = _assetId;
    expectPrice = _price;
  }

  modifier onlyReferee {
    require(msg.sender == referee, "forbidden");
    _;
  }

  modifier onlyRefereeOrBuyer {
    bool isBuyer_ = isBuyer();
    require(isBuyer_ || msg.sender == referee, "forbidden");
    _;
  }

  /**
   * Before calling this method to buy an asset, the buyer should
   * call `BDNToken.approve(this_contract_address, price)` to approve
   * `this asset contract` to manipulate his allowance, since `this asset
   * contract` will role as a referee during the buying and selling process
   */
  function buy(uint price) public {
    require(price >= expectPrice, "less price");

    bdn.transferFrom(msg.sender, address(this), price);

    buyers.push(msg.sender);
    buyerIndexes[msg.sender] = 1;
    paidPrices[msg.sender] = price;
    emit NewBuyer(assetId, seller, msg.sender);
  }

  function isBuyer() public view returns(bool) {
    return buyerIndexes[msg.sender] == 1;
  }

  function deal() public onlyRefereeOrBuyer {
    uint v = expectPrice;
    if(isBuyer()) {
      v = paidPrices[msg.sender];
    }
    refund_(msg.sender, v);
  }

  function withdraw() public {
    withdraw_(msg.sender);
  }

  function withdrawTo(address u) public onlyReferee {
    withdraw_(u);
  }

  function withdraw_(address u) private {
    uint val = pendingWithdrawals[u];
    if (val > 0) {
      pendingWithdrawals[u] = 0;
      bdn.transfer(u, val);
    }
  }

  function refund() private {
    refund_(msg.sender,msg.value);
  }

  function refund_(address u, uint val) private {
    uint pf = pendingWithdrawals[u];
    pf = pf.add(val);
    pendingWithdrawals[u] = pf;
  }
}
