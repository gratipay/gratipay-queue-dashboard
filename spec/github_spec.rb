require './github'
gh = Github.new ENV['GITHUB_TOKEN']

describe 'Github service' do
  it 'should return a valid token' do
    expect(gh.user.login).not_to be_nil
  end

  it 'should return open issues count' do
    expect(gh.issues).to be >0
  end

  it 'should return search count by label' do
    expect(gh.issues_by_label('security')).to be >0
  end

  it 'should return 0 for unknown label' do
    expect(gh.issues_by_label('invalidlabel')).to be 0
  end

  it 'should return reviewable PRs' do
    expect(gh.pr_ready_for_review).to be >0
  end

  it 'should return issues in repo' do
    expect(gh.issues_by_repo('gratipay.com')).to be >0
  end

  it 'should search issues_by_repo_and_label' do
    expect(gh.issues_by_repo_and_label('gratipay.com', '4 - Review')).to be >0
  end

  it 'should return repo list' do
    expect(gh.repos).not_to be_nil
  end
end
