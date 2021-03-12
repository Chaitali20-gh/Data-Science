from scrapy import Spider, Request
from tripadvisor.items import TripadvisorItem


class TripadvisorSpider(Spider):
    name = 'tripadvisor_spider'
    allowed_domains = ['www.tripadvisor.com']
    start_urls = ['https://www.tripadvisor.com/Hotels-g34439-Miami_Beach_Florida-Hotels.html']
    
    
    
    def parse(self, response):
        #pg_num = response.xpath('//a[@class="pageNum "]/text()').extract()
        pg_num = response.xpath('//a[@class="pageNum last "]/text()').extract()
        result_urls = [f'https://www.tripadvisor.com/Hotels-g34439-oa{i*30}-Miami_Beach_Florida-Hotels.html' for i in range (0,14)]
        
        for url in result_urls:
            yield Request(url=url, callback=self.parse_result_page)
        
        
    def parse_result_page(self,response):
          # This function parses the search result page.
          
          detail_urls = response.xpath('//div[@class="listing_title"]/a/@href').extract()
          for url in ['https://www.tripadvisor.com{}'.format(x) for x in detail_urls]:
              yield Request(url=url, callback=self.parse_detail_page)
              
     
    def parse_detail_page(self,response):
            hotel_name = response.xpath('//h1[@class="_1mTlpMC3"]/text()').extract()
            start_price = response.xpath('//div[@data-provider!=""]/@data-pernight').extract_first()
            hotel_rating = response.xpath('//span[@class="_3cjYfwwQ"]/text()').extract()
            hotel_reviews = response.xpath('//span[@class="_33O9dg0j"]/text()').extract()
            hotel_reviews = int(hotel_reviews[0].replace("reviews","").replace(",",""))
            hotel_amenities = response.xpath('//div[@class="_2rdvbNSg"]/text()').extract()
            pop_review_words = response.xpath('//button[@class="ui_button secondary small H5_EAgqY"]/text()').extract()
            nearby_restaurant = response.xpath('//span[@class="oPMurIUj TrfXbt7b"]/text()').extract() 
            walkable_rating = response.xpath('//span[@class="oPMurIUj _1iwDIdby"]/text()').extract()
            loc_attraction = response.xpath('//span[@class="oPMurIUj _1WE0iyL_"]/text()').extract()

            item = TripadvisorItem()
            item['hotel_name'] = hotel_name
            item['start_price'] = start_price
            item['hotel_rating'] = hotel_rating
            item['hotel_reviews'] = hotel_reviews
            item['hotel_amenities'] = hotel_amenities
            item['pop_review_words'] = pop_review_words
            item['nearby_restaurant'] = nearby_restaurant
            item['walkable_rating'] = walkable_rating
            item['loc_attraction'] = loc_attraction
            
            yield item
