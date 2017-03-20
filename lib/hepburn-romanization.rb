require 'nkf'

#
# ひらがなかカタカナのみで構成される文字列をヘボン式ローマ字に変換
# 
module HepburnRomanization
  # ローマ字対応表
  KANA_TO_ROMAJI = {
    'ア' => 'a', 'イ' => 'i', 'ウ' => 'u', 'エ' => 'e', 'オ' => 'o',
    'カ' => 'ka', 'キ' => 'ki', 'ク' => 'ku', 'ケ' => 'ke', 'コ' => 'ko',
    'サ' => 'sa', 'シ' => 'shi', 'ス' => 'su', 'セ' => 'se', 'ソ' => 'so',
    'タ' => 'ta', 'チ' => 'chi', 'ツ' => 'tsu', 'テ' => 'te', 'ト' => 'to', 
    'ナ' => 'na', 'ニ' => 'ni', 'ヌ' => 'nu', 'ネ' => 'ne', 'ノ' => 'no',
    'ハ' => 'ha', 'ヒ' => 'hi', 'フ' => 'fu', 'ヘ' => 'he', 'ホ' => 'ho',
    'マ' => 'ma', 'ミ' => 'mi', 'ム' => 'mu', 'メ' => 'me', 'モ' => 'mo',
    'ヤ' => 'ya', 'ユ' => 'yu', 'ヨ' => 'yo',
    'ラ' => 'ra', 'リ' => 'ri', 'ル' => 'ru', 'レ' => 're', 'ロ' => 'ro',
    'ワ' => 'wa', 'ヲ' => 'o',
    'ン' => 'n',
    'ガ' => 'ga', 'ギ' => 'gi', 'グ' => 'gu', 'ゲ' => 'ge', 'ゴ' => 'go',
    'ザ' => 'za', 'ジ' => 'ji', 'ズ' => 'zu', 'ゼ' => 'ze', 'ゾ' => 'zo',
    'ダ' => 'da', 'ヂ' => 'ji', 'ヅ' => 'zu', 'デ' => 'de', 'ド' => 'do',
    'バ' => 'ba', 'ビ' => 'bi', 'ブ' => 'bu', 'ベ' => 'be', 'ボ' => 'bo',
    'パ' => 'pa', 'ピ' => 'pi', 'プ' => 'pu', 'ペ' => 'pe', 'ポ' => 'po',
    'キャ' => 'kya', 'キュ' => 'kyu', 'キョ' => 'kyo',
    'シャ' => 'sha', 'シュ' => 'shu', 'ショ' => 'sho',
    'チャ' => 'cha', 'チュ' => 'chu', 'チョ' => 'cho',
    'ニャ' => 'nya', 'ニュ' => 'nyu', 'ニョ' => 'nyo',
    'ミャ' => 'mya', 'ミュ' => 'myu', 'ミョ' => 'myo',
    'リャ' => 'rya', 'リュ' => 'ryu', 'リョ' => 'ryo',
    'ギャ' => 'gya', 'ギュ' => 'gyu', 'ギョ' => 'gyo',
    'ジャ' => 'ja', 'ジュ' => 'ju', 'ジョ' => 'jo',
    'ビャ' => 'bya', 'ビュ' => 'byu', 'ビョ' => 'byo',
    'ピャ' => 'pya', 'ピュ' => 'pyu', 'ピョ' => 'pyo'
  }

  # ひらがなかカタカナをヘボン式ローマ字に変換
  #
  # @param [String] text ひらがなかカタカナ（半角カタカナも可）
  # @return [String] ひらがなかカタカナをヘボン式ローマ字にしたもの
  # @return [nil] 引数がひらがなかカタカナの文字列以外の場合はnil
  # @example
  #   puts(HepburnRomanization.to_romaji('うりゅうちょう')) #=> 'uryucho'
  #   puts(HepburnRomanization.to_romaji('ほんま')) #=> 'homma'
  def self.to_romaji(text)
    kana = hiragana_to_katakana(text)
    if kana
      # 文字列を一文字ずつローマ字変換処理の対象するため、一旦一文字ずつの配列に変換。
      characters = kana.split("")
      # 何文字目を処理しているかを表す数値。
      position = 0
      # 変換した文字列を順次格納する。
      translated_string = ''
    else
      return nil
    end

    while position < characters.size do
      # 対象の文字が促音の場合、次の文字によってローマ字の表記を変える。
      if characters[position] == 'ッ'
        next_character = KANA_TO_ROMAJI[characters[position + 1]]
        if next_character
          translated_string += sokuon(next_character)
        else
          # 促音の次の文字のローマ字変換結果がnilであることは想定していないので、カタカナをそのまま出力する。
          translated_string += 'ッ'
        end
        position += 1
        next
      end

      # 拗音の場合を見分けるため、まずは対象の文字とその次の一文字と結合した二文字の文字列をローマ字対応表と照合するようにする。
      # 拗音以外の場合は二文字の文字列でローマ字対応表と照合しても必ずnilとなるので、nilの場合は対象の一文字だけで照合する。
      romaji = nil
      2.downto(1) do |number|
        char = characters.slice(position, number).join
        romaji = KANA_TO_ROMAJI[char]
        if romaji
          translated_string += romaji
          position += number
          break
        end
      end 
      # ローマ字対応表とマッチしなかった場合は当該文字をそのまま出力する。
      unless romaji
        translated_string += characters[position]
        position += 1
      end
    end
    translated_string = fix_hatsuon_style(translated_string)
    translated_string = fix_choon_style(translated_string)
    return translated_string
  end

  # ひらがなかカタカナのみで構成される文字列をカタカナの文字列に変換
  #
  # @param [String] text ひらがなかカタカナ（半角カタカナも可）のみで構成される文字列
  # @return [String] ひらがなかカタカナをヘボン式ローマ字にしたもの
  # @return [nil] 引数がひらがなかカタカナのみで構成される文字列以外の場合はnil
  def self.hiragana_to_katakana(text)
    if text.class == String
      # 半角カタカナを全角カタカナにするため一旦NKFを通す
      text = NKF.nkf('-Ww', text)
    else
      return nil
    end

    if text =~ /\A(\p{Katakana}|\p{Hiragana})+\z/
      katakana = NKF.nkf('-Wwh2', text)
    else
      katakana = nil
    end
    katakana
  end

  # ヘボン式ローマ字の促音表記を返す
  #
  # @param [String] next_character 促音の次の文字をローマ字にしたもの
  # @return [String] 促音を表記するアルファベット文字
  def self.sokuon(next_character)
    if next_character.slice(0) == 'c'
      sokuon = 't'
    elsif next_character.slice(0) =~ /[aiueo]/
      # 促音の次の文字が母音であることは想定していないので、カタカナをそのまま出力する。
      sokuon = 'ッ'
    elsif next_character == 'n'
      # 促音の次の文字が撥音であることは想定していないので、カタカナをそのまま出力する。
      sokuon = 'ッ'
    else
      sokuon = next_character.slice(0)
    end
    sokuon
  end

  # ヘボン式ローマ字の撥音表記に修正して返す
  #
  # @param [String] text 撥音表記をヘボン式に修正する前のローマ字文字列
  # @return [String] 撥音表記をヘボン式に修正した後のローマ字文字列
  def self.fix_hatsuon_style(text)
    text.gsub(/nb|nm|np/) {|hatsuon| 'm' + hatsuon.slice(1) }
  end

  # ヘボン式ローマ字の長音表記に修正して返す
  #
  # @param [String] text 長音表記をヘボン式に修正する前のローマ字文字列
  # @return [String] 長音表記をヘボン式に修正した後のローマ字文字列
  def self.fix_choon_style(text)
    end_of_char = ''
    if text.slice(-2, 2) == 'oo'
      end_of_char = text.slice!(-2, 2)
    end
    text = text.gsub(/uu|ou|oo/) {|choon| choon.slice(0) }
    text += end_of_char
    return text
  end
end
