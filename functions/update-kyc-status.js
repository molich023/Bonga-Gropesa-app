// functions/update-kyc-status.js
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Limit each IP to 5 requests per window
});

exports.handler = limiter(async (event) => {
  // Your existing logic...
});
// functions/update-kyc-status.js
const { Resend } = require('@resend/resend-js');
const resend = new Resend('YOUR_RESEND_API_KEY');

exports.handler = async (event) => {
  const { submissionId, status, userAddress, phoneNumber } = JSON.parse(event.body);

  // Update Firestore and smart contract (as before)...

  // Send SMS
  const { data, error } = await resend.sms.send({
    from: 'GroPesa <noreply@gropesa.com>',
    to: phoneNumber, // e.g., '+254712345678'
    text: status === 'approved'
      ? 'Your GroPesa KYC is approved! You can now redeem GRO.'
      : 'Your GroPesa KYC was rejected. Please resubmit.',
  });

  if (error) {
    console.error('SMS Error:', error);
  }

  return { statusCode: 200, body: JSON.stringify({ success: true }) };
};
