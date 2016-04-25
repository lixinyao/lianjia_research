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
                   avg(case when 建筑面积 > '4' and 建筑面积 < '50000'
                       and 建成年代 > '1900'
                       and 室数 < '9'
                       and 总价/建筑面积 > '10000' and 总价/建筑面积 < '10000'
                       then 总价/建筑面积 else 0 end) as 单位面积委托价格,
                   avg(case when 建筑面积 > '4' and 建筑面积 < '50000' 
                       and 建成年代 > '1900'
                       and 居数 < '9'
                       then 建筑面积 else 0 end) as 平均建筑面积
                   from SE房源
                   group by 城市,录入日期,委托类型
                   order by 城市,录入日期;")# 查询
mydata1 = dbFetch(res1,n=-1)
server = function(input,output){
  output$table1 = DT::renderDataTable(DT::datatable({
    data1 = mydata1
    data1 = subset(data1,data1$城市==input$select1)
    data1$录入日期 = as.Date(data1$录入日期,"%Y-%m-%d")
    data1 = subset(data1,data1$录入日期 >= input$dates1[1] &
                     data1$录入日期 < input$dates1[2])
    data1 = subset(data1,data1$委托类型==input$select2)
    data1 = subset(data1,select=input$indicators1)
  }))
  output$plot1 = renderPlot({
    data1 = mydata1
    data1 = subset(data1,data1$城市==input$select1)
    data1$录入日期 = as.Date(data1$录入日期,"%Y-%m-%d")
    data1 = subset(data1,data1$录入日期 >= input$dates1[1] &
                     data1$录入日期 <= input$dates1[2])
    data1 = subset(data1,data1$委托类型==input$select2)
    data1 = subset(data1,select=input$indicators1)
    ggplot(data = data1,aes(录入日期,委托量,group=1)) + 
      geom_line(color="#00AE66") +
      labs(title="SE房源委托量",x="日期",y="量") +
      theme_bw(base_family = "STHeiti")
  })
  output$plot2 = renderPlot({
    data1 = mydata1
    data1 = subset(data1,data1$城市==input$select1)
    data1$录入日期 = as.Date(data1$录入日期,"%Y-%m-%d")
    data1 = subset(data1,data1$录入日期 >= input$dates1[1] &
                     data1$录入日期 <= input$dates1[2])
    data1 = subset(data1,data1$委托类型==input$select2)
    data1 = subset(data1,select=input$indicators1)
    ggplot(data = data1,aes(录入日期,单位面积委托价格,group=1)) + 
      geom_line(color="#00AE66") +
      labs(title="SE房源单位面积委托价格",x="日期",y="量") +
      theme_bw(base_family = "STHeiti")
  })
  output$plot3 = renderPlot({
    data1 = mydata1
    data1 = subset(data1,data1$城市==input$select1)
    data1$录入日期 = as.Date(data1$录入日期,"%Y-%m-%d")
    data1 = subset(data1,data1$录入日期 >= input$dates1[1] &
                     data1$录入日期 <= input$dates1[2])
    data1 = subset(data1,data1$委托类型==input$select2)
    data1 = subset(data1,select=input$indicators1)
    ggplot(data = data1,aes(录入日期,平均建筑面积,group=1)) + 
      geom_line(color="#00AE66") +
      labs(title="SE房源委托平均建筑面积",x="日期",y="量") +
      theme_bw(base_family = "STHeiti")
  })
}