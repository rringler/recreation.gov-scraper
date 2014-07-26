# task/query.rake
task :query => :environment do
  SEARCH_URL = "http://www.recreation.gov/camping/Lower_Pines/r/" \
               "campsiteCalendar.do?page=calendar&search=site" \
               "&contractCode=NRSO&parkId=70928"

  pages = scrape_pages(SEARCH_URL)
  open_dates = find_open_dates(pages)

  query = Query.create

  open_dates.each do |site, dates|
    dates.each do |date|
      query.availabilities.create(site: site, date: date)
    end
  end
end

# helpers

# returns an array of Mechanize::Page objects
def scrape_pages(url)

  pages = []

  agent = Mechanize.new do |agent|
    agent.user_agent_alias = "Windows Chrome"

    sleep_interval = 0.5

    # hackety, hack, hack.  don't sign your name to this shit.
    pages[0] = agent.get(url)
    sleep(sleep_interval)
    pages[1] = pages[0].link_with(id: 'resultNext').click
    sleep(sleep_interval)
    pages[2] = pages[1].link_with(id: 'resultNext').click
    sleep(sleep_interval)

    pages[5] = pages[0].link_with(id: 'nextWeek').click
    sleep(sleep_interval)
    pages[4] = pages[5].link_with(id: 'resultPrevious').click
    sleep(sleep_interval)
    pages[3] = pages[4].link_with(id: 'resultPrevious').click
    sleep(sleep_interval)

    pages[6] = pages[5].link_with(id: 'nextWeek').click
    sleep(sleep_interval)
    pages[7] = pages[6].link_with(id: 'resultNext').click
    sleep(sleep_interval)
    pages[8] = pages[7].link_with(id: 'resultNext').click
    sleep(sleep_interval)

    pages[11] = pages[ 6].link_with(id: 'nextWeek').click
    sleep(sleep_interval)
    pages[10] = pages[11].link_with(id: 'resultPrevious').click
    sleep(sleep_interval)
    pages[ 9] = pages[10].link_with(id: 'resultPrevious').click
    sleep(sleep_interval)

    pages[12] = pages[11].link_with(id: 'nextWeek').click
    sleep(sleep_interval)
    pages[13] = pages[12].link_with(id: 'resultNext').click
    sleep(sleep_interval)
    pages[14] = pages[13].link_with(id: 'resultNext').click
  end

  pages
end

# accepts an array of Mechanize::Page objects
# returns a hash of site openings.  key: site, value: array of dates
def find_open_dates(pages)
  open_dates = Hash.new([])

  pages.each do |page|
    page.search("a.avail").each do |link|
      site = link.parent.parent.at_css("td.sn div.siteListLabel a").text.to_sym
      date = /arvdate=([\d\/]+)/.match(link.attr('href'))[1]

      if open_dates[site].empty?
        open_dates[site] = [date]
      else
        open_dates[site] << date
      end
    end
  end

  open_dates
end
