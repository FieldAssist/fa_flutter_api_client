/// SSL Certificate Pinning Configuration
class SslPinningConfig {
  /// Map of domain to list of allowed SHA-256 fingerprints
  final Map<String, List<String>> _domainFingerprints;

  /// Whether to block requests to unpinned domains
  final bool strictMode;

  /// Whether SSL pinning is enabled
  final bool enabled;

  const SslPinningConfig({
    required Map<String, List<String>> domainFingerprints,
    this.strictMode = true,
    this.enabled = true,
  }) : _domainFingerprints = domainFingerprints;

  /// Check if a domain is pinned
  bool isDomainPinned(String domain) {
    return _domainFingerprints.containsKey(domain);
  }

  /// Get fingerprints for a domain
  List<String> getFingerprintsForDomain(String domain) {
    return _domainFingerprints[domain] ?? [];
  }

  /// Get all pinned domains
  List<String> getPinnedDomains() {
    return _domainFingerprints.keys.toList();
  }
}
