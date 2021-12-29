
class ReportsMailer < ApplicationMailer
  def user_bonus_report(report)

    attachments[report.filename] = {mime_type: 'text/csv', content: report.to_csv}

    mail(
      to: 'accounting@opendatarescue.org',
      subject: "[DRAW] User Bonus Report: #{report.start_date.to_date} to #{report.end_date.to_date}",
      body: "Attached is the User Bonus Report generated at #{Time.current}"
    )

  end
end
