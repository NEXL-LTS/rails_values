# Changelog

## [2.0.6] - 2026-01-23

### Changed

- Handle email addresses with spaces in the local part. Unquoted spaces (e.g., `g speel@example.com`) and quoted spaces (e.g., `"g speel"@example.com`) are now properly parsed and marked as exceptional while still allowing domain extraction.

## [2.0.5] - 2025-12-19

### Changed

- Added `klass` method to ActiveJob serializers for Rails 8.1 compatibility. Rails 8.1 changed how `ActiveJob::Serializers::ObjectSerializer` works and now requires a `klass` method to be defined. The following serializers have been updated:
  - `HttpUrlSerializer`
  - `EmailAddressSerializer`
  - `PublicDomainSuffixSerializer`
