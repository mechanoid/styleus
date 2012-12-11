module SampleBoxHelper
  def sample_box(options = {})
    content_tag('div', '', class: 'styleus_sample box', data: options)
  end
end