require('assert');
require('should');

const helpers = require('../helpers');

// Used to build the solidity tightly packed buffer to sha3, ecsign
const util = require('ethereumjs-util');
const abi = require('ethereumjs-abi');
const crypto = require('crypto');

const Forwarder = artifacts.require('../Forwarder.sol');
const ForwarderFactory = artifacts.require('../ForwarderFactory.sol');

const assertVMException = (err, expectedErrMsg) => {
  err.message.toString().should.containEql('VM Exception');
  if (expectedErrMsg) {
    err.message.toString().should.containEql(expectedErrMsg);
  }
};

const createForwarderFromWallet = async (wallet, autoFlush = true) => {
  const parent = wallet.address;
  const salt = util.bufferToHex(crypto.randomBytes(20));
  const inputSalt = util.setLengthLeft(
    Buffer.from(util.stripHexPrefix(salt), 'hex'),
    32
  );
  const calculationSalt = abi.soliditySHA3(
    ['address', 'bytes32'],
    [parent, inputSalt]
  );
  const forwarderContract = await Forwarder.new([], {});
  const forwarderFactory = await ForwarderFactory.new(
    forwarderContract.address
  );
  const initCode = helpers.getInitCode(
    util.stripHexPrefix(forwarderContract.address)
  );
  const forwarderAddress = helpers.getNextContractAddressCreate2(
    forwarderFactory.address,
    calculationSalt,
    initCode
  );

  return {
    forwarderAddress,
    create: async () =>
      executeCreateForwarder(
        forwarderFactory,
        calculationSalt,
        inputSalt,
        initCode,
        parent,
        autoFlush
      )
  };
};

const executeCreateForwarder = async (
  factory,
  calculationSalt,
  inputSalt,
  initCode,
  parent,
  autoFlush = true
) => {
  const forwarderAddress = helpers.getNextContractAddressCreate2(
    factory.address,
    calculationSalt,
    initCode
  );

  await factory.createForwarder(parent, inputSalt, autoFlush, autoFlush);
  return Forwarder.at(forwarderAddress);
};

const getBalanceInWei = async (address) => {
  return web3.utils.toBN(await web3.eth.getBalance(address));
};

const calculateFutureExpireTime = (seconds) => {
  return Math.floor(new Date().getTime() / 1000) + seconds;
};

// Taken from http://solidity.readthedocs.io/en/latest/frequently-asked-questions.html -
// The automatic accessor function for a public state variable of array type only returns individual elements.
// If you want to return the complete array, you have to manually write a function to do that.
const isSigner = async function getSigners(wallet, signer) {
  return await wallet.signers.call(signer);
};

exports.assertVMException = assertVMException;
exports.createForwarderFromWallet = createForwarderFromWallet;
exports.executeCreateForwarder = executeCreateForwarder;
exports.getBalanceInWei = getBalanceInWei;
exports.calculateFutureExpireTime = calculateFutureExpireTime;
exports.isSigner = isSigner;
