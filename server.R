# Server
library(shiny)
library(shinydashboard)
library(RMySQL)
library(ggplot2)
# 读入数据
con1 = dbConnect(RMySQL::MySQL(),
                 dbname = 'se_secondhand_house',
                 username = 'lixinyao',
                 password = 'lixin131820',
                 host = '127.0.0.1')# 设置连接
res1 = dbSendQuery(con1,"select 城市,录入时间2 as 录入日期,委托类型,
                   count(房源编号) as 委托量,
                   avg(总价) as 平均委托价格,avg(建筑面积) as 平均建筑面积
                   from se房源
                   group by 城市,录入日期,委托类型
                   order by 城市,录入日期;")# 查询
mydata = dbFetch(res1,n=-1)
server = function(input,output){
  output$table = DT::renderDataTable(DT::datatable({
    data = mydata
    data = subset(data,data$城市==input$select1)
    data = subset(data,data$录入日期 >= input$dates1[1] &
                  data$录入日期 < input$dates1[2])
    data = subset(data,data$委托类型==input$select2)
    data = subset(data,select=input$indicators1)
  }))
}
