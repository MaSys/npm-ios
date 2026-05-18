# Proxy Hosts Search Bar

## Summary

Add a native SwiftUI search bar to `ProxiesView` that filters the proxy list by domain name and forward host.

## Scope

Single file change: `NPM/Views/ProxiesView.swift`. No model or `AppService` changes.

## Implementation

- Add `@State private var searchText = ""` to `ProxiesView`
- Add computed property `filteredProxies: [Proxy]`:
  - Returns `appService.proxies` unchanged when `searchText` is empty
  - Otherwise filters to proxies where any element of `domain_names` or `forward_host` contains `searchText` (case-insensitive, diacritic-insensitive)
- Replace `ForEach(self.appService.proxies, ...)` with `ForEach(filteredProxies, ...)`
- Attach `.searchable(text: $searchText, prompt: "Search")` to the `NavigationStack`

## Behaviour

- Empty query → full list shown
- Query matches against all domain names (not just the first) and the forward host
- Matching is case-insensitive and diacritic-insensitive
- Search bar appears in the navigation bar, keyboard dismiss is handled natively by SwiftUI
