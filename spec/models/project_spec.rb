require 'rails_helper'

RSpec.describe Project, type: :model do

	before do

		@user = User.create(
  		first_name:  "Joe",
  		last_name:   "Tester",
  		email:       "tester@example.com",
  		password:    "dottle-nouveau-pavilion-tights-furze",
  	)

	end

	# プロジェクト名があれば有効な状態であること
	it "is valid with a project name" do

		project = @user.projects.build(
			name: "Test Project",
		)

		expect(project).to be_valid

	end

	# プロジェクト名がなければ無効な状態であること
	it "is invalid with a project name" do

		project = @user.projects.new(name: nil)

		project.valid?

		expect(project.errors[:name]).to include("can't be blank")

	end


  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do

  	@user.projects.create(
  		name: "Test Project",
  	)

  	new_project = @user.projects.build(
  		name: "Test Project",
  	)

  	new_project.valid?

  	expect(new_project.errors[:name]).to include("has already been taken")

  end


  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do

  	@user.projects.create(
  		name: "Test Project",
  	)

  	other_user = User.create(
  		first_name:  "Jane",
  		last_name:   "Tester",
  		email:       "janetester@example.com",
  		password:    "dottle-nouveau-pavilion-tights-furze",
  	)

  	other_project = other_user.projects.build(
  		name: "Test Project",
  	)

  	expect(other_project).to be_valid

  end

end