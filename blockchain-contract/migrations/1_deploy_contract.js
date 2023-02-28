var CorporateVoting = artifacts.require('CorporateVoting');

module.exports = function (deployer) {
    deployer.deploy(CorporateVoting);
};