library(shiny)
library(shinydashboard)
library(DT)
setwd("/Users/lixinyao/myprogram/shiny/lianjia_research")
# 标题
header = dashboardHeader(
  title = "链家研究院数据平台"
#  dropdownMenu(type = "messages",
#               messageItem(
#                 from = "Sales Dept",
#                 message = "Sales are steady this month"
#               ),
#               messageItem(
#                 from = "New User",
#                 message = "How do I register?",
#                 icon = icon("question"),
#                 time = "13:45"
#               ),
#               messageItem(
#                 from = "Support",
#                 message = "The new server is ready.",
#                 icon = icon("life-ring"),
#                 time = "2014-12-01"
#               )
#  )
)
# 侧边栏
sidebar = dashboardSidebar(
  sidebarMenu(id = "tabs",
              sidebarSearchForm(textId = "searchText",buttonId = "searchButton",
                                label = "Search..."),
              menuItem("宏观数据",tabName = "dashboard",icon = icon("dashboard"),
                       menuSubItem("整体宏观经济",tabName = "macro_1",icon = icon("angle-double-right")),
                       menuSubItem("北京",tabName = "macro_2",icon = icon("angle-double-right"))
              ),
              menuItem("链家数据",tabName = "lianjia_data",icon = icon("home"),
                       menuSubItem("SE房源",tabName = "se_house",icon = icon("angle-double-right")),
                       menuSubItem("SE客源",tabName = "se_customer",icon = icon("angle-double-right")),
                       menuSubItem("SE成交",tabName = "se_constract",icon = icon("angle-double-right")),
                       menuSubItem("SE调价",tabName = "se_changeprice",icon = icon("angle-double-right")),
                       menuSubItem("链家新房",tabName = "new_house",icon = icon("angle-double-right"))
              ),
              menuItem("网签数据",tabName = "netconstract_data",icon = icon("globe"),
                       menuSubItem("北京网签",tabName = "bj_netconstract",icon = icon("angle-double-right")),
                       menuSubItem("大连网签",tabName = "dl_netconstract",icon = icon("angle-double-right"))
              ),
              menuItem("关于我们",tabName = "widgets",icon = icon("question"))
  )
)
# 主体
body = dashboardBody(
  tabItems(
    tabItem(
      tabName = "se_house",
      fluidRow(
        column(width = 12,
               tabBox(width = 3,
                      tabPanel(h5("筛选条件"),
                               selectInput("select1",label = h5("选择城市"), 
                                           choices = unique(mydata1$城市), selected = "北京"),
                               selectInput("select3",label = h5("选择时间周期"),
                                           choices = c("月数据","周数据","日数据"),
                                           selected = "月数据"),
                               dateRangeInput("dates1",label = h5("选择日期"),language = "zh-CN"),
                               selectInput("select2",label = h5("委托类型"), 
                                           choices = unique(mydata1$委托类型), selected = "出售"),
                               checkboxGroupInput("indicators1",label = h5("选择指标"),
                                                  choices = unique(c(names(mydata1[,1:2]),
                                                              names(mydata2[,1:2]),
                                                              names(mydata3[,1:2]),
                                                              names(mydata1[,4:dim(mydata1)[2]]))),
                                                  selected = c("城市","录入月","委托类型","委托量")),
                               submitButton("确定")),
                      tabPanel(h5("下载"),
                               radioButtons("format","文档格式",c("Excel","PDF","HTML","Word"),
                                            inline = TRUE),
                               downloadButton("downloadReport")
                      )
               ),
               tabBox(width = 9,
                      tabPanel(h5("报表"),
                        DT::dataTableOutput('table1')),
                      tabPanel(h5("图形"),
                        plotOutput('plot1',width = "70%",height = "350px"),
                        plotOutput('plot2',width = "70%",height = "350px")
                        ),
                      tabPanel(h5("数据挖掘"))
               ))
    )
  )
))
# UI
ui = dashboardPage(header,sidebar,body)
shinyApp(ui,server)
