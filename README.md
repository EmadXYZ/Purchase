# 🛡️ SecurePurchase – A Minimalistic Escrow Smart Contract

A **secure**, **transparent**, and **decentralized** escrow contract for facilitating trustless transactions between a buyer and a seller. Funds are locked and only released upon delivery confirmation, all powered by Ethereum and written in Solidity.

🔐 A fair system for digital transactions without intermediaries.

---

## 🟢 Live Contract on zkSync

✅ [View on zkSync Explorer](https://sepolia.explorer.zksync.io/address/0xe76709990f439037e9cb541a81222bB6dAFeED18#contract#contract-info)

---

## 📦 Overview

- **Language:** Solidity (`^0.8.24`)  
- **Network:** zkSync Sepolia  
- **Purpose:** A simple escrow system where the seller and buyer deposit funds, ensuring fairness in delivery-based payments.

---

## ✨ Key Features

✅ **Double Deposit Mechanism** – Buyer and seller both lock funds to ensure mutual commitment.  
✅ **Abort Option** – Seller can abort the contract before the buyer confirms, reclaiming their deposit.  
✅ **State-Driven Workflow** – Ensures correct function usage based on the contract’s lifecycle.  
✅ **Secure Transfers** – Uses `.call` for safer ETH transfers and zkSync compatibility.  
✅ **Minimalistic Design** – Lightweight code, clear states, and precise access control.

---

## 🔐 Security Considerations

- **State Validation:** Every critical function enforces execution only in a specific state using the `inState` modifier.  
- **Access Control:** Custom errors and modifiers (`onlyBuyer`, `onlySeller`) prevent unauthorized function calls.  
- **Safe ETH Transfers:** Uses `call` instead of `transfer` to avoid gas issues and enhance zkSync compatibility.  
- **Deposit Integrity:** Constructor enforces even value for accurate escrow balancing.

---

## 🧾 License

This project is licensed under the **MIT License** – feel free to use, adapt, and build upon it!

🚀 *Open-source contributions are welcome – Fork it and submit your ideas!*

---

## 📥 Clone & Use

```bash
git clone https://github.com/EmadXYZ/Purchase.git
