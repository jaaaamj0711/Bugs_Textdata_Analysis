library(httr)
library(rvest)
library(dplyr)
library(zoo)
library(stringr)
library(reshape2)
library(stringr)
library(tm)
library(wordcloud)
library(tidyverse)
library(tidytext)
library(KoNLP)
library(wordcloud2)
library(RColorBrewer)
library(dplyr)


bal_url<-"https://music.bugs.co.kr/genre/kpop/ballad/ballad?tabtype=2"
hip_url<-"https://music.bugs.co.kr/genre/kpop/rnh/hnp?tabtype=2"

bal_ly_url<-GET(bal_url) %>% read_html() %>% html_nodes("a.trackInfo") %>% html_attr("href")
hip_ly_url<-GET(hip_url) %>% read_html() %>% html_nodes("a.trackInfo") %>% html_attr("href")


ballad<-data.frame()
hiphop<-data.frame()


for(url in bal_ly_url){
  
  name<-GET(url) %>% read_html() %>% html_nodes("#container > header > div > h1") %>%
    html_text() %>% str_remove_all("\r\n\t") %>% str_remove_all("\t")
  
  song<-GET(url) %>% read_html() %>%html_nodes("table.info tbody tr time") %>% html_text()
  
  ly<-GET(url) %>% read_html() %>%html_nodes("div.lyricsContainer xmp") %>% html_text() %>%
    str_replace_all("\r\n","") %>% str_length(.) %>% paste0("o")
  
  ballad<-rbind(ballad,as.data.frame(t(c(name,song,ly))))  
}

for(url in hip_ly_url){
  
  name<-GET(url) %>% read_html() %>% html_nodes("#container > header > div > h1") %>%
    html_text() %>% str_remove_all("\r\n\t") %>% str_remove_all("\t")
  
  song<-GET(url) %>% read_html() %>%html_nodes("table.info tbody tr time") %>% html_text()
  
  ly<-GET(url) %>% read_html() %>%html_nodes("div.lyricsContainer xmp") %>% html_text() %>%
    str_replace_all("\r\n","") %>% str_length(.) %>% paste0("o")
  
  hiphop<-rbind(hiphop,as.data.frame(t(c(name,song,ly))))  
}

names(ballad)<-c("name","song_len","ly_len")
names(hiphop)<-c("name","song_len","ly_len")

ballad<-ballad %>% .[str_length(.$ly_len)>1,]
hiphop<-hiphop %>% .[str_length(.$ly_len)>1,]

ballad$ly_len<-str_remove(ballad$ly_len,"o") %>% as.numeric()
hiphop$ly_len<-str_remove(hiphop$ly_len,"o") %>% as.numeric()

bal_pos<-as.POSIXlt.factor(ballad$song_len,format="%M:%S")
ballad$song_len<-bal_pos$min*60+bal_pos$sec

hip_pos<-as.POSIXlt.factor(hiphop$song_len,format="%M:%S")
hiphop$song_len<-hip_pos$min*60+hip_pos$sec

#url불러오기
res<-GET("https://music.bugs.co.kr/years")
url<-res%>%read_html(encoding="UTF-8")%>%html_nodes(css="a.title.hyrend") %>% html_attr("href")
text<-res%>%read_html(encoding="UTF-8")%>%html_nodes(css="a.title.hyrend") %>% html_text()
song<-data.frame(text,url) %>% .[str_detect(.$text,"s"),]

#2000년대 가사 url
song_00<- GET(as.character(song$url[1]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#1990년 가사 url
song_90<-GET(as.character(song$url[2]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#1980년 가사
song_80<-GET(as.character(song$url[3]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#1970년가사 url
song_70<-GET(as.character(song$url[4]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#1960년 가사 url
song_60<-GET(as.character(song$url[5]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#1950년 가사 url
song_50<-GET(as.character(song$url[6]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#1940년 이전 가사 url

song_40<-GET(as.character(song$url[7]))%>%
  read_html(encoding="UTF=8")%>%
  html_nodes(css="a.trackInfo")%>%
  html_attr("href")

#2000년대 가사
song00_lyrics<-c()
for(i in 1:length(song_00)){
  res<-GET(url=(song_00[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song00_lyrics<-c(song00_lyrics,a)
}

#1990년대 가사
song90_lyrics<-c()
for(i in 1:length(song_90)){
  res<-GET(url=(song_90[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song90_lyrics<-c(song90_lyrics,a)
}

#1980년대 가사
song80_lyrics<-c()
for(i in 1:length(song_80)){
  res<-GET(url=(song_80[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song80_lyrics<-c(song80_lyrics,a)
}

#1970년대 가사
song70_lyrics<-c()
for(i in 1:length(song_70)){
  res<-GET(url=(song_70[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song70_lyrics<-c(song70_lyrics,a)
}

#1960년대 가사
song60_lyrics<-c()
for(i in 1:length(song_60)){
  res<-GET(url=(song_60[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song60_lyrics<-c(song60_lyrics,a)
}

#1950년대 가사
song50_lyrics<-c()
for(i in 1:length(song_50)){
  res<-GET(url=(song_50[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song50_lyrics<-c(song50_lyrics,a)
}

#1940이전 가사
song40_lyrics<-c()
for(i in 1:length(song_40)){
  res<-GET(url=(song_40[i]))
  a<-res%>%
    read_html(encoding="UTF-8")%>%
    html_nodes(css="div.lyricsContainer xmp")%>%
    html_text()%>%
    gsub(pattern="\r\n",replacement= " ")
  song40_lyrics<-c(song40_lyrics,a)
}
#corpus로 변환
corpus_00<-Corpus(VectorSource(song00_lyrics))
corpus_90<-Corpus(VectorSource(song90_lyrics))
corpus_80<-Corpus(VectorSource(song80_lyrics))
corpus_70<-Corpus(VectorSource(song70_lyrics))
corpus_60<-Corpus(VectorSource(song60_lyrics))
corpus_50<-Corpus(VectorSource(song50_lyrics))
corpus_40<-Corpus(VectorSource(song40_lyrics))

#구두점 제거
mycorpus_00<-tm_map(corpus_00,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_00, removePunctuation):
## transformation drops documents
mycorpus_90<-tm_map(corpus_90,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_90, removePunctuation):
## transformation drops documents
mycorpus_80<-tm_map(corpus_80,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_80, removePunctuation):
## transformation drops documents
mycorpus_70<-tm_map(corpus_70,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_70, removePunctuation):
## transformation drops documents
mycorpus_60<-tm_map(corpus_60,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_60, removePunctuation):
## transformation drops documents
mycorpus_50<-tm_map(corpus_50,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_50, removePunctuation):
## transformation drops documents
mycorpus_40<-tm_map(corpus_40,removePunctuation)
## Warning in tm_map.SimpleCorpus(corpus_40, removePunctuation):
## transformation drops documents
#숫자 제거
mycorpus_00<-tm_map(mycorpus_00,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_00, removeNumbers): transformation
## drops documents
mycorpus_90<-tm_map(mycorpus_90,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_90, removeNumbers): transformation
## drops documents
mycorpus_80<-tm_map(mycorpus_80,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_80, removeNumbers): transformation
## drops documents
mycorpus_70<-tm_map(mycorpus_70,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_70, removeNumbers): transformation
## drops documents
mycorpus_60<-tm_map(mycorpus_60,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_60, removeNumbers): transformation
## drops documents
mycorpus_50<-tm_map(mycorpus_50,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_50, removeNumbers): transformation
## drops documents
mycorpus_40<-tm_map(mycorpus_40,removeNumbers)
## Warning in tm_map.SimpleCorpus(mycorpus_40, removeNumbers): transformation
## drops documents
#영어소문자 변형
mycorpus_00<-tm_map(mycorpus_00,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_00, tolower): transformation drops
## documents
mycorpus_90<-tm_map(mycorpus_90,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_90, tolower): transformation drops
## documents
mycorpus_80<-tm_map(mycorpus_80,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_80, tolower): transformation drops
## documents
mycorpus_70<-tm_map(mycorpus_70,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_70, tolower): transformation drops
## documents
mycorpus_60<-tm_map(mycorpus_60,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_60, tolower): transformation drops
## documents
mycorpus_50<-tm_map(mycorpus_50,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_50, tolower): transformation drops
## documents
mycorpus_40<-tm_map(mycorpus_40,tolower)
## Warning in tm_map.SimpleCorpus(mycorpus_40, tolower): transformation drops
## documents
#불용어 제거
mycorpus_00<-tm_map(mycorpus_00,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_00, removeWords,
## stopwords("english")): transformation drops documents
mycorpus_90<-tm_map(mycorpus_90,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_90, removeWords,
## stopwords("english")): transformation drops documents
mycorpus_80<-tm_map(mycorpus_80,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_80, removeWords,
## stopwords("english")): transformation drops documents
mycorpus_70<-tm_map(mycorpus_70,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_70, removeWords,
## stopwords("english")): transformation drops documents
mycorpus_60<-tm_map(mycorpus_60,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_60, removeWords,
## stopwords("english")): transformation drops documents
mycorpus_50<-tm_map(mycorpus_50,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_50, removeWords,
## stopwords("english")): transformation drops documents
mycorpus_40<-tm_map(mycorpus_40,removeWords,stopwords("english"))
## Warning in tm_map.SimpleCorpus(mycorpus_40, removeWords,
## stopwords("english")): transformation drops documents
#명사추출
mycorpus_00_noun<-extractNoun(mycorpus_00)
mycorpus_90_noun<-extractNoun(mycorpus_90)
mycorpus_80_noun<-extractNoun(mycorpus_80)
mycorpus_70_noun<-extractNoun(mycorpus_70)
mycorpus_60_noun<-extractNoun(mycorpus_60)
mycorpus_50_noun<-extractNoun(mycorpus_50)
mycorpus_40_noun<-extractNoun(mycorpus_40)

#unlist
mycorpus_00_wd<-unlist(mycorpus_00_noun)
mycorpus_90_wd<-unlist(mycorpus_90_noun)
mycorpus_80_wd<-unlist(mycorpus_80_noun)
mycorpus_70_wd<-unlist(mycorpus_70_noun)
mycorpus_60_wd<-unlist(mycorpus_60_noun)
mycorpus_50_wd<-unlist(mycorpus_50_noun)
mycorpus_40_wd<-unlist(mycorpus_40_noun)

#table
mycorpus_00_wd<-table(mycorpus_00_wd)
mycorpus_90_wd<-table(mycorpus_90_wd)
mycorpus_80_wd<-table(mycorpus_80_wd)
mycorpus_70_wd<-table(mycorpus_70_wd)
mycorpus_60_wd<-table(mycorpus_60_wd)
mycorpus_50_wd<-table(mycorpus_50_wd)
mycorpus_40_wd<-table(mycorpus_40_wd)

#dataframe
df_corpus_00<-as.data.frame(mycorpus_00_wd, stringsAsFactors = F)
df_corpus_90<-as.data.frame(mycorpus_90_wd, stringsAsFactors = F)
df_corpus_80<-as.data.frame(mycorpus_80_wd, stringsAsFactors = F)
df_corpus_70<-as.data.frame(mycorpus_70_wd, stringsAsFactors = F)
df_corpus_60<-as.data.frame(mycorpus_60_wd, stringsAsFactors = F)
df_corpus_50<-as.data.frame(mycorpus_50_wd, stringsAsFactors = F)
df_corpus_40<-as.data.frame(mycorpus_40_wd, stringsAsFactors = F)

#rename
df_corpus_00<-rename(df_corpus_00,
                     word = mycorpus_00_wd,
                     freq = Freq)

df_corpus_90<-rename(df_corpus_90,
                     word = mycorpus_90_wd,
                     freq = Freq)

df_corpus_80<-rename(df_corpus_80,
                     word = mycorpus_80_wd,
                     freq = Freq)

df_corpus_70<-rename(df_corpus_70,
                     word = mycorpus_70_wd,
                     freq = Freq)

df_corpus_60<-rename(df_corpus_60,
                     word = mycorpus_60_wd,
                     freq = Freq)

df_corpus_50<-rename(df_corpus_50,
                     word = mycorpus_50_wd,
                     freq = Freq)

df_corpus_40<-rename(df_corpus_40,
                     word = mycorpus_40_wd,
                     freq = Freq)

#단어의 길이가 2글자 이상인것만 추출(는,것,과 같은 의미없는 단어가 많기 때문)
lyrics_00_word<-filter(df_corpus_00, nchar(word) >= 2)
lyrics_90_word<-filter(df_corpus_90, nchar(word) >= 2)
lyrics_80_word<-filter(df_corpus_80, nchar(word) >= 2)
lyrics_70_word<-filter(df_corpus_70, nchar(word) >= 2)
lyrics_60_word<-filter(df_corpus_60, nchar(word) >= 2)
lyrics_50_word<-filter(df_corpus_50, nchar(word) >= 2)
lyrics_40_word<-filter(df_corpus_40, nchar(word) >= 2)

#freq로 정렬
lyrics_00_word<-lyrics_00_word %>%
  arrange(desc(freq)) 

lyrics_90_word<-lyrics_90_word %>%
  arrange(desc(freq)) 

lyrics_80_word<-lyrics_80_word %>%
  arrange(desc(freq)) 

lyrics_70_word<-lyrics_70_word %>%
  arrange(desc(freq)) 

lyrics_60_word<-lyrics_60_word %>%
  arrange(desc(freq)) 

lyrics_50_word<-lyrics_50_word %>%
  arrange(desc(freq)) 

lyrics_40_word<-lyrics_40_word %>%
  arrange(desc(freq)) 
#wordcloud freq가 3이상인것만 
lyrics_00_word<-lyrics_00_word%>%filter(freq>=3)
lyrics_90_word<-lyrics_90_word%>%filter(freq>=3)
lyrics_80_word<-lyrics_80_word%>%filter(freq>=3)
lyrics_70_word<-lyrics_70_word%>%filter(freq>=3)
lyrics_60_word<-lyrics_60_word%>%filter(freq>=3)
lyrics_50_word<-lyrics_50_word%>%filter(freq>=3)
lyrics_40_word<-lyrics_40_word%>%filter(freq>=3)
wordcloud2(lyrics_00_word)

# 2014년도 일별 url 가져오기
for(x in 16071:16435){
  day<-str_replace_all(as.character(as.Date(x)),"-","")
  res<-GET(url=paste0("https://music.bugs.co.kr/chart/track/day/total?chartdate=",day))
  
  tbl1<-res %>% read_html(encoding="UTF-8") %>% 
    html_nodes(css="td a.trackInfo") %>% html_attr("href")
  
  assign(day,tbl1)
}

# 2015년도 일별 url 가져오기
for(x in 16436:16800){
  day<-str_replace_all(as.character(as.Date(x)),"-","")
  res<-GET(url=paste0("https://music.bugs.co.kr/chart/track/day/total?chartdate=",day))
  
  tbl2<-res %>% read_html(encoding="UTF-8") %>% 
    html_nodes(css="td a.trackInfo") %>% html_attr("href")
  
  assign(day,tbl2)
}

# 2016년도 일별 url 가져오기
for(x in 16801:17166){
  day<-str_replace_all(as.character(as.Date(x)),"-","")
  res<-GET(url=paste0("https://music.bugs.co.kr/chart/track/day/total?chartdate=",day))
  
  tbl3<-res %>% read_html(encoding="UTF-8") %>% 
    html_nodes(css="td a.trackInfo") %>% html_attr("href")
  
  assign(day,tbl3)
}

# 2017년도 일별 url 가져오기
for(x in 17167:17531){
  day<-str_replace_all(as.character(as.Date(x)),"-","")
  res<-GET(url=paste0("https://music.bugs.co.kr/chart/track/day/total?chartdate=",day))
  
  tbl4<-res %>% read_html(encoding="UTF-8") %>% 
    html_nodes(css="td a.trackInfo") %>% html_attr("href")
  
  assign(day,tbl4)
}

# 2018년도 일별 url 가져오기
for(x in 17532:17896){
  day<-str_replace_all(as.character(as.Date(x)),"-","")
  res<-GET(url=paste0("https://music.bugs.co.kr/chart/track/day/total?chartdate=",day))
  
  tbl5<-res %>% read_html(encoding="UTF-8") %>% 
    html_nodes(css="td a.trackInfo") %>% html_attr("href")
  
  assign(day,tbl5)
}

# 년도별로 합치기
fls<-ls()
fls<-fls[substr(fls,1,2)=="20"] #다른 변수는 제거

lyrics<-data.frame()
for(x in fls){lyrics<-rbind(lyrics,data.frame(Date=substr(x,1,6),url=get(x)))}

lyrics$Date<-as.character(lyrics$Date)
lyrics$url<-as.character(lyrics$url)
lyrics_result<-lyrics$url


# 중복 url 제거
lyrics_result<-unique(lyrics_result)

# 명사 부분만 추출하기
tt<-paste(unlist(SimplePos22(lyrics_result)))
alldata<-str_match_all(tt,"[가-힣]+/[N][C]|[가-힣]+/[N][Q]+")%>%unlist()
N<-str_replace_all(alldata,"/[N][C]","")%>%
  str_replace_all("/[N][Q]","")%>%unlist()

# 데이터 전처리(불용어,글자 수 2이상 추출, 숫자지우기 등)
DtaCorpusNC<-Corpus(VectorSource(N))
myTdmNC<-TermDocumentMatrix(DtaCorpusNC,control = list(wordLength=c(4,10),
                                                       removePunctuation=T,removeNumbers=T,weighting=weightBin))

mtNC<-as.matrix(myTdmNC)
#각 단어별 합계를 구함
mtrowNC<-rowSums(mtNC) 
# 정렬하기
mtNC.order<-mtrowNC[order(mtrowNC, decreasing=T)]
# 1:30위 그래프 그리기
freq.wordsNC<-mtNC.order[1:30]
freq.wordsNC<-as.matrix(freq.wordsNC) 
co.matrix <- freq.wordsNC %*% t(freq.wordsNC)  
qgraph(co.matrix, labels=rownames(co.matrix),
       diag=FALSE, layout='spring', threshold=3,border.color="Orange 1",color="Orange 1",
       vsize=log(diag(co.matrix)) *0.45,edge.color="Gold 2",label.cex=1.5)
# 31:60위 그래프 그리기
freq.wordsNC<-mtNC.order[31:60]
freq.wordsNC<-as.matrix(freq.wordsNC) 
co.matrix <- freq.wordsNC %*% t(freq.wordsNC)  
qgraph(co.matrix, labels=rownames(co.matrix),
       diag=FALSE, layout='spring', threshold=3,border.color="Orange 1",color="Orange 1",
       vsize=log(diag(co.matrix)) *0.45,edge.color="Gold 2",label.cex=1.5)

# 61:90위 그래프 그리기
freq.wordsNC<-mtNC.order[61:90]
freq.wordsNC<-as.matrix(freq.wordsNC) 
co.matrix <- freq.wordsNC %*% t(freq.wordsNC)  
qgraph(co.matrix, labels=rownames(co.matrix),
       diag=FALSE, layout='spring', threshold=3,border.color="Orange 1",color="Orange 1",
       vsize=log(diag(co.matrix)) *0.45,edge.color="Gold 2",label.cex=1.5)

