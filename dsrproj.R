

library(data.table)
library(readr)
library(plotly)
library(ggplot2)
library(maps)
library(tm)
library(wordcloud)




MS_dataset <- read_csv("C:/Users/HP/Desktop/dsrfinal project/Mass Shootings Dataset Ver 5.csv"
                       , col_types = cols(Date = col_date(format = "%m/%d/%Y")))



MS_dataset <- data.table(MS_dataset)

MS_dataset[,Month:=as.factor(month(Date))]
MS_dataset[,Year_n:=as.numeric(year(Date))]
MS_dataset[,Year:=as.factor(year(Date))]

MS_dataset[Gender=='M',Gender:="Male"]
MS_dataset[Gender=='M/F',Gender:="Male/Female"]
MS_dataset[is.na(Gender),Gender:="Unknown"]
MS_dataset[,Gender:=as.factor(Gender)]





plot_ly(data = MS_dataset
        ,type = 'scatter'
        ,mode = 'markers' 
        ,hoverinfo = 'text'
        ,x = ~Month
        ,y = ~Year
        ,size = ~`Total victims`
        ,color = ~Gender
        ,colors = c('Red', 'Blue', 'Green', 'Black')
        ,alpha = 0.6
        ,text = ~paste("Location: ", Location
                       ,'\n Date: ', Date 
                       ,'\n Total victims : ', `Total victims` 
                       ,'\n Fatalities : ', Fatalities
                       ,'\n Injured : ', Injured)) %>% 
  layout(title = "Mass Shootings in US by years and month"
         , xaxis = list(title = "Month")
         , yaxis = list(title = "Years"))




 
f1 <- list(
  family = "Arial, sans-serif",
  size = 14,
  color = "grey"
)
f2 <- list(
  family = "Old Standard TT, serif",
  size = 12,
  color = "black"
)


ax <- list(
  title = "Month",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f2,
  exponentformat = "E"
)

ay <- list(
  title = "Year",
  titlefont = f1,
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = f2,
  exponentformat = "E"
)

b1 <- list(
  text = "Total victims",
  font = f1,
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.5,
  y = 1,
  showarrow = FALSE
)

b2 <- list(
  text = "Injured",
  font = f1,
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.5,
  y = 1,
  showarrow = FALSE
)

b3 <- list(
  text = "Fatalities",
  font = f1,
  xref = "paper",
  yref = "paper",
  yanchor = "bottom",
  xanchor = "center",
  align = "center",
  x = 0.5,
  y = 1,
  showarrow = FALSE
)


hm1 <- 
  plot_ly(data = MS_dataset
          ,type = 'heatmap'
          ,colors = colorRamp(c("yellow", "blue", "darkred"))
          ,x = ~Month
          ,y = ~Year
          ,z = ~`Total victims`)%>%
  layout(showlegend = T
         , xaxis = ax
         , yaxis = ay
         , annotations = b1)

hm2 <- 
  
  plot_ly(data = MS_dataset
          ,type = 'heatmap'
          ,colors = colorRamp(c("grey", "darkgrey", "black"))
          ,x = ~Month
          ,y = ~Year
          ,z = ~`Injured`)%>%
  layout(showlegend = T
         , xaxis = ax
         , annotations = b2
         , yaxis = list(
           title = "",
           zeroline = FALSE,
           showline = FALSE,
           showticklabels = FALSE,
           showgrid = FALSE
         ))

hm3 <- 
 
  plot_ly(data = MS_dataset
          ,type = 'heatmap'
          ,colors = colorRamp(c("orange", "darkred", "black"))
          ,x = ~Month
          ,y = ~Year
          ,z = ~Fatalities)%>%
  layout(showlegend = T
         , xaxis = ax 
         , annotations = b3
         , yaxis = list(
           title = "",
           zeroline = FALSE,
           showline = FALSE,
           showticklabels = FALSE,
           showgrid = FALSE
         ))


subplot(hm1, hm2, hm3)





plot_ly(data = MS_dataset
        ,type = 'bar'
        ,mode = 'markers' 
        ,hoverinfo = 'text'
        ,x = ~Year
        ,y = ~ `Total victims` 
        ,color = 'Red'
        ,alpha = 0.9
        ,text = ~paste(
          'Fatalities : ', Fatalities
          ,'\n Injured : ', Injured
        )) %>% 
  layout(title = "Number of Total victims by years"
         , xaxis = list(title = "")
         , yaxis = list(title = "Number of victims"))


plot_ly(data = MS_dataset
        ,type = 'histogram'
        ,mode = 'markers'
        ,x = ~Year
        ,alpha = 0.9) %>% 
  layout(title = "Number of incidents by years"
         , xaxis = list(title = "")
         , yaxis = list(title = "Number of incidents"))

plot_ly(data = MS_dataset
        ,type = 'histogram'
        ,mode = 'markers'
        ,x = ~Month
        ,alpha = 0.9) %>% 
  layout(title = "Number of incidents by month"
         , xaxis = list(title = "Month")
         , yaxis = list(title = "Number of incidents"))

plot_ly(data = MS_dataset[!is.na(Summary),]
        ,type = 'scatter'
        ,mode = 'markers' 
        ,hoverinfo = 'text'
        ,x = ~Fatalities
        ,y = ~Injured
        ,color = ~`Total victims`
        ,colors = colorRamp(c("darkgreen", "yellow", "darkred"))
        ,alpha = 0.6
        ,text = ~paste("Title: ", Title
                       ,'\n Date: ', Date 
                       ,'\n Total victims : ', `Total victims` 
                       ,'\n Fatalities : ', Fatalities
                       ,'\n Injured : ', Injured)) %>% 
  layout(title = "Fatalities & Injured (without \"Las Vegas Strip mass shooting\")"
         , xaxis = list(title = "Fatalities")
         , yaxis = list(title = "Injured")
         , plot_bgcolor='LightGrey')


MS_dataset[`Mental Health Issues`=="unknown",`Mental Health Issues`:="Unknown"]

# set collors for first pie chart
colors_pie1 <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')

plot_ly(data = MS_dataset[,.(`Total victims`,`Mental Health Issues`)]
        ,type = 'pie'
        ,labels = ~`Mental Health Issues`
        ,values = ~`Total victims`
        ,textposition = 'inside'
        ,insidetextfont = list(color = '#FFFFFF')
        ,marker = list(colors = colors_pie1,
                       line = list(color = '#FFFFFF', width = 1)))%>%
  layout(title = "Mental Health Issues",
         showlegend = T)

MS_dataset$State <- sapply(MS_dataset$Location, function(x){
  temp <- strsplit(x, split = ",")
  sapply(temp, function(y){y[2]
    
  })
})


plot_ly(data = MS_dataset[!is.na(State),.('Number of incidents'= uniqueN(`S#`)),by=State]
        ,type = 'pie'
        ,labels = ~State
        ,values = ~`Number of incidents`
        ,textposition = 'inside'
        ,insidetextfont = list(color = '#FFFFFF')
        ,marker = list(colors = colors_pie1,
                       line = list(color = '#FFFFFF', width = 1)))%>%
  layout(title = "Number of incidents by States",
         showlegend = T)

MS_dataset[Race=="unclear",Race:="Unknown"]
MS_dataset[is.na(Race),Race:="White"]

MS_dataset[Race=="Black American or African American" 
           | Race=="black"
           | Race=="Black American or African American/Unknown"
           ,Race:="Black"]

MS_dataset[Race=="White American or European American"
           | Race=="White American or European American/Some other Race" 
           | Race=="white"
           ,Race:="White"]

MS_dataset[Race=="Asian American"
           | Race=="Asian American/Some other race" 
           ,Race:="Asian"]

MS_dataset[Race=="Unknown",Race:="Other"]
MS_dataset[Race=="Two or more races",Race:="Other"]
MS_dataset[Race=="Some other race",Race:="Other"]
MS_dataset[Race=="Native American or Alaska Native",Race:="Native American"]




plot_ly(data = MS_dataset[Title!='Las Vegas Strip mass shooting',]
        ,type = 'box'
        ,mode = 'markers' 
        ,x = ~`Total victims`
        ,color =~Race
        ,alpha = 0.9) %>% 
  layout(title = "Total victims by Race  (without \"Las Vegas Strip mass shooting\")"
         , showlegend = T
         , xaxis = list(title = "Number of victims")
         , yaxis = list(title = ""))

plot_ly(data = MS_dataset[,.('Total victims'= sum(`Total victims`)),by=.(Race,Year)]
        ,type = 'bar'
        ,mode = 'markers'
        ,x = ~Year
        ,y = ~`Total victims`
        ,color =~Race
        ,alpha = 0.9) %>% 
  layout(title = "Total victims by Race"
         , showlegend = T
         , barmode = 'stack'
         , position = 1
         , xaxis = list(title = "")
         , yaxis = list(title = "")
         , legend = list(x = 0, y = 1)
         , hovermode = 'compare')



all_states <- map_data("state")
p <- ggplot()
p <- p + geom_polygon(data=all_states, aes(x=long, y=lat, group = group),colour="black", fill="white")
p <- 
  p + geom_point(data=MS_dataset[Longitude >=-140,]
                 , aes(x=Longitude, y=Latitude
                       ,size = `Total victims`
                       ,color = Fatalities)
                 ,alpha = 0.6) + 
  scale_color_gradient(low = "red", high = "black") + 
  ggtitle("Total victims & Fatalities on US map")


ggplotly(
  p
)


MS_dataset$century <- 
  sapply(MS_dataset$Year_n, function(x){
    ifelse(x>=2010,"7) 10th",
           ifelse(x>=2000,"6) 00th",
                  ifelse(x>=1990,"4) 90th",
                         ifelse(x>=1980,"3) 80th",
                                ifelse(x>=1970,"2) 70th","1) 60th")))))
  })

plot_ly(data = MS_dataset[Title!='Las Vegas Strip mass shooting',]
        ,type = 'scatter'
        ,mode = 'markers' 
        ,hoverinfo = 'text'
        ,x = ~Fatalities
        ,y = ~Injured
        ,frame = ~century
        ,size = ~`Total victims`
        ,color = ~'DarkRed'
        ,colors = c('DarkRed')
        ,alpha = 0.9
        ,text = ~paste("Location: ", Location
                       ,'\n Date: ', Date
                       ,'\n Total victims : ', `Total victims` 
                       ,'\n Injured : ', Injured
                       ,'\n Fatalities : ', Fatalities)) %>%
  layout(title = "Animated History of incidents by centuries"
         , xaxis = list(title = "Fatalities")
         , yaxis = list(title = "Injured")
         , showlegend = F
  ) %>%
  animation_opts(
    1500, redraw = FALSE
  )


accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}


MS_dataset_V <- MS_dataset[`S#`!=1,.(Date,Year_n,`Total victims`)]
MS_dataset_V$Type <- 'Total victims'
MS_dataset_I <- MS_dataset[`S#`!=1,.(Date,Year_n, Injured)]
MS_dataset_I$Type <- 'Injured'
MS_dataset_F <- MS_dataset[`S#`!=1,.(Date,Year_n, Fatalities)]
MS_dataset_F$Type <- 'Fatalities'

MS_dataset_VIF <- rbindlist(l = list(MS_dataset_V,MS_dataset_I,MS_dataset_F))


MS_dataset_VIF <- MS_dataset_VIF[,.('Total victims'=  sum(`Total victims`)),by=.(Year_n,Type)]

MS_dataset_VIF <- MS_dataset_VIF %>% accumulate_by(~Year_n)


plot_ly(data = MS_dataset_VIF
        ,type = 'scatter'
        ,mode = 'lines'
        ,line = list(simplyfy = F)
        ,x = ~Year_n
        ,y = ~`Total victims`
        ,color =~Type
        ,colors = c('Red','Orange','Black')
        ,frame = ~frame
        ,alpha = 0.9) %>% 
  layout(title = "Animated History of incidents"
         , showlegend = T
         , xaxis = list(title = "")
         , yaxis = list(title = "")
         ,legend = list(x = 0.1, y = 0.9)
         ,hovermode = 'compare')%>%
  animation_opts(
    frame = 200, 
    transition = 0, 
    redraw = FALSE
  ) %>%
  animation_slider(
    hide = F
  ) %>%
  animation_button(
    x = 1, xanchor = "right", y = 0, yanchor = "bottom"
  )


MS_dataset$Summary <- iconv(MS_dataset$Summary, "UTF8", "ASCII", sub="")

docs <- Corpus(VectorSource(MS_dataset$Summary)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(tolower)  %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace) %>%
  tm_map(PlainTextDocument)

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))

docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")


dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)


set.seed(44)

par(bg="black") 
wordcloud(words = d$word, freq = d$freq, min.freq = 1,scale=c(4, .1),
          max.words=300, random.order=FALSE, rot.per=0, 
          colors=brewer.pal(7, "Reds"), main="Title")

a1 <- 
  ggplot(data = MS_dataset[!is.na(Age)&Age!=0&Age<=70,], aes(x = Race, y = Age)) +
  geom_boxplot(aes(col = Race)) + 
  ggtitle("Age of the shooter & Race") +
  labs(x = "Race", y = "Age") +
  
  theme(axis.text.x = element_text(angle = 0
                                   , size = 9
                                   , color = 'black'
                                   , hjust = 1),
        legend.position="none") +
  geom_hline(aes(yintercept = median(Age))
             , colour = 'red'
             , linetype = 2
             , alpha = 0.5) + 
  geom_hline(aes(yintercept = mean(Age))
             , colour = 'blue'
             , linetype = 2
             , alpha = 0.5)

ggplotly(
  a1
)



