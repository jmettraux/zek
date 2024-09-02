
# Zek

ZettelKasten.


## Philosophy

Zek stores permanent notes. Fleeting (transient) notes are outside of Zek.

Vim is the interface.

* create note
* edit note
* delete note (archive?)
* duplicate note
* list notes
* query notes

A repository is Git-enabled, creating or editing a note results in a Git commit. Fixing problems is done via `git revert` and friends.

Backup via Tarsnap.

One "executable" zek orchestrates the repository.


### Dir structure

`ZEK_REPO_PATH` env variable... or --repo-path or -p

```
repo/
  root.md  # list of links, or is trees.yaml below better?
  09/
    47/
      n_019190ef87437aea9bd426d424fb4709_something.md
  66/
    4e/
      n_019190ef99117d68bbeae96629db4e66_some_other_thing.md
  index/
    mtimes.yaml # { path: mtime_when_indexed }
    tags.yaml
    trees.yaml
    links.yaml # ? is it really necessary
    aliases.yaml
    words.yaml # OR
    words/
      ant.txt
      myrmidon.txt
      zebra.txt # OR
    words/
      a.yaml
      b.yaml
      z.yaml
      nonlatin.yaml
```

### Note structure

File `n_019190ff68977073a7acc4052367a551_prisoner_227.md`:
```
[parent](#019190ef87437aea9bd426d424fb4709)

## prisoner 227

[self](#019190ff68977073a7acc4052367a551) :literature :author
[self](#solzhenitsyn) :literature :author

Aleksandr Solzhenitsyn, the Russian novelist and historian, was designated the
prisoner number 227 when he was imprisoned in a Soviet labor camp. "Zek" is an
abbreviation for "Zakluchenny", which means "prisoner" in Russian.

Wrote ["One Day in the Life of Ivan Denisovich"](#01919101182776a18709137411c3ec49).
```

File `n_01919101182776a18709137411c3ec49_one_day_in_the_life_of_iv.md`:
```
[parent](#019190ef87437aea9bd426d424fb4709)

## "One Day in the Life of Ivan Denisovich"

[self](#01919101182776a18709137411c3ec49) :literature :book

Ivan Denisovich Shukhov is the protagonist of the novel "One Day in the Life of
Ivan Denisovich" by Russian author Aleksandr Solzhenitsyn. The novel, published
in 1962, describes a single day of an ordinary prisoner in a Soviet labor camp
in the 1950s. Shukhov is a former POW from World War II who was sentenced to a
labor camp for being accused of spying after his capture by the Germans. The
novel explores his daily life and survival in the harsh conditions of the camp.

<!-- status: archived -->
<!-- ctime: Tue Aug 27 13:58:29 JST 2024 -->
<!-- mtime: Tue Aug 27 14:58:01 JST 2024 -->
<!-- source: Telegram -->
```

(ctime: is not necessary, it's in the UUID...)

#### Links

- vertical links (child to [parent]).
- horizontal links (slide)
- self link ([self])

TODO `[self](#01919101182776a18709137411c3ec49)`

#### Tags

Tags, like `:todo :list :whatever` are placed after the [self] link.


#### Lang

`fr-ch` or `en-us`?

```md
[self](#01919101182776a18709137411c3ec49) fr-ch :literature :book
```

The tags are in English, but the content here would be French (Swiss flavour).

Or would an attribute be better? Defaults to `en-us`.
```md
<!-- lang: en-us -->
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)

