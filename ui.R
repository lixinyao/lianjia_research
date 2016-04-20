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
              menuItem("宏观经济数据",tabName = "dashboard",icon = icon("dashboard"),
                       menuSubItem("整体宏观经济",tabName = "macro_1",icon = icon("angle-double-right")),
                       menuSubItem("北京",tabName = "macro_2",icon = icon("angle-double-right"))
              ),
              menuItem("链家房地产数据",tabName = "lianjia_data",icon = icon("dashboard"),
                       menuSubItem("SE二手房",tabName = "se_secondhand_house",icon = icon("angle-double-right")),
                       menuSubItem("新房",tabName = "new_house",icon = icon("angle-double-right"))
              ),
              menuItem("关于我们",tabName = "widgets",icon = icon("question"))
  )
)
# 主体
body = dashboardBody(
  tabItems(
    tabItem(
      tabName = "se_secondhand_house",
      fluidRow(
        column(width = 12,
               tabBox(width = NULL,
                      tabPanel(h5("筛选条件"),
                               dateRangeInput("dates",label = h5("选择日期"),language = "zh-CN"),
                               checkboxGroupInput("indicators",label = h5("选择指标"),
                                                  choices = names(mydata),
                                                  selected="房源编号"),
                               submitButton("确定")),
                      tabPanel(h5("下载"),
                               radioButtons("format","文档格式",c("Excel","PDF","HTML","Word"),
                                            inline = TRUE),
                               downloadButton("downloadReport")
                      ),
                      tabPanel(h5("数据"),
                               DT::dataTableOutput('table'))
               )))
    )
  )
)
# UI
ui = dashboardPage(header,sidebar,body)
shinyApp(ui,server)
