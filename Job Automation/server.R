ibrary(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    auto_title <- reactive({
        auto_map_new %>%
            filter(Occupation == input$job) %>% arrange(State_prob)
    })
    
    auto_state <- reactive({
        auto_map_new %>%
            filter(State == input$state) 
    })
    
    auto_text <- reactive({
        auto_map_new %>%  filter(State == input$state) %>% filter(str_detect(str_to_lower(Occupation),tolower(input$text))) %>% summarise(Occupation,Probability,Count)
            
    })
    
  

    # show 10 most risky states for job title    
    output$comp <- renderPlot({
        #auto_map_new %>% filter(Occupation == input$job) %>% arrange(desc(State_prob)) %>% head(5) %>%  
            
        auto_title() %>%  arrange(desc(State_prob)) %>% head(10) %>% 
        ggplot(aes(x = State, y = Count, fill = State))+ 
            geom_bar(stat="identity")+scale_fill_brewer( palette = "Blues")+xlab("")+ylab("")+
            theme_bw() + ggtitle("Top 5 High Risk states")
        
    })
    
    # show 10 most risky states for job title - Slider   
    output$comp <- renderPlot({
        #auto_map_new %>% filter(Occupation == input$job) %>% arrange(desc(State_prob)) %>% head(5) %>%  
        
        auto_title() %>%  arrange(desc(State_prob)) %>% head(input$slider_st) %>% 
            ggplot(aes(x = State, y = Count, fill = State))+ 
            geom_bar(stat="identity")+xlab("")+ylab("")+scale_fill_brewer( palette = "Blues")+
            theme_bw() + ggtitle("Top 5 High Risk states")
        
    })
    
    
    
    
    # show 10 safe states for job title    
    output$comp_s <- renderPlot({
        #auto_map_new %>% filter(Occupation == input$job) %>% arrange(desc(State_prob)) %>% head(5) %>%  
        
        auto_title() %>% arrange(State_prob) %>% head(input$slider) %>% 
            ggplot(aes(x = State, y = Count ,fill = State))+ 
            geom_bar(stat="identity")+xlab("")+ylab("")+scale_fill_brewer( palette = "Blues")+
            theme_bw() + ggtitle("Top 5 Safe states")
        
    })
    
    # show 10 safe states for job title  - Slider 
    output$comp <- renderPlot({
        #auto_map_new %>% filter(Occupation == input$job) %>% arrange(desc(State_prob)) %>% head(5) %>%  
        
        auto_title() %>%  arrange(desc(State_prob)) %>% head(input$slider) %>% 
            ggplot(aes(x = State, y = Count, fill = State ))+ 
            geom_bar(stat="identity")+xlab("")+ylab("")+scale_fill_brewer( palette = "Blues")+
            theme_bw() + ggtitle("Top 5 High Risk states")
        
    })
    
    # Show Probability of Selected Title
    output$AutoProb <- renderInfoBox({
        
            #auto_text <- "Automation Probability"
            value <-
               automation$Probability[(automation$Occupation) == input$job]
            infoBox("Automation Probability:", value, icon = icon("exclamation-circle"),width = 2, color = "red", fill = TRUE)
    })
   
    
    # show overview using googleVis
    output$view <- renderGvis({
        
        gvisGeoChart(Overview_data,"State","total",
                     options=list(region="US", displayMode="regions", 
                                  resolution="provinces",
                                  width="100%", height="100%",
                                  title = "US Job Automation Count",
                                  (vAxes="[{title:'State based Job Automation Probability'}"),
                                  colorAxis="{colors:['white', 'red']}",
                                  backgroundColor="white"))
    })  
    # Show Statistics of Overview data
    output$maxBox <- renderInfoBox({
        max_value <- max(Overview_data$total)
        max_state <-
            Overview_data$State[(Overview_data$total) == max_value]
        infoBox(max_state, max_value, icon = icon("hand-o-up"),width = 2, color = "red", fill = TRUE)
    })
    
    output$minBox <- renderInfoBox({
        min_value <- min(Overview_data$total)
        min_state <-
            Overview_data$State[(Overview_data$total) == min_value]
        infoBox(min_state, min_value, icon = icon("hand-o-down"),width = 2, color = "navy", fill = TRUE)
    })
    
    output$avgBox <- renderInfoBox(
        infoBox(paste("AVG.", "Automation Count"),
                round(mean(Overview_data$total)),
                icon = icon("calculator"),  color = "aqua", fill = TRUE))
    
    
    # search with text input
    
    
    # show bar Chart of category
    output$category <- renderPlot({
        auto_map_new %>% filter(category_m != "Other") %>% count(category_m)%>% 
            ggplot(aes(y = category_m)) +
            geom_density(aes(color = category_m))+theme(axis.text.x=element_blank()) +xlab("Job Category")+ylab("Job title Count")  +theme_bw() +ggtitle("Job Category Density")
        
    })
    
    # Show boxlot of category
    
    output$category_b <- renderPlot({
        auto_map_new %>% filter(category_m != "Other") %>% 
            ggplot(aes(x = category_m, y = Count)) +geom_boxplot(aes(color = category_m))+
           theme(axis.text.x=element_blank()) +xlab("Job Category")+ylab("Job title Count")  +theme_bw() +ggtitle("Job Category Density")
        
    })
    
    
    
    # show bar Chart using ggplot - top 10 jobs impacting maximum number of people
        output$bar <- renderPlot({
            auto_map_new %>% group_by(Probability,Occupation) %>% summarize(Headcount = sum(Count)) %>% 
                arrange(desc(Headcount)) %>% head(10) %>% ggplot(aes(x = Headcount, y = Occupation, fill = "Headcount" ))+ 
                geom_bar(stat="identity")+
                scale_fill_brewer( palette = "Blues")+
                theme_bw() +ggtitle("Top 10 Job Title impacting maximum people")+theme(plot.title = element_text(hjust = 0.5))
        
        })
        
        
    # show histogram using googleVis
            output$hist <- renderGvis({
                gvisHistogram(automation[,"Probability",drop=FALSE],options = list(width='100%', height='100%',color = 'red'))
                                                                                   
            })
     # show scatter-plt for State provbaility vs Count using ggplot
            
            output$scatter_s <- renderPlot({
                auto_text() %>% ggplot(aes(x = Probability, y = Count )) +
                    geom_point(alpha=0.5, size=3, aes(color = Probability))+xlab("")+ylab("") +theme_bw() +ggtitle("Scatter plot for different job title")
            
            })
            
    # show state count map with title filter using googleVis
            output$map <- renderGvis({
                
                gvisGeoChart(auto_map_new,"State","State_prob", 
                             options=list(region="US", displayMode="regions", 
                                          resolution="provinces",
                                          width="auto", height="auto",
                                          title = "State based Job Automation Probability",
                                          (vAxes="[{title:'State based Job Automation Probability'}"),
                                          colorAxis="{colors:['grey','navy']}",
                                          backgroundColor="white"))
            })        
           
            # Text seach info
            output$textplot <- renderPlot({
                #auto_map_new %>% filter(Occupation == input$job) %>% arrange(desc(State_prob)) %>% head(5) %>%  
                
                auto_text() %>%  arrange(desc(Probability)) %>% arrange(desc(Count)) %>% head(input$slider_st) %>% 
                    ggplot(aes(x = Occupation, y = Count, fill = Occupation ))+ 
                    geom_bar(stat="identity")+xlab("")+ylab("")+scale_fill_brewer( palette = "Blues")+
                    theme_bw() + ggtitle("Most Critical Jobs")
            
            }) 
            
            # show data using DataTable
            output$table <- DT::renderDataTable({
                datatable(automation, rownames=FALSE) %>% 
                    formatStyle(input$Occupation, background="skyblue", fontWeight='bold')
            })  
            
            
            
            
              })





