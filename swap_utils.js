const crypto = require('crypto');

/**
 * Helper to generate a secret and its corresponding hash for the HTLC.
 */
function generateSecret() {
    const secret = crypto.randomBytes(32);
    const hash = crypto.createHash('sha256').update(secret).digest();
    return {
        secret: '0x' + secret.toString('hex'),
        hash: '0x' + hash.toString('hex')
    };
}

module.exports = { generateSecret };
