# Bonga App Privacy Policy

**Last Updated**: 25 March 2026

Bonga App ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose your information when you use our services.

---

## 1. Information We Collect

| **Data Type**       | **Purpose**                                                                                     | **Legal Basis**               |
|---------------------|-------------------------------------------------------------------------------------------------|-------------------------------|
| **Wallet Address**  | To link your GRO token balance and transactions.                                                | Contract Performance          |
| **Device ID**       | To identify your device in the mesh network (no personal data).                                | Legitimate Interest           |
| **IP Address**      | To block suspicious activity and prevent fraud.                                                 | Legitimate Interest           |
| **National ID**     | For KYC verification (Kenyan users only; deleted after verification).                          | Legal Obligation (CBK)        |
| **Message Metadata**| Timestamps and message IDs (content is E2E encrypted).                                          | Contract Performance          |
| **Location Data**   | Approximate location for mesh network optimization (opt-in).                                     | Consent                       |

**We do not collect**:
- Message content (E2E encrypted).
- Biometric data (except for liveness checks via FaceIO).

---

## 2. How We Use Your Information
- **Mesh Network Optimization**: Device IDs and location data improve offline connectivity.
- **KYC Verification**: National ID and liveness checks comply with Kenyan financial regulations.
- **Fraud Prevention**: IP blocking and device fingerprinting prevent abuse.
- **GRO Rewards**: Wallet addresses link to GRO balances and redemptions.

---

## 3. Data Sharing
We **do not sell** your data. We share data with:
- **FaceIO**: For liveness detection (KYC).
- **Chainlink Keepers**: To automate GRO rewards (no personal data shared).
- **Law Enforcement**: Only if required by Kenyan/EU law (e.g., AML investigations).

---

## 4. Data Security
- **Encryption**:
  - **E2E Encryption**: Messages are encrypted with **Matrix Olm/Megolm**.
  - **Storage**: Firebase data is encrypted at rest (AES-256).
- **Access Controls**:
  - Only **authorized admins** can access KYC data (Firebase Security Rules).
  - **Multi-Sig Wallets**: Admin actions require 2/3 approvals (OpenZeppelin Defender).
- **Blockchain Immutability**: GRO transactions are public and irreversible.

---

## 5. Data Retention
| **Data Type**       | **Retention Period** | **Notes**                                  |
|---------------------|----------------------|--------------------------------------------|
| **KYC Data**        | 5 years              | CBK requirement.                           |
| **Message Metadata**| 30 days              | Deleted automatically.                     |
| **IP Logs**         | 7 days               | Used for fraud detection.                 |
| **Wallet Addresses**| Permanent            | Required for GRO balances.                |

---

## 6. Your Rights (GDPR/Kenya DPA)
- **Access**: Request a copy of your data via `privacy@bonga.app`.
- **Rectification**: Correct inaccurate data (e.g., wallet address).
- **Erasure**: Request deletion (except for on-chain txs).
- **Objection**: Opt out of marketing communications.
- **Portability**: Export your data (e.g., message history).

**To exercise these rights**, contact: `privacy@bonga.app`.

---

## 7. Children’s Privacy
Bonga App is **not intended for children under 18**. We do not knowingly collect data from minors.

---

## 8. Changes to This Policy
We will notify users of material changes via **email** or **app notifications**.

---

## 9. Contact Us
For privacy questions:
- **Email**: privacy@bonga.app
- **Address**: Bonga App Ltd., Nairobi, Kenya
