# HepburnRomanization

大量の人名の読み仮名データ（半角カタカナ）を一括でヘボン式ローマ字に変換したくて作ったモジュールです。ひらがな、全角カタカナ、半角カタカナだけで構成された文字列であればヘボン式ローマ字に変換して返すことができます。

既にRubyでローマ字変換のライブラリを公開している方がいたので、作成にあたり参考にさせていただきました。

[Romaji](https://github.com/makimoto/romaji)

また、ヘボン式ローマ字の表記方法は [兵庫県旅券事務所 - パスポートのローマ字つづり（ヘボン式ローマ字表記）](http://www.hyogo-passport.jp/main/hebon.html) を参考にしました。

## Usage

hepburn-romanization.rb を適当なディレクトリに置いて require してください。

```
puts(HepburnRomanization.to_romaji('うりゅうちょう')) #=> 'uryucho'
puts(HepburnRomanization.to_romaji('コウノタロウ')) #=> 'konotaro'
```

## Lisence

Copyright (c) 2017 Hiroki Takeda
[MIT](http://opensource.org/licenses/mit-license.php)
