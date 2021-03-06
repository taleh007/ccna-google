URL1 = 'http://heiserz.com/2012/01/01/enetwork-final-exam-ccna-1-4-0-2012-100/'
URL2 = 'https://dl.dropboxusercontent.com/u/12488517/ccna.html'

doc = Nokogiri::HTML(open(URL1))
doc.css('.post-318 p').each do |p|
  p = Nokogiri::HTML(p.to_html.gsub(/<br>/, "\n"))
  text = p.css('strong').text.gsub(/\A[^a-zA-z]*/, '')
  all = p.text.gsub(/\A[^a-zA-z]*/, '')
  answers = all.split("\n").reject{|t| t == text}.reject(&:blank?).map{|a| a.gsub("\n", '')}
  right_answers = p.css('span').map{|el| el.text}.map{|a| a.gsub("\n", '')}

  puts answers

  question = Question.create(text: text)
  answers.each do |answer_text|
    correct = !!right_answers.include?(answer_text)
    Answer.create(text: answer_text, correct: correct, question_id: question.id)
  end
end

doc = Nokogiri::HTML(open(URL2))
doc.css('#post-body-513074003750928526 p').each_slice(2) do |data|
  data = data.map {|p| Nokogiri::HTML(p.to_html.gsub(/<br>/, "\n"))}

  text = data.first.text
  answers = data.last.text.split("\n").map(&:strip).map{|a| a.gsub("\n", '')}
  right_answers = data.last.css('strong').map{|x| x.text.strip}.flat_map{|x| x.split("\n")}.map{|a| a.gsub("\n", '')}

  question = Question.create(text: text)
  answers.each do |answer_text|
    correct = !!right_answers.include?(answer_text)
    Answer.create(text: answer_text, correct: correct , question_id: question.id)
  end
end
