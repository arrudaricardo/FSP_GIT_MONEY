# == Schema Information
#
# Table name: repositories
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  owner_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#

class Repository < ApplicationRecord
  validates :name, :owner_id, presence: true
  validates :name, length: {minimum: 4, maximum: 15}
  validates :description, length: {maximum: 35}, allow_blank: true


  belongs_to :user,
    class_name: 'User',
    foreign_key: :owner_id,
    primary_key: :id

  has_many :issues,
    class_name: 'Issue',
    foreign_key: :repo_id,
    primary_key: :id

  # initialize a git --bare init at storage/username/reponame/
  # @params username: string, reponame: string
  # @return boolean
  #
  def self.git_init_bare(username, reponame)
      path = "storage/#{username}/#{reponame}/"
      return `git init --bare #{path}`
  end

  def self.delete_repo(username, reponame)
    path = "./storage/#{username}/#{reponame}"
      return `rm -rf #{path}` 
  end

  # return list of directories 
  def self.ls_files_tree(username, reponame)
    path = "./storage/#{username}/#{reponame}"
    `git -C #{path} ls-tree --full-tree -r --name-only HEAD`
  end

end
