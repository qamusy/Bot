require './models/user'
require './lib/message_sender'
require 'active_support/core_ext/enumerable.rb'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :last_command

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
    @last_command = @user.last_command
  end

  def respond
    update_last_command
    case message.text
    when /^\/start/
      answer_with_greeting_message
    when /^\/stop/
      answer_with_farewell_message
    when /^\/setmylang/
      answer_with_language_available
    when *I18n.t('language_set')
      if last_command == "/setmylang"
        set_language
      else
        translate_it
      end
    when /^\/photo/
      answer_with_photo
    when /^\/question/
      multiple_choice_question
    when /^(\/|)[a-dA-D]$/
      check_answer
      multiple_choice_question
    else
      translate_it
    end
  end

  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end

  end

  def create_user
    user = User.find_by(uid: message.from.id)
byebug
    unless
      User.create(uid: message.from.id, username: message.from.username, first_name: message.from.first_name, last_name: message.from.last_name)
    end
  end
  def update_last_command
    unless message.text.nil?
      user.last_command = message
      user.save
    end
  end
  def answer_with_greeting_message
    text = I18n.t('greeting_message')

    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_with_farewell_message
    text = I18n.t('farewell_message')

    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_with_language_available
    text = I18n.t('language_set_message')
    markup = I18n.t('language_set')

    MessageSender.new(bot: bot, chat: message.chat, text: text, answers: markup).send
  end

  def set_language
    user.lang = message.text
    text = "Your language set to #{message.text}"

    user.save
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_with_photo
    MessageSender.new(bot: bot, chat: message.chat, photo: "./images/welcome.jpg").send
  end

  def translate_it
    text = "translationi...."
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
  def multiple_choice_question
    question = I18n.t('multiple_choice_question')
    word = "تفاحة"
    text = <<~END
      #{question}Choose the corect answer:
      #{word}

      /A Apple
      /B Orange
      /C Banana
      /D Strewberry
    END
    choices = [%w(A B), %w(C D)]

    MessageSender.new(bot: bot, chat: message.chat, text: text, answers: choices).send
  end
  def check_answer
          correct_alphabet = "A"
          if message.text.upcase =~ /(\/|)#{correct_alphabet}/
            MessageSender.new(bot: bot, chat: message.chat, text: "CORRECT").send
            # update in db
          else
            # reply back with correction
            MessageSender.new(bot: bot, chat: message.chat, text: "Correct answer is #{correct_alphabet}").send
          end
  end
end
