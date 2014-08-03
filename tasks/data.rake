# task/data.rake
namespace :data do
  desc "Query the website for new data (available sites)"
  task :query => :environment do
    SEARCH_URL = "http://www.recreation.gov/campsiteCalendar.do?" \
                 "page=calendar&contractCode=NRSO&parkId=70928&findavail=next"

    pages = scrape_pages(SEARCH_URL)
    open_dates = find_open_dates(pages)

    query = Query.create

    open_dates.each do |site, urls|
      urls.each do |url|
        date     = /arvdate=([\d\/]+)/.match(url)[1]
        full_url = "http://www.recreation.gov" + url

        query.availabilities.create(site: site, date: date, url: full_url)
      end
    end
  end

  desc "Purge older data from the database"
  task :purge => :environment do
    puts Query.older.destroy!
  end

  # helpers

  # returns an array of Mechanize::Page objects
  def scrape_pages(url)

    pages = []

    agent = Mechanize.new do |agent|
      agent.user_agent_alias = "Windows Chrome"

      pages << agent.get(url)
      sleep(0.5)
      pages << pages.last.link_with(id: 'nextWeek').click
      sleep(0.5)
      pages << pages.last.link_with(id: 'nextWeek').click
      sleep(0.5)
      pages << pages.last.link_with(id: 'nextWeek').click
      sleep(0.5)
      pages << pages.last.link_with(id: 'nextWeek').click
    end

    pages
  end

  # accepts an array of Mechanize::Page objects
  # returns a hash of site openings.  key: site, value: array of urls
  def find_open_dates(pages)
    open_dates = Hash.new([])

    pages.each do |page|
      page.search("a.avail").each do |link|
        site = link.parent.parent.at_css("td.sn div.siteListLabel a").text.to_sym
        url  = link.attr('href')

        if open_dates[site].empty?
          open_dates[site] = [url]
        else
          open_dates[site] << url
        end
      end
    end

    open_dates
  end
end