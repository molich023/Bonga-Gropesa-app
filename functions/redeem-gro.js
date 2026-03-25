// functions/redeem-gro.js
const { ethers } = require('ethers');
const { Resend } = require('@resend/resend-js');
const resend = new Resend('YOUR_RESEND_KEY');

exports.handler = async (event) => {
  const { userAddress, amount, phoneNumber } = JSON.parse(event.body);

  // 1. Burn GRO from user
  const provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com/');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  const groContract = new ethers.Contract(
    process.env.GRO_CONTRACT_ADDRESS,
    [
      'function transferFrom(address from, address to, uint256 amount) external returns (bool)',
      'function burn(uint256 amount) external',
    ],
    wallet
  );
  await groContract.transferFrom(userAddress, process.env.GRO_REDEMPTION_ADDRESS, ethers.utils.parseEther(amount.toString()));

  // 2. Call PSP (Kopokopo) to send airtime
  const airtimeResponse = await fetch('https://api.kopokopo.com/v1/payouts', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${process.env.KOPOKOPO_KEY}` },
    body: JSON.stringify({
      phoneNumber,
      amount: amount * 0.5, // 100 GRO = 50 KES
      currency: 'KES',
    }),
  });

  // 3. Send SMS confirmation
  await resend.sms.send({
    from: 'GroPesa <noreply@gropesa.com>',
    to: phoneNumber,
    text: `You redeemed ${amount} GRO for airtime!`,
  });

  return { statusCode: 200, body: JSON.stringify({ success: true }) };
};
