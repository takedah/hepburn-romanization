require_relative 'spec_helper'

describe '#hiragana_to_katakana' do
  include HepburnRomanization
  it 'only hiragana strings should be translated to zenkaku katakana.' do
    expect(HepburnRomanization.hiragana_to_katakana('てすと')).to eq 'テスト'
  end

  it 'only zenkaku katakana strings should be translated to zenkaku katakana.' do
    expect(HepburnRomanization.hiragana_to_katakana('テスト')).to eq 'テスト'
  end

  it 'only hankaku katakana strings should be translated to zenkaku katakana.' do
    expect(HepburnRomanization.hiragana_to_katakana('ﾃｽﾄﾀﾞｿﾞ')).to eq 'テストダゾ'
  end

  it 'hiragana and katakana strings should be translated to zenkaku katakana.' do
    expect(HepburnRomanization.hiragana_to_katakana('てすとテストﾃｽﾄﾀﾞｿﾞ')).to eq 'テストテストテストダゾ'
  end

  it 'other type strings should be nil.' do
    expect(HepburnRomanization.hiragana_to_katakana('漢字')).to eq nil
  end

  it 'strings contain other type strings should be nil.' do
    expect(HepburnRomanization.hiragana_to_katakana('てすとテスト漢字ﾃｽﾄﾀﾞｿﾞ')).to eq nil
  end

  it 'not string objects should be nil.' do
    expect(HepburnRomanization.hiragana_to_katakana(1)).to eq nil
    expect(HepburnRomanization.hiragana_to_katakana(nil)).to eq nil
  end
end

describe '#sokuon' do
  include HepburnRomanization
  it 'sokuon string before shiin should be first letter of next romaji.' do
    expect(HepburnRomanization.sokuon('ka')).to eq 'k'
  end

  it 'sokuon string before "c" should be "t".' do
    expect(HepburnRomanization.sokuon('chi')).to eq 't'
  end

  it 'other cases should be "ッ".' do
    expect(HepburnRomanization.sokuon('a')).to eq 'ッ'
    expect(HepburnRomanization.sokuon('n')).to eq 'ッ'
  end
end

describe '#fix_hatsuon_style' do
  include HepburnRomanization
  it 'hatsuon before "b" or "m" or "p" should be "m".' do
    expect(HepburnRomanization.fix_hatsuon_style('jinpa')).to eq 'jimpa'
    expect(HepburnRomanization.fix_hatsuon_style('honma')).to eq 'homma'
    expect(HepburnRomanization.fix_hatsuon_style('nanba')).to eq 'namba'
  end
end

describe '#fix_choon_style' do
  include HepburnRomanization
  it 'choon should not fill except end of "oo".' do
    expect(HepburnRomanization.fix_choon_style('uryuu')).to eq 'uryu'
    expect(HepburnRomanization.fix_choon_style('satou')).to eq 'sato'
    expect(HepburnRomanization.fix_choon_style('oono')).to eq 'ono'
    expect(HepburnRomanization.fix_choon_style('yokoo')).to eq 'yokoo'
  end
end

describe '#to_romaji' do
  include HepburnRomanization
  it 'katakana strings shound translated hepburn romanization style strings.' do
    expect(HepburnRomanization.to_romaji('ナンバグランドカゲツデダンパバッチリｶﾞﾝﾊﾞｯﾃサトウクンホンマクンヨコオ')).to eq 'nambagurandokagetsudedampabatchirigambattesatokunhommakunyokoo'
  end

  it 'hiragana strings shound translated hepburn romanization style strings.' do
    expect(HepburnRomanization.to_romaji('なんばぐらんどかげつでだんぱばっちりがんばってうりゅうくんおおの')).to eq 'nambagurandokagetsudedampabatchirigambatteuryukunono'
  end

  it 'points of invalid japanese should not be translated.' do
    expect(HepburnRomanization.to_romaji('ッアッング')).to eq 'ッaッngu'
  end

  it 'other strings should be nil.' do
    expect(HepburnRomanization.to_romaji('これは漢字デス')).to eq nil
  end
end
