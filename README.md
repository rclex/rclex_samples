
# RclExについて
RclExの概要は[こちら](https://github.com/tlk-emb/rclex)をご参照ください．
このページでは動かし方について手順を説明しています．
 

# 環境
 
用いた環境及びツールは以下のとおりです．

| ツール |
| ---- |
|  Ubuntu 18.04  |
|  ROS 2 dashing |
|  Elixir 1.10.1 |
| Erlang/OTP 22  |
| erts-10.6.4    | 

 
# インストール

## RclExのインストール
mixプロジェクトを作成します.ここでは例としてホームディレクトリ以下に作ります．
```
$ cd ~
$ mix new rclex_ws
$ cd ~/rclex_ws
```
mix.exsのdepsにrclexを追加します．
```
def deps do
  [
    {:rclex, "~> 0.1.0"}
  ]
end
```
依存関係を解消します.
```
$ mix deps.get
```

## ROS 2のインストール
現在，RclExはUbuntu，ROS 2 dashingで動作させています．
ROS 2のdashingをバイナリでインストールする公式ページは[こちら](https://index.ros.org/doc/ros2/Installation/Dashing/Linux-Install-Debians/)です．
optionalのところはスキップして良いと思います．
デモが動けば成功です．

インストールができましたら，環境変数を読み込むコマンドを~/.bashrcに書き加えておきます．
```
$ echo "source /opt/ros/dashing/setup.bash" >> .bashrc
```

ROS 2がインストールできたら，RclExにて，NIFコードとROS 2のライブラリから，ElixirからRCLが呼び出せるよう共有ライブラリを作成します．
rclex.so作成後，rclex_wsにコピペしてください．
```
$ cd ~rclex_ws/deps/rclex/c_src
$ make
$ cp rclex.so ~/rclex_ws 
```


# テスト
 
~/rclex_ws/lib/にelixirでROS 2アプリケーションを作成します．サンプルコードはこのレポジトリを参照してください．
アプリケーション作成後，ワークスペースに移り，アプリケーションを読み込んでiexセッションを立ち上げます．
```
$ cd ~/rclex_ws
$ iex -S mix
```

以下はiexセッションです．
PubSampleモジュールのpubmain関数を起動します．引数に作りたいパブリッシャの数を入れます．
これでメッセージが出版されます．
出版中に0を入力すると，パブリッシャおよびノードが正常に終了できるようになっています．
```
iex> PubSample.pubmain(1)

publish ok
publish message:hello,world
...

0
publishers finish
node finish
enter rcl_shutdown
```
起動中，ros2のコマンドでノードが作られていることやトピックの情報が確認できます．
```
$ ros2 node list
$ ros2 topic list
```
ただ node info ではなぜかノードの情報が正しく表示されない場合があります．


# 作者

tlk-emb（京都大学情報学研究科高木研究室　今西 洋偉, 高瀬 英希）
mail to: emb@lab3.kuis.kyoto-u.ac.jp

# ライセンス
[Apache 2.0](https://www.apache.org)</blockquote>
