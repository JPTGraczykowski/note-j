require 'rails_helper'

RSpec.describe User, type: :model do\
  context "validations" do
    context "when validating OAuth user attributes" do
      it "is valid with all required OAuth attributes" do
        user = build(:user, provider: "google", uid: "12345")

        expect(user).to be_valid
      end

      it "requires provider for OAuth users" do
        user = build(:user, provider: nil, uid: "12345")

        expect(user).not_to be_valid
        expect(user.errors[:provider]).to include("can't be blank")
      end

      it "requires uid for OAuth users" do
        user = build(:user, provider: "google", uid: nil)

        expect(user).not_to be_valid
        expect(user.errors[:uid]).to include("can't be blank")
      end

      it "requires email" do
        user = build(:user, email: nil)

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "requires name" do
        user = build(:user, name: nil)

        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it "requires valid email format" do
        user = build(:user, email: "invalid-email")

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end

      it "requires unique email" do
        existing_user = create(:user, email: "test@example.com")
        duplicate_user = build(:user, email: "test@example.com")

        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end

      it "requires unique uid per provider" do
        existing_user = create(:user, provider: "google", uid: "12345")
        duplicate_user = build(:user, provider: "google", uid: "12345")

        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:uid]).to include("has already been taken")
      end

      it "allows same uid for different providers" do
        google_user = create(:user, provider: "google", uid: "12345")
        github_user = build(:user, provider: "github", uid: "12345")

        expect(github_user).to be_valid
      end
    end

    context "when validating password user attributes" do
      it "is valid with password and no OAuth credentials" do
        user = build(:user, :with_password)

        expect(user).to be_valid
      end

      it "requires password for non-OAuth users" do
        user = build(:user, :with_password, password: nil)

        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it "requires password to be at least 8 characters" do
        user = build(:user, :with_password, password: "12345", password_confirmation: "12345")

        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
      end

      it "does not require provider or uid for password users" do
        user = build(:user, :with_password, provider: nil, uid: nil)

        expect(user).to be_valid
      end

      it "requires either OAuth credentials or password" do
        user = build(:user, provider: nil, uid: nil, password: nil)

        expect(user).not_to be_valid
        expect(user.errors[:base]).to include("User must have either OAuth credentials or a password")
      end
    end
  end

  context "when creating user from OAuth" do
    it "creates new user from OAuth data" do
      auth = double(
        provider: "google",
        uid: "12345",
        info: double(email: "test@example.com", name: "Test User")
      )

      user = User.from_omniauth(auth)

      expect(user).to be_persisted
      expect(user.provider).to eq("google")
      expect(user.uid).to eq("12345")
      expect(user.email).to eq("test@example.com")
      expect(user.name).to eq("Test User")
    end

    it "finds existing user from OAuth data" do
      existing_user = create(:user, provider: "google", uid: "12345")
      auth = double(
        provider: "google",
        uid: "12345",
        info: double(email: "updated@example.com", name: "Updated Name")
      )

      user = User.from_omniauth(auth)

      expect(user).to eq(existing_user)
      expect(User.count).to eq(1)
    end
  end

  context "when checking user type" do
    it "identifies OAuth users correctly" do
      oauth_user = build(:user)
      password_user = build(:user, :with_password)

      expect(oauth_user.oauth_user?).to be true
      expect(oauth_user.password_user?).to be false

      expect(password_user.oauth_user?).to be false
      expect(password_user.password_user?).to be true
    end
  end

  context "when getting display name" do
    it "returns name when present" do
      user = build(:user, name: "John Doe")

      expect(user.display_name).to eq("John Doe")
    end

    it "returns email prefix when name is empty" do
      user = build(:user, name: "", email: "johndoe@example.com")

      expect(user.display_name).to eq("johndoe")
    end

    it "returns email prefix when name is nil" do
      user = build(:user, email: "johndoe@example.com")
      user.name = nil # Set after building to test the method logic

      expect(user.display_name).to eq("johndoe")
    end
  end

  context "when authenticating password users" do
    it "authenticates with correct password" do
      user = create(:user, :with_password, password: "secret123")

      expect(user.authenticate("secret123")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      user = create(:user, :with_password, password: "secret123")

      expect(user.authenticate("wrong")).to be false
    end
  end

  context "counter cache" do
    it "increments notes_count when note is created" do
      user = create(:user)
      expect(user.notes_count).to eq(0)

      create(:note, user: user)
      user.reload
      expect(user.notes_count).to eq(1)

      create(:note, user: user)
      user.reload
      expect(user.notes_count).to eq(2)
    end

    it "decrements notes_count when note is destroyed" do
      user = create(:user)
      note1 = create(:note, user: user)
      note2 = create(:note, user: user)
      user.reload
      expect(user.notes_count).to eq(2)

      note1.destroy
      user.reload
      expect(user.notes_count).to eq(1)

      note2.destroy
      user.reload
      expect(user.notes_count).to eq(0)
    end

    it "increments todos_count when todo is created" do
      user = create(:user)
      expect(user.todos_count).to eq(0)

      create(:todo, user: user)
      user.reload
      expect(user.todos_count).to eq(1)

      create(:todo, user: user)
      user.reload
      expect(user.todos_count).to eq(2)
    end

    it "decrements todos_count when todo is destroyed" do
      user = create(:user)
      todo1 = create(:todo, user: user)
      todo2 = create(:todo, user: user)
      user.reload
      expect(user.todos_count).to eq(2)

      todo1.destroy
      user.reload
      expect(user.todos_count).to eq(1)

      todo2.destroy
      user.reload
      expect(user.todos_count).to eq(0)
    end
  end
end
