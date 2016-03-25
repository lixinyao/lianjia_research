# Server
library(shiny)
library(shinydashboard)
library(RMySQL)
library(ggplot2)
# 读入数据
# wind宏观经济
con1 = dbConnect(RMySQL::MySQL(),
                 dbname = 'se_secondhand_house',
                 username = 'lixinyao',
                 password = 'lixin131820',
                 host = '127.0.0.1')# 设置连接
res1 = dbSendQuery(con1,"select * from SE房源;")# 查询
mydata = dbFetch(res1,n=-1)# 读入数据框
server = function(input,output){
  output$table = DT::renderDataTable(DT::datatable({
    data = mydata
    data = subset(data,select=input$indicators)
    data = subset(data,data$录入时间==input$dates)
  }))
}
