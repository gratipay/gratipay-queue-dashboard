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
    return issues label: label, pr:pr if pr
    org_issues labels: label
  end

  def issues_by_repo(repo, pr=false)
    return issues repo: "#{@org_name}/#{repo}", pr:pr if pr
    repo_issues repo
  end

  def issues_by_repo_and_label(repo, label, pr=false)
    return issues repo: "#{@org_name}/#{repo}", label: label, pr: pr if pr
    repo_issues repo, labels: label
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
    issues = @client.search_issues "state:open user:#{@org_name} #{query}", :per_page=>0
    issues.total_count
  end

  def org_issues(opt = Hash.new)
    opt[:state] = 'open'
    opt[:filter]= 'all'
    issues = @client.org_issues @org_name, opt
    issues.size
  end

  def repo_issues(repo, opt = Hash.new)
    opt[:state] = 'open'
    opt[:filter]= 'all'
    repo = "#{@org_name}/#{repo}"
    issues = @client.list_issues repo, opt
    issues.size
  end
end
