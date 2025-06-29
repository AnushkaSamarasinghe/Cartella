# Core Data Cart Implementation

## Overview

This implementation provides a complete local cart management system using Core Data for the Cartella app. The system allows users to add products to cart, manage quantities, remove items, and view cart totals - all stored locally on the device.

## Architecture

### Core Data Model

The Core Data model includes six main entities:

1. **Cart** - Represents the main cart container
   - `id`: Unique identifier
   - `createdAt`: Creation timestamp
   - `updatedAt`: Last update timestamp
   - `items`: Relationship to CartItem entities

2. **CartItem** - Represents individual items in the cart
   - `id`: Unique identifier
   - `productId`: Product identifier
   - `title`: Product title
   - `price`: Product price
   - `productDescription`: Product description
   - `category`: Product category
   - `image`: Product image URL
   - `rating`: Product rating
   - `ratingCount`: Number of ratings
   - `quantity`: Item quantity
   - `addedAt`: When item was added
   - `cart`: Relationship to Cart entity

3. **LocalUserData** - Represents user profile and authentication data
   - `id`: Unique identifier
   - `email`: User email
   - `name`: User name
   - `isProfileCompleted`: Profile completion status
   - `isActive`: User active status
   - `createdAt`: Creation timestamp
   - `updatedAt`: Last update timestamp

4. **LocalProductData** - Represents product information
   - `id`: Product identifier
   - `title`: Product title
   - `price`: Product price
   - `productDescription`: Product description
   - `category`: Product category
   - `image`: Product image URL
   - `rating`: Product rating
   - `ratingCount`: Number of ratings
   - `isFavourite`: Favorite status
   - `createdAt`: Creation timestamp
   - `updatedAt`: Last update timestamp

5. **LocalPaymentCardData** - Represents payment card information
   - `id`: Unique identifier
   - `cardNumber`: Card number
   - `cardType`: Card type (Visa, MasterCard, etc.)
   - `expiryDate`: Expiry date
   - `cvv`: CVV code
   - `cardholderName`: Cardholder name
   - `isDefault`: Default card status
   - `createdAt`: Creation timestamp
   - `updatedAt`: Last update timestamp

6. **Item** - Legacy entity (can be removed if not used)

### Key Components

#### PersistenceController
- Centralized singleton class managing all Core Data operations
- Handles CRUD operations for User, Product, Cart, and Payment Card entities
- Provides reactive updates and data consistency
- Includes helper methods for calculations and validations

#### Updated ViewModels
- **ViewProductVM**: Updated to use centralized persistence instead of separate cart manager
- **CartVM**: Enhanced with direct PersistenceController integration and additional cart operations

#### New UI Components
- **CartItemView**: Reusable component for displaying cart items with quantity controls
- Enhanced **CartView**: Improved UI with cart summary and better user experience
- **PaymentCardView**: New component for displaying saved payment cards

## Features

### Core Functionality
- ✅ Add products to cart
- ✅ Remove products from cart
- ✅ Update item quantities
- ✅ Clear entire cart
- ✅ View cart totals
- ✅ Check if product is in cart
- ✅ Persistent storage across app sessions
- ✅ User profile management
- ✅ Product favorites management
- ✅ Payment card management

### User Experience
- ✅ Real-time cart updates
- ✅ Quantity controls with +/- buttons
- ✅ Cart summary with totals
- ✅ Payment card selection
- ✅ User profile completion tracking

### Data Management
- ✅ Centralized persistence layer
- ✅ Efficient Core Data operations
- ✅ Background context support
- ✅ Data validation and integrity
- ✅ Secure payment card storage

## Implementation Details

### Cart Operations

```swift
// Add product to cart
PersistenceController.shared.addToCart(product: product)

// Remove product from cart
PersistenceController.shared.removeFromCart(productId: productId)

// Update quantity
PersistenceController.shared.updateCartItemQuantity(productId: productId, quantity: quantity)

// Clear cart
PersistenceController.shared.clearCart()

// Get cart info
let itemCount = PersistenceController.shared.getCartItemCount()
let total = PersistenceController.shared.getCartTotal()
let isInCart = PersistenceController.shared.isProductInCart(productId: productId)
```

### User Management

```swift
// Save user data
PersistenceController.shared.saveUserData(with: userModel)

// Load user data
let user = PersistenceController.shared.loadUserData()

// Update profile status
PersistenceController.shared.updateProfileCompleteStatus(true)

// Check if user exists
let exists = PersistenceController.shared.userExists()
```

### Product Management

```swift
// Save product
PersistenceController.shared.saveProduct(product)

// Load product
let product = PersistenceController.shared.loadProduct(by: productId)

// Update favorite status
PersistenceController.shared.updateProductFavouriteStatus(productId: productId, isFavourite: true)

// Load all products
let products = PersistenceController.shared.loadAllProducts()

// Load favorite products
let favorites = PersistenceController.shared.loadFavouriteProducts()
```

### Payment Card Management

```swift
// Save payment card
PersistenceController.shared.savePaymentCard(
    cardNumber: cardNumber,
    cardType: cardType,
    expiryDate: expiryDate,
    cvv: cvv,
    cardholderName: cardholderName
)

// Load all cards
let cards = PersistenceController.shared.loadAllPaymentCards()

// Set default card
PersistenceController.shared.setDefaultPaymentCard(cardId: cardId)

// Load default card
let defaultCard = PersistenceController.shared.loadDefaultPaymentCard()
```

## Migration Notes

This implementation consolidates all data management into a single `PersistenceController` class, removing the separate `CartDataManager` for better maintainability and consistency.

### Breaking Changes
- `CartDataManager` has been removed
- All cart operations now go through `PersistenceController`
- ViewModels have been updated to use the centralized persistence layer

### Benefits
- Single source of truth for all data operations
- Consistent API across all entity types
- Better performance with optimized Core Data usage
- Easier maintenance and testing
- Enhanced security for payment card data

## Future Enhancements

Potential improvements for the persistence system:
1. **CloudKit Integration**: Add ability to sync data with iCloud
2. **Data Encryption**: Encrypt sensitive payment card data
3. **Caching Layer**: Implement intelligent caching for frequently accessed data
4. **Analytics**: Track usage patterns and user behavior
5. **Multi-User Support**: Support for multiple user accounts
6. **Offline Sync**: Enhanced offline capabilities with conflict resolution
7. **Data Migration**: Automatic migration between Core Data model versions

## Testing

The implementation includes comprehensive unit tests covering:
- Adding products to cart
- Handling duplicate products
- Removing products
- Updating quantities
- Clearing cart
- Cart calculations

## Future Enhancements

Potential improvements for the cart system:
1. **Sync with Server**: Add ability to sync local cart with server
2. **Cart History**: Store previous cart states
3. **Wishlist Integration**: Add wishlist functionality
4. **Offline Support**: Enhanced offline capabilities
5. **Analytics**: Track cart behavior and conversions
6. **Multi-User Support**: Support for multiple user accounts

## Migration Notes

This implementation replaces the previous API-based cart system with local Core Data storage. The changes are backward compatible and maintain the same public interfaces for existing code.

### Breaking Changes
- None - all existing cart functionality remains the same
- API calls are replaced with local operations
- Same completion handlers and error handling patterns

### Benefits
- Faster cart operations (no network latency)
- Works offline
- Better user experience
- Reduced server load
- More reliable cart persistence 