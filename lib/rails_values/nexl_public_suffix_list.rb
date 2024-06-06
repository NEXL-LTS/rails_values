NEXL_IGNORED_PUBLIC_SUFFIX = %w[qld.gov.au sa.gov.au tas.gov.au vic.gov.au wa.gov.au].freeze

NEXL_LIST = PublicSuffix::List.new
PublicSuffix::List.default.each { |r| NEXL_LIST.add(r) if !NEXL_IGNORED_PUBLIC_SUFFIX.include?(r.value) }