# Changelog

## [2.0.6] - 2026-01-23

### Changed

- Fix handling of email addresses with a period followed by a space in the local part (e.g., `g. speel@example.com`). These addresses are now correctly marked as exceptional. Quoted spaces (e.g., `"g speel"@example.com`) remain valid per RFC 5322.

## [2.0.5] - 2025-12-19

### Changed

- Added `klass` method to ActiveJob serializers for Rails 8.1 compatibility. Rails 8.1 changed how `ActiveJob::Serializers::ObjectSerializer` works and now requires a `klass` method to be defined. The following serializers have been updated:
  - `HttpUrlSerializer`
  - `EmailAddressSerializer`
  - `PublicDomainSuffixSerializer`
