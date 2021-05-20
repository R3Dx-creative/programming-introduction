require 'fileutils'
require 'date'

# 基準
BORDER = 5

# ランキング
RANKING = 3

# 集計結果
result = {
  "0.txt" => 0,
  "1.txt" => 5,
  "2.txt" => 5,
  "3.txt" => 6,
  "4.txt" => 7,
  "5.txt" => 5,
  "6.txt" => 1
}

def ranked_dir(date)
  # 任意の日付(Date型)のファイル名(Ranked.yyyy-MM-dd)を作成
  date_str = date.strftime("%Y-%m-%d")
  "Ranked.#{date}"
end

class Clip
  attr_reader :file, :like

  def initialize(file, like)
    @file = file
    @like = like
  end

  def move(dest)
    FileUtils.move(@file, dest)
  end

  def self.clips(src, result)
    Dir.each_child(src).map { |file| Clip.new("#{src}/#{file}", result[file]) }
  end
end

def classify_clips(src, result)
  sorted_clips = Clip.clips(src, result).sort_by { |clip| [-clip.like, clip.file] }

  # 今日のランキングフォルダ
  today_dir = ranked_dir(Date.today)
  unless Dir.exist?(today_dir)
    FileUtils.mkdir(today_dir)
  end

  sorted_clips.each_with_index do |clip, i|
    if i < RANKING
      clip.move(today_dir)
    elsif clip.like >= BORDER
      clip.move("2.Revenging")
    else
      clip.move("3.Unranked")
    end
  end
end

classify_clips("1.Queue", result)
