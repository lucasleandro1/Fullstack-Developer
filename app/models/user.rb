class User < ApplicationRecord
  include DashboardBroadcaster

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Active Storage for avatar image
  has_one_attached :avatar_image

  # Validations
  validates :full_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :role, presence: true, inclusion: { in: %w[user admin] }
  validates :avatar_url, format: { with: URI::DEFAULT_PARSER.make_regexp([ "http", "https" ]) }, allow_blank: true

  # Enums
  enum :role, { user: "user", admin: "admin" }

  # Scopes
  scope :admins, -> { where(role: "admin") }
  scope :regular_users, -> { where(role: "user") }

  # Methods
  def admin?
    role == "admin"
  end

  def display_name
    full_name.presence || email
  end

  def initials
    return "??" if full_name.blank?

    full_name.split(" ")
             .map { |word| word[0]&.upcase }
             .compact
             .first(2)
             .join
  end

  def avatar
    if avatar_image.attached?
      avatar_image
    elsif avatar_url.present?
      avatar_url
    else
      nil
    end
  end

  # Class methods
  def self.total_count
    count
  end

  def self.admin_count
    admins.count
  end

  def self.user_count
    regular_users.count
  end
end
