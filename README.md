# Aptogotchi Contract

A virtual pet (Tamagotchi-style) smart contract built on the Aptos blockchain using Move programming language. This project demonstrates the implementation of a digital pet system with token objects, energy management, and interactive gameplay mechanics.

## 🎮 Project Overview

Aptogotchi is a blockchain-based virtual pet game where users can:
- Create unique digital pets as NFT tokens
- Feed their pets to increase energy (up to maximum of 10)
- Play with their pets to consume energy
- Own and manage their pets through blockchain interactions

## 🏗️ Architecture

The project includes two implementations:

### 1. Simple Implementation (Commented)
- Basic resource-based storage
- Direct account association
- Simple energy management

### 2. Advanced Implementation (Active)
- **Token Objects**: Uses Aptos Token Objects framework for NFT functionality
- **Collection Management**: Centralized collection with individual token ownership
- **Object Controller**: Advanced permission system with extend references
- **Transfer Mechanics**: Automatic token transfer from creator to user

## 📁 Project Structure

```
aptogotchi-contract/
├── sources/
│   └── aptogotchi.move          # Main contract implementation
├── tests/
│   └── aptogotchi_tests.move    # Comprehensive test suite
├── build/                       # Compiled bytecode and artifacts
├── scripts/                     # Deployment and interaction scripts
├── Move.toml                    # Project configuration
└── README.md                    # This file
```

## 🔧 Core Components

### Smart Contract Features

#### Structs
- **`ObjectController`**: Manages app-level permissions and references
- **`Aptogotchi`**: Individual pet data with name, birthday, energy, and NFT references

#### Core Functions
- **`create_aptogotchi(user, name)`**: Creates a new digital pet NFT
- **`feed(account, amount)`**: Increases pet energy (max 10)
- **`play(account, amount)`**: Decreases pet energy through play
- **`get_aptogotchi_address(user)`**: Retrieves pet's token address
- **`get_app_signer()`**: Gets the app's signer for operations

#### Constants
- `MAX_ENERGY`: 10 (maximum energy points)
- `MIN_ENERGY`: 0 (minimum energy points)
- Collection metadata: Name, description, and URI

## 🧪 Testing

The project includes a comprehensive test suite covering:

### Test Categories
1. **Pet Creation Tests**
   - Basic creation with various name types
   - Multiple users creating different pets
   - Duplicate creation prevention
   - Special characters and edge cases

2. **Feeding Mechanism Tests**
   - Basic feeding with different amounts
   - Zero amount feeding
   - Maximum energy constraints
   - Cumulative feeding limits
   - Error cases (no pet, exceeding limits)

3. **Playing Mechanism Tests**
   - Basic playing with energy consumption
   - Zero amount playing
   - Playing with all available energy
   - Error cases (insufficient energy, no pet)

4. **Complex Interaction Tests**
   - Sequential feed and play operations
   - Multiple play sessions
   - Boundary value testing

5. **Utility Function Tests**
   - Address retrieval
   - App signer functionality
   - Multi-user scenarios

### Running Tests

```bash
aptos move test
```

## 🚀 Deployment

### Prerequisites
- Aptos CLI installed
- Configured Aptos account
- Sufficient APT tokens for gas fees

### Configuration
Update `Move.toml` with your address:
```toml
[addresses]
huy_addr = "YOUR_ADDRESS_HERE"
aptogotchi_addr = "YOUR_ADDRESS_HERE"
```

### Deploy Command
```bash
aptos move publish
```

## 🎯 Usage Examples

### Creating a Pet
```move
// Call the create_aptogotchi function
public entry fun create_aptogotchi(user: &signer, name: String)
```

### Feeding Your Pet
```move
// Feed your pet 3 energy points
public entry fun feed(account: &signer, amount: u64)  // amount = 3
```

### Playing with Your Pet
```move
// Play and consume 2 energy points
public entry fun play(account: &signer, amount: u64)  // amount = 2
```

## 🔒 Security Features

- **Energy Bounds**: Prevents energy from exceeding maximum or going below zero
- **Ownership Verification**: Only pet owners can interact with their pets
- **Resource Management**: Proper global resource borrowing and mutation
- **Object Controller**: Centralized permission management for app operations

## 🧩 Technical Details

### Dependencies
- **AptosFramework**: Core blockchain functionality
- **AptosTokenObjects**: NFT and token object management
- **AptosStdlib**: Standard library utilities
- **MoveStdlib**: Move language standard library

### Key Design Patterns
- **Resource Pattern**: Using global resources for state management
- **Object Pattern**: Leveraging Aptos Token Objects for NFT functionality
- **Controller Pattern**: Centralized app management with extend references
- **Error Handling**: Comprehensive assertion-based validation

## 🐛 Error Handling

The contract handles various error scenarios:
- Invalid energy amounts (too high/low)
- Missing pets (resource not found)
- Invalid UTF-8 strings in names
- Permission and ownership violations

## 📊 Gas Optimization

- Efficient resource borrowing patterns
- Minimal on-chain storage
- Optimized token object operations
- Batch operations where possible

## 🔮 Future Enhancements

Potential improvements and features:
- Pet aging and lifecycle management
- Different pet types with unique attributes
- Breeding and genetics system
- Marketplace for pet trading
- Achievement and reward systems
- Multi-token support (feeding items, toys, etc.)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Aptos Labs for the blockchain platform
- Move language development team
- Token Objects framework contributors

---

**Happy pet raising! 🐾**
