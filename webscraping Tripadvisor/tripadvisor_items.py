import scrapy


class TripadvisorItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    hotel_name = scrapy.Field()
    start_price = scrapy.Field()
    hotel_rating = scrapy.Field()
    hotel_reviews = scrapy.Field()
    hotel_amenities = scrapy.Field()
    pop_review_words = scrapy.Field()
    nearby_restaurant = scrapy.Field()
    walkable_rating = scrapy.Field()
    loc_attraction = scrapy.Field()
