#ui.R



library(shinydashboard)
#automation<- read.csv(file = "automation_data_by_state.csv")
#Job tile filtering




shinyUI(dashboardPage(
  
  
    dashboardHeader(title = "OCCUPATION VS. AUTOMATION",
                    titleWidth = 450),
    dashboardSidebar(
        sidebarUserPanel("USA JOBS", image = "http://www.mendaur.com/wp-content/uploads/2017/01/Tech-Jobs.jpg" ),
        sidebarMenu(
            menuItem("Overview", tabName = "view", icon = icon("exclamation-circle")),
            menuItem("Summary", tabName = "title", icon = icon("clipboard-list")),
            
            menuItem("Explore by Job title", tabName = "Occupation", icon = icon("user-friends")),
            
            menuItem("Explore by State", tabName = "state", icon = icon("globe")),
         
            #menuItem("Explore/Compare", tabName = "compare", icon = icon("globe")),
            menuItem("Data", tabName = "data", icon = icon("database"))
        )
    ),
    dashboardBody(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      ),
        tabItems(
            tabItem(tabName = "view",
                   # h1("US JOB RISK FOR AUTOMATION"),
                    fluidRow(infoBoxOutput("maxBox"),
                             infoBoxOutput("minBox"),
                             infoBoxOutput("avgBox")),
                             
                    fluidRow(
                             box(img(src = "http://www.mendaur.com/wp-content/uploads/2017/01/Tech-Jobs.jpg",width="100%",height="40%"),
                                 htmlOutput("hist",width="100%",height = 150)
                                 
                                 ),
                             box(htmlOutput("view"),
                                     height = 570)
                                 ),
                   #fluidRow(box(htmlOutput("hist"),
                                 #height = 150)),
            ),
            
            tabItem(tabName = "title",
                    fluidRow( box(plotOutput("bar"),
                                  height = 570),
                              box(plotOutput("category_b"),
                                  height = 570))),
                              #box(htmlOutput("hist1"),
                                  #height = 250),
                              #box(plotOutput("bar9"),
                                  #height = 250))),
            
            tabItem(tabName = "Occupation",
                    
                    fluidRow(box(
                             background = "black",
                             selectInput(inputId = "job",
                             label = "Select Job Title",
                             choices = unique(automation$Occupation), selected = 'Chief Executives'),width = 4),
                      
                            box(background = "black",
                              sliderInput("slider", "Select State Count Range:",1, 12, 8),
                              height = 90 ,width = 4),
                            infoBoxOutput("AutoProb")),     
                    
                    fluidRow(box(plotOutput("comp"),
                                 height = 500),
                             box(plotOutput("comp_s"),
                                 height = 500))),
          
            tabItem(tabName = "state",
                    
                    fluidRow(box(
                      background = "black",
                      selectInput(
                                  inputId = "state",
                                  label = "Select State",
                                  choices = unique(auto_map_new$State), selected = 'Alaska'),width = 4),
                    
                              box(background = "black",
                                  textInput("text", "Search for similar job title:"),
                                  height = 90 ,width = 4),    
                               
                      
                                    box(background = "black",
                                    sliderInput("slider_st", "Select Job Title Range:",1, 10, 5),
                                    height = 90 ,width = 4)
                               ),
                    
                    fluidRow(box(plotOutput("scatter_s"),
                         height = 500),
                     box(plotOutput("textplot"),
                         height = 500)),
            
            ),
            
              
            
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12)))
            
            
            
        )
        
    )    
    
))   


