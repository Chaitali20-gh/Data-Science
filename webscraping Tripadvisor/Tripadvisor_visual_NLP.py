#import required library
import pandas as pd
import numpy as np
from wordcloud import WordCloud

#Read the webscraped csv file
hotel_orig_data = pd.read_csv('tripadvisor_miami_hotels.csv')
hotel_orig_data

%matplotlib inline
from matplotlib import pyplot as plt
plt.style.use('ggplot')
import seaborn as sns

import numpy as np
np.sum(hotel_orig_data.isnull())
hotel_data = hotel_orig_data.copy()
hotel_data = hotel_data.dropna(subset=['start_price'])

hotel_data.describe
hotel_data['pop_review_words'] = hotel_data['pop_review_words'].fillna("Others")
hotel_data['hotel_amenities'] = hotel_data['hotel_amenities'].fillna("Others")

#Hotel Start_Price Plot
plt.hist(hotel_data['start_price'])

# Data Manipulation
hotel_data.loc[hotel_data['hotel_name'].str.contains('South'),'Hotel_loc'] = 'South Beach'
hotel_data.loc[~hotel_data['hotel_name'].str.contains('South'),'Hotel_loc'] = 'Miami Beach'
hotel_data.loc[hotel_data['hotel_amenities'].str.contains(',Beach,'), 'Beach_front'] = "Y"
hotel_data.loc[~hotel_data['hotel_amenities'].str.contains(',Beach,'), 'Beach_front'] = "N"

hotel_data.loc[hotel_data['hotel_name'].str.contains('Marriott'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Hilton'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Best Western'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Hyatt'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Hampton Inn'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Holiday Inn'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Westgate'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Ritz'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Crowne Plaza'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Kimpton'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Lexington'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Pestana'),'Hotel_Grp'] = 'Chain Hotel'
hotel_data.loc[hotel_data['hotel_name'].str.contains('Four Points'),'Hotel_Grp'] = 'Chain Hotel'

hotel_data.loc[hotel_data['pop_review_words'].str.contains('boutique'),'Hotel_Grp'] = 'Boutique Hotel'
hotel_data['Hotel_Grp'] = hotel_data['Hotel_Grp'].fillna("Local Hotel")

#hotel_grp vs Starting_price
plt.figure(figsize=(12,6))
sns.boxplot(x='Hotel_Grp', y='start_price', data=hotel_data)

# Bar chart for hotel_grp count vs hotel rating
plt.figure(figsize=(12,6))
hotel_data.groupby('Hotel_Grp')['hotel_rating'].median().sort_values(ascending=False).plot.bar(color='b')

# Bar chart for hotel_grp count vs hotel reviews
plt.figure(figsize=(12,6))
hotel_data.groupby('Hotel_Grp')['hotel_reviews'].median().sort_values(ascending=False).plot.bar(color='b')

# Bar chart for hotel_grp count vs hotel location
plt.figure(figsize=(12,6))
hotel_data.groupby('Hotel_loc')['start_price'].median().sort_values(ascending=False).plot.bar(color='b')

# NLP for boutique hotels
from textblob import TextBlob
hotel_boutique = hotel_data.loc[(hotel_data.Hotel_Grp == "Boutique Hotel") & (hotel_data.hotel_reviews > 100)]
sample_size = 20

def sentiment_func(x):
    sentiment = TextBlob(x['pop_review_words'])
    x['polarity'] = sentiment.polarity
    x['subjectivity'] = sentiment.subjectivity
    return x

sample = hotel_boutique.sample(sample_size).apply(sentiment_func, axis=1)
sample.plot.scatter('hotel_reviews', 'polarity')

# NLP for local hotels
from textblob import TextBlob
hotel_others = hotel_data.loc[(hotel_data.Hotel_Grp == "Local Hotel") & (hotel_data.hotel_reviews > 100)]
sample_size = 100

def sentiment_func(x):
    sentiment = TextBlob(x['pop_review_words'])
    x['polarity'] = sentiment.polarity
    x['subjectivity'] = sentiment.subjectivity
    return x

sample = hotel_others.sample(sample_size).apply(sentiment_func, axis=1)

sample.plot.scatter('hotel_reviews', 'polarity')

# NLP for Chain hotels
from textblob import TextBlob
hotel_chains = hotel_data.loc[(hotel_data.Hotel_Grp == "Chain Hotel") & (hotel_data.hotel_reviews > 100)]
hotel_chains

sample_size = 15

def sentiment_func(x):
    sentiment = TextBlob(x['pop_review_words'])
    x['polarity'] = sentiment.polarity
    x['subjectivity'] = sentiment.subjectivity
    return x

sample = hotel_chains.sample(sample_size).apply(sentiment_func, axis=1)
sample.plot.scatter('hotel_reviews', 'polarity')

#wordcloud generation for Hotel_Grp
from wordcloud import WordCloud

#generate word cloud for 'Local' hotel group
wc = WordCloud(background_color="white", max_words=2000, width=800, height=400)
# generate word cloud
wc.generate(' '.join(hotel_others['pop_review_words']))
plt.figure(figsize=(12, 6))
plt.imshow(wc, interpolation='bilinear')
plt.axis("off")
plt.show()

#generate word cloud for 'Chains' hotel group
wc = WordCloud(background_color="white", max_words=2000, width=800, height=400)
# generate word cloud
wc.generate(' '.join(hotel_chains['pop_review_words']))
plt.figure(figsize=(12, 6))
plt.imshow(wc, interpolation='bilinear')
plt.axis("off")
plt.show()

#generate word cloud for 'boutique' hotel group
wc = WordCloud(background_color="white", max_words=2000, width=800, height=400)
# generate word cloud
wc.generate(' '.join(hotel_boutique['pop_review_words']))
plt.figure(figsize=(12, 6))
plt.imshow(wc, interpolation='bilinear')
plt.axis("off")
plt.show()


PriceGrid = sns.FacetGrid(hotel_data, col='Hotel_Grp', hue="Hotel_Grp", palette="Set1", height=4)
PriceGrid.map(sns.distplot, "start_price")
hotelGrid = sns.FacetGrid(hotel_data, row='Hotel_Grp', col='Hotel_loc', hue='Beach_front', palette="Set1", height=5)
hotelGrid.map(sns.regplot,'start_price','hotel_rating')
hotelGrid.add_legend()


from wordcloud import WordCloud
