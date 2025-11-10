require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_one_attached(:avatar_image) }
  end

  describe "validations" do
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:email) }

    describe "avatar_url validation" do
      it "allows valid HTTP URLs" do
        user = build(:user, avatar_url: "http://example.com/avatar.jpg")
        expect(user).to be_valid
      end

      it "allows valid HTTPS URLs" do
        user = build(:user, avatar_url: "https://example.com/avatar.jpg")
        expect(user).to be_valid
      end

      it "allows blank avatar_url" do
        user = build(:user, avatar_url: "")
        expect(user).to be_valid
      end

      it "rejects invalid URLs" do
        user = build(:user, avatar_url: "not-a-url")
        expect(user).not_to be_valid
      end
    end

    describe "email uniqueness" do
      let(:existing_user) { create(:user) }

      it "prevents duplicate emails" do
        duplicate_user = build(:user, email: existing_user.email)
        expect(duplicate_user).not_to be_valid
      end
    end
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(user: "user", admin: "admin").backed_by_column_of_type(:string) }
  end

  describe "scopes" do
    let!(:admin_user) { create(:user, :admin) }
    let!(:regular_user) { create(:user) }

    describe ".admins" do
      it "returns only admin users" do
        expect(User.admins).to include(admin_user)
        expect(User.admins).not_to include(regular_user)
      end
    end

    describe ".users" do
      it "returns only regular users" do
        expect(User.users).to include(regular_user)
        expect(User.users).not_to include(admin_user)
      end
    end
  end

  describe "instance methods" do
    let(:user) { build(:user, full_name: "John Doe") }
    let(:admin) { build(:user, :admin) }

    describe "#admin?" do
      it "returns true for admin users" do
        expect(admin.admin?).to be true
      end

      it "returns false for regular users" do
        expect(user.admin?).to be false
      end
    end

    describe "#display_name" do
      context "when full_name is present" do
        it "returns the full name" do
          expect(user.display_name).to eq("John Doe")
        end
      end

      context "when full_name is blank" do
        before { user.full_name = "" }

        it "returns the email" do
          expect(user.display_name).to eq(user.email)
        end
      end
    end

    describe "#initials" do
      context "with full name" do
        it "returns first letters of first and last name" do
          expect(user.initials).to eq("JD")
        end

        it "handles single names" do
          user.full_name = "John"
          expect(user.initials).to eq("J")
        end

        it "handles more than two names" do
          user.full_name = "John Michael Doe"
          expect(user.initials).to eq("JM")
        end
      end

      context "with blank full name" do
        before { user.full_name = "" }

        it "returns question marks" do
          expect(user.initials).to eq("??")
        end
      end
    end

    describe "#avatar" do
      context "with attached avatar image" do
        before do
          user.save!
          user.avatar_image.attach(
            io: StringIO.new("fake image data"),
            filename: "avatar.jpg",
            content_type: "image/jpeg"
          )
        end

        it "returns the attached image" do
          expect(user.avatar).to eq(user.avatar_image)
        end
      end

      context "with avatar_url but no attached image" do
        before { user.avatar_url = "https://example.com/avatar.jpg" }

        it "returns the avatar URL" do
          expect(user.avatar).to eq("https://example.com/avatar.jpg")
        end
      end

      context "with neither attached image nor URL" do
        it "returns nil" do
          expect(user.avatar).to be_nil
        end
      end
    end
  end

  describe "class methods" do
    before do
      create_list(:user, 3)
      create_list(:user, 2, :admin)
    end

    describe ".total_count" do
      it "returns the total number of users" do
        expect(User.total_count).to eq(5)
      end
    end

    describe ".admin_count" do
      it "returns the number of admin users" do
        expect(User.admin_count).to eq(2)
      end
    end

    describe ".user_count" do
      it "returns the number of regular users" do
        expect(User.user_count).to eq(3)
      end
    end
  end

  describe "devise configuration" do
    it "includes required devise modules" do
      devise_modules = User.devise_modules
      expect(devise_modules).to include(:database_authenticatable)
      expect(devise_modules).to include(:registerable)
      expect(devise_modules).to include(:recoverable)
      expect(devise_modules).to include(:rememberable)
      expect(devise_modules).to include(:validatable)
      expect(devise_modules).to include(:trackable)
    end
  end

  describe "password requirements" do
    it "requires minimum password length" do
      user = build(:user, password: "123")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "accepts valid passwords" do
      user = build(:user, password: "password123")
      expect(user).to be_valid
    end
  end
end
