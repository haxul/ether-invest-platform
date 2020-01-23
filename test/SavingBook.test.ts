const assert = require("assert")
const ganache = require("ganache-cli")
const Web3 = require("web3")
const web3 = new Web3(ganache.provider())
const ABI = require("../smartContract/ABI")

let account = web3.eth.accounts.create()
let accounts: string[]
let savingBookContract: any

beforeEach(async () => {
  accounts = await web3.eth.getAccounts()
  savingBookContract = await new web3.eth.Contract(ABI, account.address)
})

describe(" init smart contract", async () => {
  it("creates accounts", () => assert(accounts.length !== 0))
  it("depoys smart contract", () => {
    assert(savingBookContract._address)
  })
})

describe("send ether to smart contract", async () => {
  it("transfers one to manager account", async () => {
    const hash = await savingBookContract.methods.transfer().send({ from: accounts[0], value: web3.utils.toWei(".01", "ether") })
    assert(hash.transactionHash)
  })

  it("set last time of invest", async () => {
    const hash = await savingBookContract.methods.setLastTimeInvesting(accounts[0]).send({ from: accounts[0] })
    assert(hash.transactionHash)
  })

  it("test function", async () => {
    const hash = await savingBookContract.methods.test().call()
    assert(hash)
  })
})
