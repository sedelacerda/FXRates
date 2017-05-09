require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


s.every '1m' do
  puts 'Comenzando: ' << Time.now.to_s
  Rate.update_rates
  puts 'Finalizando: ' << Time.now.to_s
end

s.every '1d', :at => '3:00 am' do
  puts 'Cleaning FXRates older than 30 days'
  system("rake rates:delete_30_days_old")
  puts 'End cleaning'
end
