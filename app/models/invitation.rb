class Invitation < ApplicationRecord
  has_secure_token length: 64
  belongs_to :owner, class_name: "User", default: -> { Current.user }
  belongs_to :user, optional: true
  belongs_to :campaign

  validates_presence_of :email
  validates :campaign, uniqueness: { scope: :email, message: "can't invite a user more than once." }

  after_create :send_invitation_email

  scope :persisted, -> { select(&:persisted?) }
  scope :pending, -> { where(accepted_at: nil).where(rejected_at: nil) }

  def status
    return "Accepted" if accepted?
    return "Rejected" if rejected?

    "Pending"
  end

  def accept!
    user = self.user || User.find_by(email: email)

    self.campaign.members << user
    update!(accepted_at: Time.now)
  end

  def accepted?
    accepted_at.present?
  end

  def rejected?
    rejected_at.present?
  end

  private

    def send_invitation_email
      InvitationMailer.with(invitation: self).confirm.deliver_later
    end
end
