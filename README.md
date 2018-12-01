# Setup

Make sure you have Ruby installed.

```
gem install bundler
bundle
```

# Usage

Expected input is a csv of amazon URLs

```
cd workspace/scraper
ruby scraper.rb amazon.csv
```

or if input is something you downloaded

```
ruby scraper.rb ~/Downloads/<FILENAME>
```

Output is a `output.csv` file in the scraper folder
