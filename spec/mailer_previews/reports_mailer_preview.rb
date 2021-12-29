class ReportsMailerPreview < ActionMailer::Preview
  def user_bonus_report
    report = UserBonusReport.new(
      start_date: '2021-05-02',
      end_date: '2021-12-28'
    )
    ReportsMailer.user_bonus_report(report)
  end
end
