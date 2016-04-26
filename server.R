# Server
library(shiny)
library(shinydashboard)
library(RMySQL)
library(ggplot2)
library(gtable)
library(grid)
# 读入数据
con1 = dbConnect(RMySQL::MySQL(),
                 dbname = 'se_secondhand_house',
                 username = 'lixinyao',
                 password = 'lixin131820',
                 host = '127.0.0.1')# 设置连接
res1 = dbSendQuery(con1,"select 城市,录入时间2 as 录入日期,委托类型,
                   count(房源编号) as 委托量,
                   avg(case when 建筑面积 > 4 and 建筑面积 < 50000
                       and 房屋用途 in ('别墅','公寓','经济适用房','普通住宅')
                       and 建成年代 > 1900
                       and 室数 < 9
                       and 总价/建筑面积 > 1 and 总价/建筑面积 < 15
                       then 总价/建筑面积 else 0 end)*10000 as 平均委托单价,
                   avg(case when 建筑面积 > 4 and 建筑面积 < 50000 
                       and 建成年代 > 1900
                       and 室数 < 9
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
    p1 = ggplot(data = data1,aes(录入日期,委托量)) + 
      geom_bar(fill="#009A60",stat = "identity") + 
      ylim(0,max(data1$委托量) * 1.3) +
      labs(title="SE房源委托量及平均委托单价",x="日期",y="委托量") +
      theme_bw(base_family = "STHeiti")
    p2 = ggplot(data = data1,aes(录入日期,平均委托单价,group=1)) + 
      geom_line(color="#E0E123",size=1) +
      geom_point(color="#E0E123",fill="#ffffff",size=2) +
      ylim(min(data1$平均委托单价) * 0.95,max(data1$平均委托单价) * 1.05) +
      labs(x="日期",y="元/平米") +
      theme_bw(base_family = "STHeiti") %+replace%
      theme(panel.grid=element_blank(),panel.background = element_rect(fill = NA))
    g1 = ggplot_gtable(ggplot_build(p1))
    g2 = ggplot_gtable(ggplot_build(p2))
    # overlap the panel of 2nd plot on that of 1st plot
    pp = c(subset(g1$layout, name == "panel", se = t:r))
    pp
    g = gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t,
                         pp$l, pp$b, pp$l)
    # axis tweaks
    ia = which(g2$layout$name == "axis-l")
    ga = g2$grobs[[ia]]
    ax = ga$children[[2]]
    ax$widths = rev(ax$widths)
    ax$grobs = rev(ax$grobs)
    ax$grobs[[1]]$x = ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")
    g = gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
    g = gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)
    ia = which(g2$layout$name == "ylab")
    ga = g2$grobs[[ia]]
    ga$rot = 270
    g = gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
    g = gtable_add_grob(g, ga, pp$t, length(g$widths) - 1, pp$b)
    # draw it
    grid.draw(g)
  })
  output$plot2 = renderPlot({
    data1 = mydata1
    data1 = subset(data1,data1$城市==input$select1)
    data1$录入日期 = as.Date(data1$录入日期,"%Y-%m-%d")
    data1 = subset(data1,data1$录入日期 >= input$dates1[1] &
                     data1$录入日期 <= input$dates1[2])
    data1 = subset(data1,data1$委托类型==input$select2)
    data1 = subset(data1,select=input$indicators1)
    ggplot(data = data1,aes(录入日期,平均建筑面积,group=1)) + 
      geom_line(color="#009A60") +
      labs(title="SE房源委托平均建筑面积",x="日期",y="平米") +
      theme_bw(base_family = "STHeiti")
  })
}