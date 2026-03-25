const { Pool } = require('pg');

exports.handler = async (event) => {
  const { email, action } = JSON.parse(event.body);
  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
  });

  try {
    // Mint points based on action (e.g., invite friend = +10)
    const points = action === 'invite' ? 10 : 1;
    await pool.query(
      `UPDATE users
       SET bonga_points = bonga_points + $1
       WHERE email = $2`,
      [points, email]
    );
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Points minted!', points }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  } finally {
    await pool.end();
  }
};
