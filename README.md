# 株式会社ゆめみ iOS エンジニアコードチェック課題

## アプリの概要

GitHub のリポジトリを検索できるクライアントアプリです。  
  
検索 → README を読む → 気になったものをブックマーク → リポジトリのURLをシェアという一連のリポジトリを探すワークフローを意識して作りました。

![repo_workflow](https://user-images.githubusercontent.com/52738915/113472503-9f1aa800-949e-11eb-89a5-21a7df953c8b.gif)

<br>

## 環境

- IDE：Xcode 12.4
- Swift：Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
- 開発ターゲット：iOS 13.4 のまま変更せず (2021年4月の時点では iOS 13 も広く使われてるため)

<br>

## 使用したライブラリ

* [MarkdownView](https://github.com/keitaoouchi/MarkdownView)  
リポジトリの README の Markdown を表示するために使用
* [R.swift](https://github.com/mac-cain13/R.swift)  
リソースを文字列で参照ではなく安全に型付されて扱うために使用
* [SwiftLint](https://github.com/realm/SwiftLint)  
より良く綺麗なコードを書くため linter を使用

<br>

## ビルド手順

1. Terminal で以下のコマンドを実行してください  
```
git clone https://github.com/yoshimasaki/Repo.git
cd Repo
pod install
open iOSEngineerCodeCheck.xcworkspace/
```
  
2. Xcode でビルドして実行

<br>

## コードの設計で工夫した点

### 1. Reactive programming と組み合わせた MVVM
View からのアクションにより View Model でロジックを実行し、その結果の状態変化やエラーやデータの変化を Combine の Publisher で流れるように設計しました。  

`state` と `error` の Publisher を分けることによって事前の検索結果はそのまま表示しておいてエラーが発生した場合に別に表示できる様にしています。  

ViewModel の state を enum で表現することによって無闇に値の Publisher を増やさない様にしています。Publisher が増えすぎた場合 View 側での購読処理が増えてしまいコードが煩雑になりますので。

<br>

### 2. XCTest でのテストコードの実装
View Model を View に依存させないように設計してテストしやすく設計しました。  

ネットワーク通信は `URLFetchable` protocol を定義してテストでモックオブジェクトに差し替え可能にすることによってテストしやすい設計にしました。

<br>

### 3. 責務の分離によって FatViewController の解消
View Controller の View の操作以外のデータ処理に関するロジックは MVVM の View Model に分離しました。  

UICollectionView の DiffableDataSource を使う場合は DiffableDataSource のセットアップのためにそれなりのコード量が必要になるのでそれのみを扱う DataSource object に分離しました。  

GitHub API を扱う処理は `GitHubApiClient` に分離しました。  

<br>

## UIのデザインで工夫した点

### 1. 検索一覧からの遷移アニメーション
検索一覧から detail view への遷移を連続性のあるアニメーションにしました。これによって画面間の繋がりが感じやすくリポジトリの一覧から詳細へ展開されたことを表現してます。

また detail view へ遷移した時にボトムタブバーが下に移動して隠れます。

![transition](https://user-images.githubusercontent.com/52738915/113477145-e9118700-94ba-11eb-9fa6-0f7372633a6c.gif)

<br>

### 2. リポジトリの Detail View
リポジトリの Detail view では検索一覧に戻らずとも横スワイプで次々リポジトリが見れます。リポジトリをブラウズする体験をより快適にできるようにしました。

またリポジトリを見つけたときに一番読みたいと思う README を読めるようにしました。

![detail_view](https://user-images.githubusercontent.com/52738915/113477089-9932c000-94ba-11eb-86ba-34b70c0cc9bd.gif)

<br>

### 3. リポジトリのメタデータの view
RepositoryInfoView はリポジトリの言語ごとの色を設定しました。アプリ全体は基本的に白黒を使用してますが、ここだけカラフルでデザインのアクセントになります。

ドロップシャドウの色も言語の色に合わせてます。黒のドロップシャドウだとカラフルな色に対して汚いので設定しています。

![repository_info_view](https://user-images.githubusercontent.com/52738915/113477182-20803380-94bb-11eb-94d2-ef07ab4a0cab.png)

<br>

### 4. SearchField のフォーカスがあった時に浮く
フォーカスがあってない時はシャドウが弱く浮いてないが、合うと SearchField が浮くことによってフォーカスがあってることを表現しました。

![search_field_focus](https://user-images.githubusercontent.com/52738915/113477127-dac36b00-94ba-11eb-9454-08a975dd2142.gif)

<br>

### 5. CircleButton のマイクロインタラクション
ボタンを押したときに沈み込むアニメーションでユーザーの操作に反応してることを表現しました。

またこのボタンのアニメーションは長押ししたままだと沈んだままになり、指が離れると戻るという風にユーザーの操作に対してインタラクティブです。

![circle_button](https://user-images.githubusercontent.com/52738915/113477076-89b37700-94ba-11eb-9a57-dfb3097802d1.gif)

<br>

### 6. ボトムタブバー
SearchField と同様に丸みのあるデザインを採用しました。
またコンテンツの view の上に浮いてるようなデザインにしています。

![bottom_tab_bar](https://user-images.githubusercontent.com/52738915/113477174-16f6cb80-94bb-11eb-84e2-a8aacd4b9679.png)

<br>

### 7. NotificationView
ユーザーのした操作によって完了やエラーを知らせるための通知の UI を実装しました。

通知の view は UIKit のアラートのように閉じる動作が必要なく一定時間で自動で消えます。それによってユーザーの操作を妨げません。

![notification_view](https://user-images.githubusercontent.com/52738915/113477101-ba93ac00-94ba-11eb-9774-b5c227c00b2a.gif)

<br>

## アプリとして工夫した点

### 1. アプリ名
アプリの名前を製品としても通用するように短く覚えやすく、発音しやすいものとして「Repo」としました。Repository を短くした名前になってます。

iOS のホーム画面でアプリ名が表示されますが短い方が省略されることもないので簡潔な名前を採用しました。

<br>

### 2. アプリのアイコンのデザイン
アプリの UI がモノクロを基調とした UI のためアイコンも白と黒を基調色として選択しました。

コードというアプリを設計するためのものを扱うリポジトリを見るためのアプリですので、設計という言葉からどこか硬さ、精緻なものを感じるので幾何学的なデザインのロゴタイプを採用しました。

![repo_icon](https://user-images.githubusercontent.com/52738915/113477116-cb442200-94ba-11eb-81c9-4ed3529550ca.png)

<br>

### 3. その他アプリの体裁を整えたこと
* 英語と日本語のローカライズに対応
* Assets catalog で色を定義して light mode と dark mode に対応

<br>

## 感想・改善点
ゆめみ様の採用課題のためのアプリを作成し、シンプルでクリーンなデザインの UI と遷移アニメーション、非同期処理、テストコード、責務の切り分けに主に重点を置いて作成しました。

<br>

### 1. シンプルでクリーンなデザインの UI と遷移アニメーション
全てをカスタムのデザインの UI 部品を作るのは時間というコストがかかりますがアプリを制作してほしいというお客様の持つ世界観、ブランドを表現するのには必要不可欠だと考えてますので僕はそこに注力してます。また近年の優れたデザインのアプリはほぼ全てカスタムデザインを採用してますので成熟し競争が激化しているアプリの世界で戦っていくにはデザイン面での差別化による価値の提供が必要だと考えてます。

またスマホの小さな画面で複雑な機能を実現するために画面ごとに遷移して実現しているのでそれら画面間の繋がりをオブジェクトが連続して変化していくアニメーションで表現することによってユーザーにとって画面間の繋がりを感じやすく今自分がどこにいるかわからないという迷子になりにくいと考えてます。

今回は実装してませんがユーザーの操作の入力によってインタラクティブに変化するアニメーションもユーザーの操作とアプリの繋がりを表現するのには有効であると考えてます。

<br>

### 2. 非同期処理
Combine などの Reactive programming により非同期処理は画期的に簡潔に記述できる様になりました。その応用範囲は広くアプリ内でのデータの流れを表現するのに広範囲に使えると考えてます。
この点より多くの設計の経験と学びが必要だと考えてます。

<br>

### 3. テストコード
テストコードによる自動テストはコードの品質担保、またリファクタリング時における設計が壊れてないことを保証しやすくなるためより高速な機能開発・追加ができると考えてます。

テストコードを書くのにも時間がかかりますが、機能が増えコードベースが大きくなった時に機能追加や変更での既存機能が壊れてないことを保証できるのでマニュアルでのテストより長期的な時間の節約になると考えてます。

テストしやすい設計というのがしにくい時があるのでこの点より経験と学びが必要だと考えてます。
特に Core Data や Realm などのデータを遅延ロードする ORM などのデータベース周りはデータベースの性能を最大限引き出そうとするとテストしにくい設計になると考えてます。

<br>

### 4. 責務の切り分け
アプリがユーザーを獲得し長期的な開発に入るとそれだけ追加の機能が増えていくと考えられますが、その時に機能追加のしやすさ、テストのしやすさは責務を分けて部品を小さく設計していく必要があると考えてます。

また快適な開発体験という面でも一つのクラスの行数が一万行を超えてくると1箇所変えただけでもコンパイル時間が数十秒かかるというかなりひどいものになるので小さく作ることは重要だと考えてます。

設計するときに小さく作ることを意識して今後もコードを書いていきたいです。

<br>

### 5. コードを書くことの今後の成長展望
人とコードを書いた経験が OSS へのコミットしかないのでチーム開発を経験して人からコードをレビューしてもらいより品質の高いコードを書きたいです。設計面やまた適切なコードのコメントの書き方も勉強しより読みやすいコードを書きたいです。

個人的にはメソッド名やクラス名、変数名などの名前を適切につけ、関数の責務を単一にし小さく作ればあまりコメントはいらないと思っていますがチームで開発した場合にはそうではないかもしれないのでそういうことも学びたいです。

<br>

## 制作の流れ
採用への応募の前に事前に勝手ながら課題を制作するにあたって通常の採用プロセスでは1週間が制作期間として与えられると聞きましたので、目標として5日間で制作することにしました。

幸いながら5日目の午前中には全ての機能が完成しました。

<br>

### 1日目 (2021/3/30)
まず最初に UI デザインのモックアップを作りました。
ここでどの様な機能を追加し、どのようなUIデザインにするか決めました。
UIKit のままのデザインだと自分の得意としてるカスタムのデザインの UI を見せられないので全ての UI 要素をカスタムで設計することにしました。

デザイン作業は1時間35分で終わりました。

[Figma で作成した Repo のモックアップ](https://www.figma.com/file/h7WhyiRC5spXpjT3P7EFwy/Repo-Mockup?node-id=0%3A1)

コードを書き始める前にまずはプロジェクトのセットアップを行いました。
SwiftLint と R.swift の導入をしました。

それから初級と中級の課題の修正を行いました。

<br>

### 2日目 (2021/3/31)

初日に続いて中級の課題のテストの追加をしてました。
View Model のテストの追加は午前中で終わり、これで初級と中級の課題は全て終わりました。

午後から最後の5日目まで自分のスキルを見せられるボーナス課題の機能追加と UI のブラッシュアップに取り組みました。

カスタムデザインの SearchField を設計しました。2時間くらいで終わりました。Reactive programming を使用した MVVM で設計しました。

リポジトリの検索結果の画面を collection view で設計しました。

検索一覧のリポジトリのメタデータの view がリポジトリの　detail view へと遷移するアニメーションを考えていたので cell に直接メタデータ表示用の view を配置するのではなく、メタデータを表示する再利用可能な RepositoryInfoView を設計しました。

<br>

### 3日目 (2021/4/1)

リポジトリの詳細 view の設計に取り組みました。
午前中でレイアウトとデータのバインディングの実装は終わりました。

午後からは検索一覧から詳細画面への遷移のカスタムアニメーションの実装をしました。

<br>

### 4日目 (2021/4/2)

ブックマーク機能の画面を配置するために　UITabBarController を使用してタブの UI にしました。

カスタムのボトムタブバーのデザインの TabBar を実装してました。午前中で終わりました。

午後からはブックマークの画面を実装しました。

詳細画面にリポジトリをシェアできる機能を追加しました。

エラーやブックマーク完了の通知のための NotificationView を設計しました。

<br>

### 5日目 (2021/4/3)

CircleButton というボタンを触った時にボタンが凹むようなマイクロインタラクションのボタンを設計しました。

検索履歴を表示する SearchHistoryViewController を設計しました。

アプリ名を「Repo」に変更。

アプリのアイコンを Figma でデザインして Xcode で設定。

日本語と英語にローカライズ。

午前中までに目標としていたカスタムの UI と追加の機能を全て作り終えました。

午後からはこの README を書いていました。

<br>

<details>
<summary><b>Duplicate 元の README の原文はこちら</b></summary>
<div>

## 概要

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に iOS エンジニアを希望する方に出す課題のベースプロジェクトです。本課題が与えられた方は、下記の概要を詳しく読んだ上で課題を取り組んでください。

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：基本最新の安定版（本概要作成時点では Xcode 11.4.1）
- Swift：基本最新の安定版（本概要作成時点では Swift 5.1）
- 開発ターゲット：基本最新の安定版（本概要作成時点では iOS 13.4）
- サードパーティーライブラリーの利用：オープンソースのものに限り制限しない

### 動作

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

## 課題取り組み方法

Issues を確認した上、本プロジェクトを [**Duplicate** してください](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)（Fork しないようにしてください。必要ならプライベートリポジトリーにしても大丈夫です）。今後のコミットは全てご自身のリポジトリーで行ってください。

コードチェックの課題 Issue は全て [`課題`](https://github.com/yumemi/ios-engineer-codecheck/milestone/1) Milestone がついており、難易度に応じて Label が [`初級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A初級+milestone%3A課題)、[`中級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A中級+milestone%3A課題+) と [`ボーナス`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3Aボーナス+milestone%3A課題+) に分けられています。課題の必須／選択は下記の表とします：

|   | 初級 | 中級 | ボーナス
|--:|:--:|:--:|:--:|
| 新卒／未経験者 | 必須 | 選択 | 選択 |
| 中途／経験者 | 必須 | 必須 | 選択 |

課題が完成したら、リポジトリーのアドレスを教えてください。

</div>
</details>
<br />
