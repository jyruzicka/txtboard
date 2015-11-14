# txtboard

Txtboard is the tiny, command-line kanban board that with an OmniFocus backend.

## Installing

To run this, you will need:

* A working copy of ruby
* Apple XCode (to install Nokogiri)
* A somewhat-recent version of ruby (>= 1.9.2 should be fine)
* A copy of OmniFocus

To install, just download, build and run:

```
git clone https://github.com/jyruzicka/txtboard.git
cd txtboard
gem build txtboard.gemspec
gem install txtboard-0.2.0.gem
```

## Running

To set up txtboard for the first time:

```
txtboard --setup
```

This will set up a config folder, which you can then edit to your heart's content. By default, your config folder is stored in ~/.txtboard -- if you want to host it somewhere else, you can do this with the `--config` flag.

Once txtboard is set up, you can run it with:

```
txtboard
```

## Editing columns

Columns are stored in `~/.txtboard/columns`. Each column has a number of different properties that you can set:

* **Order** determines the order of the columns in the kanban board.
* **Display** may be set to `full` (in which case the project card will display the number of tasks remaining), or `compact` (in which case only the name and flagged status will be shown).
* **Conditions** is a block that returns `true` or `false`. Every project is run through this block to determine if it should show up in a given column.
* **Sort** is a block that returns an integer. Every project is run through this block to determine sort order. The lower the number, the closer to the top of the column it will appear.
* **Colour** is a block that returns either an integer or a symbol, and determines the colour of the project block. Valid return codes are either an integer between 30 and 37 inclusive (ANSI colour code), or one of the symbols: `:black, :red, :dark, :brown, :purple, :pink, :blue, :yellow`.

For more information on the properties of projects, see the documentation for [rubyfocus](https://github.com/jyruzicka/rubyfocus).

## Further configuration

For more information on configuration options, run:

```
txtboard --help
```

## Omni Sync Server

You can grab your data from Omni Sync Server by setting up txtboard and then editing the configuration `yaml` file stored in your configuration folder. Note that if you've previously been using a local database (by default you're using a local database) and you want to switch, you'll have to reset the database after re-configuring txtboard; do this by running:

```
txtboard --reset
```

Omni Sync Server is still not fully supported, so please be aware of the following:

* Your first sync may take some time. I recommend syncing all registered devices with Omni Sync Server before running.
* Since txtboard doesn't register with Omni Sync Server like a good citizen, the server may decide to reconcile all its updates, leaving poor old txtboard stranded at an unreachable patch number. You can avoid this by regularly running/updating txtboard. In future updates, txtboard will let you know when it's come out of sync with the OSS: for now, if you find that your board has stopped updating, try resetting and re-downloading.

# Version history

## 0.2.0 // 2015-11-14

* First public release!