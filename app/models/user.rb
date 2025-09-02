class User < ApplicationRecord
  has_secure_password validations: false

  has_many :folders, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :provider, presence: true, if: -> { provider.present? || uid.present? }
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { provider.present? || uid.present? }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validate :must_be_oauth_or_password_user

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.name = auth.info.name
    end
  end

  def display_name
    name.presence || email.split("@").first
  end

  def oauth_user?
    oauth_attributes_present?
  end

  def password_user?
    !oauth_attributes_present?
  end

  private

  def password_required?
    !oauth_attributes_present? && (new_record? || password.present?)
  end

  def must_be_oauth_or_password_user
    if !oauth_attributes_present? && password_digest.blank?
      errors.add(:base, "User must have either OAuth credentials or a password")
    end
  end

  def oauth_attributes_present?
    provider.present? && uid.present?
  end
end
