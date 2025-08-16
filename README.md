# Web3Wallet

## 项目简介

Web3Wallet 是一个 Flutter 实现的多链 Web3 钱包，支持以下主流区块链的单链钱包、HD 钱包的创建、导入、导出，以及资产收款/转账等核心功能：

- 比特币（Bitcoin/BTC）
- 以太坊（Ethereum/ETH）
- BNB智能链（BNB Smart Chain/BSC）
- 波场（TRON/TRX）
- Solana（SOL）
- Polygon（MATIC）
- Avalanche（AVAX）
- Fantom（FTM）
- Arbitrum

## 功能特性

- 支持单链钱包、HD钱包的创建与导入
- 助记词、私钥、WIF 导入导出
- 钱包地址生成、二维码收款
- 各主流链的原生资产转账
- 钱包多链管理与切换
- Provider 状态管理
- 代码结构清晰，易于扩展 NFT、桥、云备份等功能

## 快速开始

1. 克隆本仓库
2. 安装依赖：`flutter pub get`
3. 运行：`flutter run`

## 目录结构

```
lib/
  main.dart
  models/
    wallet.dart
  providers/
    wallet_provider.dart
  screens/
    wallet/
      wallet_manager_screen.dart
      create_wallet_screen.dart
      import_wallet_screen.dart
      wallet_detail_screen.dart
      receive_screen.dart
      send_screen.dart
  services/
    btc_service.dart
    eth_service.dart
    export_service.dart
```

## 依赖建议

详见 `pubspec.yaml`，包含：
- provider
- bitcoin_flutter
- web3dart
- bip39
- bip32
- qr_flutter
- 其它链可扩展 tron_dart、solana 等

## 进阶功能
- 支持 NFT、跨链桥、冷热钱包、云备份等可按需扩展

---

> **开源协议说明**  
> 本项目为学习交流用途，代码结构与实现可直接用于实际钱包开发，但涉及私钥、助记词、资产安全等请务必加强安全防护并遵守相关合规要求。