Exercise 5.1
------------

### (a)

see: [ch05_batched_deque.erl](../src/ch05_batched_deque.erl)

### (b)

ポテンシャル関数:
```
FAI({f,r}) = abs(|f| - |r|)
```

償却コスト:
```
cons:
  A(Q) = T(Q) + FAI(Q') - FAI(Q)
         {let tmpQ = input of checkr/1 and T(Q) = 1 + checkr:T(tmpQ)}
       = 1 + checkr:T(tmpQ) + FAI(Q') - FAI(Q)
       if |f| < |r|
           {FAI(tmpQ) = FAI(Q) - 1 then FAI(Q) = FAI(tmpQ) + 1}
         = 1 + checkr:T(tmpQ) + FAI(Q') - FAI(tmpQ) - 1
         = checkr:T(tmpQ) + FAI(Q') - FAI(tmpQ)
         = checkr:A(tmpQ)
         = 1
       else
           {FAI(tmpQ) = FAI(Q) + 1 then FAI(Q) = FAI(tmpQ) - 1}
         = 1 + checkr:T(tmpQ) + FAI(Q') - FAI(tmpQ) + 1
         = 2 + checkr:T(tmpQ) + FAI(Q') - FAI(tmpQ)
         = 2 + checkr:A(tmpQ)
         =< 3
       end

head:
  T(Q) = 1
  A(Q) = T(Q) + FAI(Q`) - FAI(Q)
         {T(Q) = 1 and FAI(Q') = FAI(Q)}
       = 1

tail:
  A(Q) = T(Q) + FAI(Q') - FAI(Q)
         {let tmpQ = input of checkf/1 and T(Q) = 1 + checkr:T(tmpQ)}
       = 1 + checkf:T(tmpQ) + FAI(Q') - FAI(Q)
       if |f| > |r|
           {FAI(tmpQ) = FAI(Q) - 1 then FAI(Q) = FAI(tmpQ) + 1}
         = 1 + checkf:T(tmpQ) + FAI(Q') - FAI(tmpQ) - 1
         = checkf:T(tmpQ) + FAI(Q') - FAI(tmpQ)
         = checkf:A(tmpQ)
         = 1
       else
           {FAI(tmpQ) = FAI(Q) + 1 then FAI(Q) = FAI(tmpQ) - 1}
         = 1 + checkf:T(tmpQ) + FAI(Q') - FAI(tmpQ) + 1
         = 2 + checkf:T(tmpQ) + FAI(Q') - FAI(tmpQ)
         = 2 + checkf:A(tmpQ)
         =< 3
       end

snoc:
  consとほぼ同様なので省略

last:
  headと同様なので省略

init:
  tailとほぼ同様なので省略

checkr:
  A(Q) = T(Q) + FAI(Q') - FAI(Q)
       if |f| < 2 or |r| != 0
           {FAI(Q') = FAI(Q)}
         = T(Q)
         = 1
       else
           {T(Q) = |f|}
         = |f| + FAI(Q') - FAI(Q)
           {FAI(Q) = |f|}
         = |f| + FAI(Q') - |f|
         = FAI(Q')
           {FAI(Q') = (|f| rem 2 = 0 ? 0 : 1) =< 1}
         =< 1

checkf:
  checkrとほぼ同様なので省略
```

Exercise 5.2
------------

省略

Exercise 5.3
------------

ポテンシャル関数:
```
FAI(H) = |H| % the number of trees in the heap
```

償却計算量:
```
merge:
  A(H1, H2) = T(H1, H2) + FAI(H`) - FAI(H1) - FAI(H2)
            if H1 = []
                {T(H1, H2) = 1 and FAI(H1) = 0}
              = 1 + FAI(H`) - FAI(H2)
                {FAI(H`) = FAI(H2)}
              = 1
            elif H2 = []
                {H1 = [] のケースと同様}
              = 1
            elif rank(hd(H1)) < rank(hd(H2))
              = 1 + A(tl(H1), H2)
            elif rank(hd(H1)) > rank(hd(H2))
              = 1 + A(H1, tl(H2))
            else
                {let HD_H = link(hd(H1), hd(H2)), TL_H = merge(tl(H1), tl(H2))}
                {assume link:A(_, _) = 0}
              = ins_tree:A(HD_H, TL_H) + A(tl(H1), tl(H2))
                {ins_tree:A(_, _) = 2}
              = 2 + A(tl(H1), tl(H2))
            end
              {tl/1が呼ばれる度に償却コストは1増える and tl/1を呼べるのは二つのヒープの長さの合計まで}
            =< |H1| + |H2|
            =< |H`|
            =< log(size(H'))

delete_min:
  A(H) = T(H) + FAI(H`) - FAI(H)
         {expand and let {H1, H2} = remove_min_tree(H)}
       = remove_min_tree:A(H) + merge:A(H1, H2) + |H1|
         {remove_min_tree:A(H) = 2|H| - 2}
       = 2|H| - 2 + merge:A(H1, H2) + |H1|
         {merge:A(H1, H2) =< |H1| + |H2|}
       =< 2|H| - 2 + |H1| + |H2| + |H1|
       =< 2|H| - 2 + 2|H1| + |H2|
         {|H1| =< |H| - 1 and |H2| = |H| - 1}
       =< 2|H| - 2 + 2|H| - 2 + |H| - 1
       =< 5|H| - 5
       =< 5 * log(size(H)) - 5
       = O(log(size(H)))

remove_min_tree: % 便宜上、この関数は {[tree()], [tree()]} を返すものとする
  A(H) = T(H) + FAI(H1`) + FAI(H2`) - FAI(H)
         {T(H) = |H| and FAI(H) = |H|}
       = |H| + FAI(H1`) + FAI(H2`) - |H|
       = FAI(H1`) + FAI(H2`)
         {FAI(H2`) = |H| - 1}
       = FAI(H1`) + |H| - 1
         {FAI(H1`) =< |H| - 1}
       =< |H| - 1 + |H| - 1
       =< 2|H| - 2
         {|H| =< log(size(H))}
       =< 2log(size(H)) - 2

ins_tree:
  A(T, H) = 2
```

Exercise 5.4
------------

省略

Exercise 5.5
------------

TODO

Exercise 5.6
------------

`delete_min/1`は以下のように実装可能:

```erlang
delete_min(T) ->
    Pivot = ..., % 最小値よりは大きくて、その次よりは小さな値だと仮定する
    {{tree, empty, Min, empty}, DeleteMinT} = partition(Pivot, T),
    DeleteMinT.
```

つまり`delete_min/1`の償却コストは`partition/2`のそれと等しく、結果として`delA(t) < 1 + 2log(#t)`となる


Exercise 5.7
------------

[構築時] リーフを除き、全てのノードが左の子だけを持つ木ができる。O(N)
[探索時] 左の子を辿ってリーフに到達し、そこから親に戻るだけ。O(N)


Exercise 5.8
------------

http://www.slideshare.net/yuganda/pairing-heap が詳しいのでそちらを参照


Exercise 5.9
------------

基本的には、最悪計算量が一番高くなる処理を(同じ入力に対して)無限回繰り返せば良い。

スプレー木なら「昇順にソート済みの入力を挿入」して、その後に「最小値の検索」を繰り返す。
(検索コストは`O(N)`)
