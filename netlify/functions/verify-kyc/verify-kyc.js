// netlify/functions/verify-kyc/verify-kyc.js
const { WebSdk } = require('@sumsub/websdk');
const webSdk = new WebSdk({
  appToken: process.env.SUMSUB_APP_TOKEN,
  secretKey: process.env.SUMSUB_SECRET_KEY,
});

exports.handler = async (event) => {
  const { userId, userAddress } = JSON.parse(event.body);
  const isVerified = await checkKYCStatus(userId);
  if (isVerified) {
    // Call setKYCStatus on-chain
    const tx = await redemptionContract.setKYCStatus(userAddress, true);
    return { statusCode: 200, body: JSON.stringify({ success: true }) };
  } else {
    return { statusCode: 400, body: JSON.stringify({ error: "KYC pending" }) };
  }
};
