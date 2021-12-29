require 'csv'

# Base report provining common functionality
class UserBonusReport < BaseReport
  attr_accessor :start_date, :end_date, :report

  def initialize(start_date:, end_date:)
    self.start_date = Time.zone.parse(start_date)
    self.end_date = Time.zone.parse(end_date).end_of_day
  end

  def collection
    data_entries = DataEntry.arel_table
    date_query = data_entries[:created_at].gteq(start_date).and(
      data_entries[:created_at].lteq(end_date)
    )

    DataEntry.where.not(value: nil)
             .where(date_query)
             .order(:user_id)
  end

  def process_report
    self.report = collection.group(:user_id).select(:user_id).count
  end

  def processed_report
    process_report
    users = User.where(id: report.keys).select(:id, :email).to_a

    report.transform_keys! do |user_id|
      users.find{ |user| user.id == user_id }
    end

    report.transform_values! do |count|
      bonus_payout = BigDecimal(BigDecimal("#{count}") / BigDecimal('1000') * BigDecimal('1.5')).round(2)
      {
        data_entries: count,
        bonus_payout: bonus_payout.to_s,
        bonus_payout_dollars: ActionController::Base.helpers.number_to_currency(bonus_payout)
      }
    end
  end

  def filename(format: 'csv')
    "user_bonus_report_S-#{start_date.to_date}_E-#{end_date.to_date}_G-#{Time.current.strftime('%m-%d-%Y.%H.%M.%S')}.#{format}"
  end

  def to_csv
    CSV.generate(headers: true, encoding: 'UTF-8') do |csv|
      csv << report_headers

      processed_report.each do |user, stats|
        csv << [user.id, user.email, stats[:data_entries], stats[:bonus_payout], stats[:bonus_payout_dollars]]
      end
    end
  end

  def report_headers
    %w[ user_id user_email data_entries bonus_payout bonus_payout_dollars ]
  end
end
