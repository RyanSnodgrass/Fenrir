require 'rails_helper'

describe 'PermissionGroup Class' do
  let(:pg) { create(:permission_group) }
  it 'is valid' do
    expect(pg).to be_valid
  end
  it 'has an association with terms' do
    term = create(:term)
    pg.terms << term
    expect(pg.terms).to eq([term])
  end
end



#   it 'starts with no comments' do
#     expect(post.comments).to be_empty
#   end

#   it 'can create an association with comments' do
#     comment = create(:comment)
#     post.comments << comment
#     post.save
#     expect(post.comments).to eq([comment])
#   end

#   #        post
#   #       /     \
#   # my_comment   this_comment
#   #    |               |
#   #  my_person        this_person
#   #     |                |     \
#   #   my_post      this_post   that_post
#   it 'can list all posts of people who have commented on this post' do
#     my_comment = create(:comment)
#     my_person = create(:person)
#     my_post = create(:post)
#     my_person.posts << my_post
#     my_comment.author = my_person
#     this_comment = create(:comment)
#     this_person = create(:person)
#     this_comment.author = this_person
#     this_post = create(:post)
#     that_post = create(:post)
#     this_person.posts << [this_post, that_post]
#     post.comments << [my_comment, this_comment]
#     expect(post.comments.author.posts).to include(this_post && that_post && my_post)
#   end
# end