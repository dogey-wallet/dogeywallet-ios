# UnstoppableDomainsResolution

[![Chat on Telegram](https://img.shields.io/badge/Chat%20on-Telegram-brightgreen.svg)](https://t.me/unstoppabledev) [![Unstoppable Domains Documentation](https://img.shields.io/badge/docs-unstoppabledomains.com-blue)](https://docs.unstoppabledomains.com/)

Resolution is a library for interacting with blockchain domain names. It can be used to retrieve [payment addresses](https://unstoppabledomains.com/features#Add-Crypto-Addresses), IPFS hashes for [decentralized websites](https://unstoppabledomains.com/features#Build-Website), and GunDB usernames for [decentralized chat](https://unstoppabledomains.com/chat).

Resolution is primarily built and maintained by [Unstoppable Domains](https://unstoppabledomains.com/).

Resoultion supports decentralized domains across three main zones:

- Crypto Name Service (CNS)
  - `.crypto`
- Zilliqa Name Service (ZNS)
  - `.zil`
- Ethereum Name Service (ENS)
  - `.eth`
  - `.kred`
  - `.xyz`
  - `.luxe`

For more information, see our detailed [API Referrence](https://unstoppabledomains.github.io/resolution/).

# Installation into the project

## Cocoa Pods

```ruby
pod 'UnstoppableDomainsResolution', '~> 0.1.6'
```

## Swift Package Manager

```swift
package.dependencies.append(
    .package(url: "https://github.com/unstoppabledomains/resolution-swift", from: "0.1.6")
)
```

# Usage

 - Create an instance of the Resolution class
 - Call any method of the Resolution class asyncronously

> NOTE: make sure an instance of the Resolution class is not deallocated until the asyncronous call brings in the result.

# Common examples

```swift
import UnstoppableDomainsResolution

  ...

guard let resolution = try? Resolution() else {
  print ("Init of Resolution instance with default parameters failed...")
  return
}

// Or, if you want to use a specific providerUrl and network:
guard let resolution = try? Resolution(providerUrl: "https://main-rpc.linkpool.io", network: "mainnet") else {
  print ("Init of Resolution instance with custom parameters failed...")
  return
}

resolution.addr(domain: "brad.crypto", ticker: "btc") { result in
  switch result {
  case .success(let returnValue):
    // bc1q359khn0phg58xgezyqsuuaha28zkwx047c0c3y
    let btcAddress = returnValue
  case .failure(let error):
    print("Expected btc Address, but got \(error)")
}
}

resolution.addr(domain: "brad.crypto", ticker: "eth") { result in
  switch result {
  case .success(let returnValue):
    // 0x8aaD44321A86b170879d7A244c1e8d360c99DdA8
    let ethAddress = returnValue
  case .failure(let error):
    print("Expected eth Address, but got \(error)")
  }
}

resolution.owner(domain: "brad.crypto") { result in
  switch result {
  case .success(let returnValue):
    // 0x8aaD44321A86b170879d7A244c1e8d360c99DdA8
    let domainOwner = returnValue
  case .failure(let error):
    XCTFail("Expected owner, but got \(error)")
  }
}
```

## Batch requesting of owners

Version 0.1.3 introduced the `batchOwners(domains: _, completion: _ )` method which adds additional convenience when making multiple domain owner queries.

> This method is only compatible with CNS-based domains. Using this method with any other domain type will throw the error: `ResolutionError.methodNotSupported`.

As opposed to the single `owner(domain: _, completion: _)` method, this batch request will return an array of owners `[String?]`. If the the domain is not registered or its value is `null`, the corresponding array element of the response will be `nil` without throwing an error.
 
```swift 
resolution.batchOwners(domains: ["brad.crypto", "otherbrad.crypto"]) { result in
  switch result {
  case .success(let returnValue):
    // returnValue: [String?] = <array of owners's addresses>
    let domainOwner = returnValue
  case .failure(let error):
    XCTFail("Expected owner, but got \(error)")
  }
}
```

# Networking

> Make sure your app has AppTransportSecurity settings to allow HTTP access to the `https://main-rpc.linkpool.io` domain.

## Custom Networking Layer

By default, this library uses the native iOS networking API to connect to the internet. If you want the library to use your own networking layer instead, you must conform your networking layer to the `NetworkingLayer` protocol. This protocol requires only one method to be implemented: `makeHttpPostRequest(url:, httpMethod:, httpHeaderContentType:, httpBody:, completion:)`. Using this method will bypass the default behavior and delegate the request to your own networking code.

For example, construct the Resolution instance like so:

```swift
guard let resolution = try? Resolution(networking: MyNetworkingApi) else {
  print ("Init of Resolution instance failed...")
  return
}
```

# Possible Errors:

If the domain you are attempting to resolve is not registered or doesn't contain the information you are requesting, this framework will return a `ResolutionError` with the possible causes below. We advise creating customized errors in your app based on the return value of the error.

```
enum ResolutionError: Error {
  case unregisteredDomain
  case unsupportedDomain
  case recordNotFound
  case recordNotSupported
  case unsupportedNetwork
  case unspecifiedResolver
  case unknownError(Error)
  case proxyReaderNonInitialized
  case inconsistenDomainArray
  case methodNotSupported
}
```

# Contributions

Contributions to this library are more than welcome. The easiest way to contribute is through GitHub issues and pull requests.
