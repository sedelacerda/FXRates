require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#
s.every '1m' do
  puts 'Comenzando: ' << Time.now.to_s
  Rate.update_rates
  puts 'Finalizado: ' << Time.now.to_s
end
