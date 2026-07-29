require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

IANA_TLD_URL = 'https://data.iana.org/TLD/tlds-alpha-by-domain.txt'.freeze
TLD_FILE = File.expand_path('lib/rails_values/tlds-alpha-by-domain.txt', __dir__)

desc 'Merge the current IANA top level domain list into tlds-alpha-by-domain.txt'
task :update_tlds do
  require 'net/http'

  published = Net::HTTP.get(URI(IANA_TLD_URL)).lines.map(&:chomp)
                       .reject { |line| line.empty? || line.start_with?('#') }
  # Retired tlds are kept so historical values in existing databases stay parsable.
  existing = File.readlines(TLD_FILE).map(&:chomp).reject(&:empty?)
  merged = (existing + published).uniq.sort

  File.write(TLD_FILE, "#{merged.join("\n")}\n")
  added = merged - existing
  puts "added #{added.empty? ? 'nothing' : added.join(' ')}"
end
