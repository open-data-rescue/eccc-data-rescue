namespace :data_entries do
  desc "Sets correct timestamps from data entry annotation"
  task :correct_timestamps => :environment do
    require 'annotation'

    Annotation.includes(:data_entries).find_in_batches do |annotations|
      annotations.each do |annotation|
        annotation.data_entries.update_all(
          created_at: annotation.created_at,
          updated_at: annotation.updated_at
        )
      end
    end
  end

  desc "Deletes data entries with null values"
  task :clear_nulls => :environment do
    require 'data_entry'

    DataEntry.where(value: nil).delete_all
  end

  desc "Calculate statistics on user data entries"
  task :calculate_user_statistics, [:start_date, :end_date] => :environment do |t, args|
    require 'user_bonus_report'
    require 'reports_mailer'

    report = UserBonusReport.new(
      start_date: args[:start_date],
      end_date: args[:end_date]
    )
    puts report.processed_report
    mailer = ReportsMailer.user_bonus_report(report).deliver_now
  end
end
