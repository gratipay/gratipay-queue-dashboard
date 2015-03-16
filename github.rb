require 'octokit'

# This holds the various github related queues
class Github
  def initialize(token)
    Octokit.auto_paginate = true
    @client = Octokit::Client.new(:access_token => token)
    @org_name = 'gratipay'
  end

  def method_missing(method, *args)
    @client.send(method.to_s,*args)
  end

  def issues(opts = Hash.new)
    query = ""
    query+= "is:pr " if opts[:pr]
    query+= "label:\"#{opts[:label]}\" " if opts[:label]
    query+= "repo:\"#{opts[:repo]}\" " if opts[:repo]
    search_issues query
  end

  def issues_by_label(label, pr=false)
    issues label: label, pr:pr
  end

  def issues_by_repo(repo, pr=false)
    issues repo: "#{@org_name}/#{repo}", pr:pr
  end

  def issues_by_repo_and_label(repo, label, pr=false)
    issues repo: "#{@org_name}/#{repo}", label: label, pr: pr
  end

  def pr_ready_for_review()
    issues_by_label '4 - Review', true
  end

  def repos
    @client.organization_repositories(@org_name)
  end

  private

  # Returns the count of the search query
  def search_issues(query)
    # https://help.github.com/articles/searching-issues/#search-within-a-users-or-organizations-repositories
    issues = @client.search_issues "state:open user:gratipay #{query}", :per_page=>0
    issues.total_count
  end
end
