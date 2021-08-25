const { expect } = require("chai");
const tokens = require("../utils/tokens");
const { DAI, USDC, RAI } = require('../utils/tokens');

async function getFirstNTokens(honeypot, n) {
  let firstNTokens = [];
  for (i = 0; i < n; i++) {
    firstNTokens.push(await honeypot.tokens(i));
  }
  return firstNTokens;
}

describe("token managing", function () {

  let honeypot;
  beforeEach(async function() {
    const HONEYPOT = await ethers.getContractFactory("HONEYPOT");
    honeypot = await HONEYPOT.deploy();
    await honeypot.deployed();
  })

  describe("addToken", function () {
    describe("if adding same token address twice", function() {
      // TODO: should I check the overall state of the contract instead???
      // TODO: I didn't even make sure {tokens} was the same...
      it("tokens.length should be the same", async function () {
        await honeypot.addToken(DAI);
        const tokenCount0 = await honeypot.tokensCount();

        await honeypot.addToken(DAI);
        const tokenCount1 = await honeypot.tokensCount()

        expect(tokenCount1)
          .to
          .equal(tokenCount0);
      });
    })

    describe("if adding new token", function() {
      it("tokens should be one member longer", async function () {
        await honeypot.addToken(DAI);
        const tokenCount0 = await honeypot.tokensCount();

        await honeypot.addToken(USDC);
        const tokenCount1 = await honeypot.tokensCount()

        expect(Number(tokenCount1))
          .to
          .equal(Number(tokenCount0) + 1);
      });
      it("tokens[-1] should be tokenAddress", async function () {
        await honeypot.addToken(DAI);
        await honeypot.addToken(USDC);
        const tokenCount = await honeypot.tokensCount();
        const resAddress = await honeypot.tokens(Number(tokenCount)-1);

        expect(resAddress.toUpperCase())
          .to
          .equal(USDC.toUpperCase());
      });
      it("tokens[:-1] == (previous) tokens", async function () {
        await honeypot.addToken(DAI);
        await honeypot.addToken(USDC);

        // get the previous tokens
        const tokenCount0 = await honeypot.tokensCount();
        const tokens0 = await getFirstNTokens(honeypot, Number(tokenCount0));

        await honeypot.addToken(RAI);

        // get tokens[:-1]
        const tokenCount1 = await honeypot.tokensCount();
        const tokens1 = await getFirstNTokens(honeypot, Number(tokenCount1)-1)

        expect(tokens1)
          .to
          .have
          .ordered.members(tokens0);
      });
    })
  });

  describe("removeTokens", function () {
    describe("if tokenAddress in tokens", function() {
      it("should return true if `tokenAddress` in `tokens`", async function () {});
      it("should be one member less if successful pop", async function () {});
      it("last element should be swapped to tokenAddress's index", async function () {});
    });

    describe("if tokenAddress not in tokens", function() {
      it("should return false if `tokenAddress` not in `tokens`", async function () {});
    });
  })

})
