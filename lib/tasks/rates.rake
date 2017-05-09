namespace :rates do
  desc "Delete FXRates older than 30 days"
  task delete_30_days_old: :environment do
    Rate.where(['created_at < ?', 30.days.ago]).destroy_all
  end

end
