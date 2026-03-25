// functions/sync-matrix.js
const { Matrix } = require("matrix-js-sdk");
exports.handler = async (event) => {
  const { messages } = JSON.parse(event.body);
  const client = new Matrix({
    baseUrl: "https://matrix.org",
    accessToken: process.env.MATRIX_TOKEN,
    userId: "@bonga-bot:matrix.org",
  });
  for (const msg of messages) {
    await client.sendTextMessage("!your-room-id:matrix.org", msg);
  }
};
