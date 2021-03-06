
library(shiny)
library(shinythemes)
library(plotly)
library(dplyr)
library(shinydashboard)
library(tidyr)

load("./Data/.RData")

function(input, output, session) {
  
  observe({
    tmp_year <- unique(doc_region_dist_qtr$Year)
    tmp_quarter <- unique(doc_region_dist_qtr$Quarter)
    tmp_level <- as.character(unique(doc_perception_score_tier_qtr$doctor.tier))
    # tmp_region <- unique(eda_dat_tgt_with_call_all$region)
    tmp_region <- c("沪鲁苏皖", "京津冀黑辽吉", "粤桂琼", "浙闽湘鄂赣", "NULL", "Total")
    tmp_imeeting <- unique(eda_dat_tgt_with_meeting_all$imeeting.type)
    tmp_imeeting <- tmp_imeeting[!is.na(tmp_imeeting)]
    updateSelectizeInput(session,
                         'year',
                         choices = tmp_year[rank(tmp_year)], 
                         selected = "2016",
                         server = TRUE)
    updateSelectizeInput(session,
                         'quarter',
                         choices = tmp_quarter[rank( tmp_quarter)],
                         selected = "Q3",
                         server = TRUE)
    updateSelectizeInput(session,
                         'level',
                         choices = tmp_level,
                         selected = "A",
                         server = TRUE)
    updateSelectizeInput(session,
                         'year1',
                         choices = tmp_year[rank(tmp_year)], 
                         selected = "2016",
                         server = TRUE)
    updateSelectizeInput(session,
                         'quarter1',
                         choices = tmp_quarter[rank(tmp_quarter)],
                         selected = "Q3",
                         server = TRUE)
    updateSelectizeInput(session,
                         'year2',
                         choices = tmp_year[rank(tmp_year)], 
                         selected = "2016",
                         server = TRUE)
    updateSelectizeInput(session,
                         'quarter2',
                         choices = tmp_quarter[rank(tmp_quarter)],
                         selected = "Q3",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'year3',
                         choices = tmp_year[rank(tmp_year)], 
                         selected = "2016",
                         server = TRUE)
    updateSelectizeInput(session,
                         'quarter3',
                         choices = tmp_quarter[rank(tmp_quarter)],
                         selected = "Q4",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'year4',
                         choices = tmp_year[rank(tmp_year)], 
                         selected = "2016",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'quarter4',
                         choices = tmp_quarter[rank(tmp_quarter)],
                         selected = "Q4",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'year5',
                         choices = c("2017"), 
                         selected = "2017",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'quarter5',
                         choices = c("Q1", "Q2", "Q3", "Q4"),
                         selected = "Q1",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'region1',
                         choices = tmp_region,
                         selected = NULL,
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'meeting_type',
                         choices = tmp_imeeting[rank(tmp_imeeting)],
                         selected = NULL,
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'year6',
                         choices = c("2017"), 
                         selected = "2017",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'quarter6',
                         choices = c("Q1", "Q2", "Q3", "Q4"),
                         selected = "Q1",
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'region2',
                         choices = tmp_region,
                         selected = NULL,
                         server = TRUE)
    
    updateSelectizeInput(session,
                         'meeting_type1',
                         choices = tmp_imeeting[rank(tmp_imeeting)],
                         selected = NULL,
                         server = TRUE)
    
  })
  
  ##- do with action link
  observeEvent(input$link_to_1.1, {
    newvalue <- "1.1 每一跟踪时段的医生数目和新增人数"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_1.2, {
    newvalue <- "1.2 所选维度的医生分布"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_1.3, {
    newvalue <- "1.3 各个观念级别的受访医生数目及比例变化情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_1.4, {
    newvalue <- "1.4 不同观念级别医生的分布情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_1.5, {
    newvalue <- "1.5 不同观念级别医生对斯皮仁诺及其推广活动的接受和认可情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_2.1, {
    newvalue <- "2.1 观念进阶医生的总体及在某一特定维度中的变化情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_2.2, {
    newvalue <- "2.2 观念进阶医生的分布情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_2.3, {
    newvalue <- "2.3 观念进阶医生对斯皮仁诺及其推广活动的接受和认可情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_3.1, {
    newvalue <- "3.1 不同观念级别医生参与推广活动情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_3.2, {
    newvalue <- "3.2 不同观念级别医生参与推广活动情况的变化情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_4.1, {
    newvalue <- "4.1 观念进阶医生参与推广活动情况"
    updateTabItems(session, "panels", newvalue)
  })
  observeEvent(input$link_to_4.2, {
    newvalue <- "4.2 观念进阶医生参与推广活动的变化情况"
    updateTabItems(session, "panels", newvalue)
  })
  
  #- back to home page actionlink
  observeEvent(input$link_to_home_page_1.1, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_1.2, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_1.3, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_1.4, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_1.5, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_2.1, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  
  observeEvent(input$link_to_home_page_2.2, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_2.3, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_3.1, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_3.2, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_4.1, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  observeEvent(input$link_to_home_page_4.2, {
    newvalue <- "主页"
    updateTabItems(session, "panels", newvalue)
  })
  
  ##- below charts are for Summary of Count of Physicians by Quarter
  output$total_doc_bar <- renderPlotly({
    doc_cnt_qtr$Quarter <- paste(doc_cnt_qtr$Year, doc_cnt_qtr$Quarter, sep = "_")
    
    
    p <- plot_ly(doc_cnt_qtr, x = ~ Quarter, y = ~ doc_cnt, 
                 type = 'bar', 
                 # text = text,
                 marker = list(color = 'rgb(158,202,225)',
                               line = list(color = 'rgb(8,48,107)', 
                                           width = 1.5))) %>%
      layout(title = "每季度受访医生总数",
             xaxis = list(title = "季度"),
             yaxis = list(title = "医生数量"),
             annotations = list(x = doc_cnt_qtr$Quarter,
                                y = doc_cnt_qtr$doc_cnt,
                                text = doc_cnt_qtr$doc_cnt,
                                xanchor = 'center',
                                yanchor = 'bottom',
                                showarrow = FALSE),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
    
    p
  })
  
  output$new_doc_bar <- renderPlotly({
    doc_cnt_qtr$Quarter <- paste(doc_cnt_qtr$Year, doc_cnt_qtr$Quarter, sep = "_")
    doc_cnt_qtr$count_change <- doc_cnt_qtr$doc_cnt - lag(doc_cnt_qtr$doc_cnt, 1)
    
    p <- plot_ly(doc_cnt_qtr, x = ~ Quarter, y = ~ count_change, 
                 type = 'bar', 
                 # text = text,
                 marker = list(color = 'rgb(158,202,225)',
                               line = list(color = 'rgb(8,48,107)', 
                                           width = 1.5))) %>%
      layout(title = "每季度受访医生新增人数",
             xaxis = list(title = "季度"),
             yaxis = list(title = "新增医生数量"),
             annotations = list(x = doc_cnt_qtr$Quarter,
                                y = doc_cnt_qtr$count_change,
                                text = doc_cnt_qtr$count_change,
                                xanchor = 'center',
                                yanchor = 'bottom',
                                showarrow = FALSE),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
    
    p
  })
  
  ##- below charts are for Distributions of Survey Physicians
  
  tmp_doc_region_dist_qtr <- reactive({
    doc_region_dist_qtr %>%
      filter(Year == input$year, Quarter == input$quarter)
  })
  
  tmp_doc_level_dist_qtr <- reactive({
    doc_tier_dist_qtr %>%
      filter(Year == input$year, Quarter == input$quarter) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "_"))
  })
  
  tmp_doc_department_dist_qtr <- reactive({
    doc_department_dist_qtr %>%
      filter(Year == input$year, Quarter == input$quarter) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "_"))
  })
  
  output$region_pie <- renderPlotly({
    plot_ly(tmp_doc_region_dist_qtr(), labels = ~region, values = ~doc_cnt) %>%
      add_pie(hole = 0.6) %>%
      layout(title = paste("受访医生大区分布 ",
                           input$year, input$quarter, sep = ""),
             showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$level_pie <- renderPlotly({
    plot_ly(tmp_doc_level_dist_qtr(), labels = ~doctor.tier, values = ~doc_cnt) %>%
      add_pie(hole = 0.6) %>%
      layout(title = paste("受访医生潜力等级分布 ", 
                           input$year, input$quarter, sep = ""),
             showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
    
  })
  
  output$department_pie <- renderPlotly({
    plot_ly(tmp_doc_department_dist_qtr(), labels = ~department, values = ~doc_cnt) %>%
      add_pie(hole = 0.6) %>%
      layout(title = paste("受访医生科室分布 ", 
                           input$year, input$quarter, sep = ""),
             showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
    
  })
  
  ##- below charts are for tracking of physicians score and ratio
  tmp_doc_perception_score_tier_qtr <- reactive({
    doc_perception_score_tier_qtr %>%
      filter(doctor.tier == input$level) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "_"))
  })
  
  output$doc_line <- renderPlotly({
    plot_ly(tmp_doc_perception_score_tier_qtr(),
            x = ~Quarter,
            y = ~doc_cnt.x,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~hcp.major,
            color = ~hcp.major) %>%
      layout(title = paste(input$level, " 级医生每季度观念变化情况"),
             xaxis = list(title = '季度'),
             yaxis = list(title = '医生数量'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$doc_cnt_stk_bar <- renderPlotly({
    plot_ly(tmp_doc_perception_score_tier_qtr(),
            x = ~Quarter,
            y = ~doc_cnt_pct,
            type = "bar",
            color = ~hcp.major) %>%
      layout(title = paste(input$level, " 级医生每季度观念得分分布情况"),
             xaxis = list(title = '季度'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  ##- below charts are for distribution of physicians score and ratio
  tmp_doc_perception_score_region_qtr <- reactive({
    doc_perception_score_region_qtr %>%
      filter(Year == input$year1,
             Quarter == input$quarter1)
  })
  
  tmp1_doc_perception_score_tier_qtr <- reactive({
    doc_perception_score_tier_qtr %>%
      filter(Year == input$year1,
             Quarter == input$quarter1)
  })
  
  tmp_doc_perception_score_department_qtr <- reactive({
    doc_perception_score_department_qtr %>%
      filter(Year == input$year1,
             Quarter == input$quarter1)
  })
  
  output$region_stk <- renderPlotly({
    plot_ly(tmp_doc_perception_score_region_qtr(),
            x = ~region,
            y = ~doc_cnt_pct,
            type = "bar",
            color = ~hcp.major) %>%
      layout(title = paste("按区域医生观念得分分布情况 ",
                           input$year1, input$quarter1, sep = ""),
             xaxis = list(title = '区域'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$level_stk <- renderPlotly({
    plot_ly(tmp1_doc_perception_score_tier_qtr(),
            x = ~doctor.tier,
            y = ~doc_cnt_pct,
            type = "bar",
            color = ~hcp.major) %>%
      layout(title = paste("按医生级别医生观念得分分布情况 ",
                           input$year1, input$quarter1, sep = ""),
             xaxis = list(title = '医生级别'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$department_stk <- renderPlotly({
    plot_ly(tmp_doc_perception_score_department_qtr(),
            x = ~department,
            y = ~doc_cnt_pct,
            type = "bar",
            color = ~hcp.major) %>%
      layout(title = paste("按科室医生观念得分分布情况 ",
                           input$year1, input$quarter1, sep = ""),
             xaxis = list(title = '科室'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  ##- below charts are for Attitude to Sporanox and promotional activities for
  ##- all physicians (questionnaire Q15 &Q16)
  
  tmp_eda_dat_15_q <- reactive({
    eda_dat_15_q %>%
      filter(Year == input$year2,
             Quarter == input$quarter2) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "_"))
  })
  
  tmp_eda_dat_16_q <- reactive({
    eda_dat_16_q %>%
      filter(Year == input$year2,
             Quarter == input$quarter2) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "_"))
  })
  
  output$q15_line <- renderPlotly({
    plot_ly(tmp_eda_dat_15_q(),
            x = ~hcp.major,
            y = ~doc_cnt_pct,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~answers,
            color = ~answers) %>%
      layout(title = paste("对斯皮仁诺优势的认可情况 ",
                           input$year2, input$quarter2, sep = ""),
             xaxis = list(title = '观念得分'),
             yaxis = list(title = '比例'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$q16_line <- renderPlotly({
    plot_ly(tmp_eda_dat_16_q(),
            x = ~hcp.major,
            y = ~doc_cnt_pct,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~answers,
            color = ~answers) %>%
      layout(title = paste("对斯皮仁诺推广活动接受情况 ",
                           input$year2, input$quarter2, sep = ""),
             xaxis = list(title = '观念得分'),
             yaxis = list(title = '比例'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  
  ##-- Part2 
  ##-- 2.1
  output$track_pb_overall <- renderPlotly({
    plot_ly(smmy_psc_qtr_smmy_nat, 
            x = ~Quarter,
            y = ~adv, 
            type = "bar", 
            name = "观念进阶的医生数量") %>%
      add_trace(x = ~Quarter, 
                y = ~adv_ratio, 
                type = "scatter",
                mode = "lines",
                yaxis = "y2",
                name = "观念进阶的医生数量比例") %>%
      layout(yaxis2 = list(title = "比例",
                           overlaying = "y",
                           side = "right",
                           fill = "tozeroy"),
             yaxis = list(title = "观念进阶的医生数量"),
             xaxis = list(name = "季度"),
             title = "每季度的总体观念进阶医生的数量/比例",
             legend = list(x = 0,
                           y = 100,
                           orientation = "h"),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  observe({
    tmp <- get(paste("smmy_psc_qtr_smmy_", input$field, sep = ""))
    tmp1 <- unique(unlist(tmp[, 1]))
    updateSelectizeInput(session,
                         'item',
                         choices = tmp1[rank(tmp1)],
                         server = TRUE)
  })
  
  smmy_psc_qtr_smmy_field <- reactive({
    tmp <- get(paste("smmy_psc_qtr_smmy_", input$field, sep = ""))
    tmp1 <- unique(unlist(tmp[, 1]))
    if (is.null(input$item)) {
      tmp
    } else {
      tmp[unlist(tmp[, 1]) == input$item, ]
    }
  })
  
  output$pb_in_field <- renderPlotly({
    plot_ly(smmy_psc_qtr_smmy_field(), 
            x = ~Quarter,
            y = ~adv, 
            type = "bar", 
            name = "观念进阶的医生数量") %>%
      add_trace(x = ~Quarter, 
                y = ~adv_ratio, 
                type = "scatter",
                mode = "lines",
                yaxis = "y2",
                name = "观念进阶的医生数量比例") %>%
      layout(yaxis2 = list(title = "比例",
                           overlaying = "y",
                           side = "right",
                           rangemode = "tozero"),
             yaxis = list(title = "观念进阶的医生数量"),
             xaxis = list(name = "季度"),
             title = paste("每季度的总体观念进阶医生的数量/比例于", input$item, sep = " "),
             legend = list(x = 0,
                           y = 100,
                           orientation = "h"),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  ##-- 2.2
  tmp_smmy_psc_qtr_smmy_region <- reactive({
    smmy_psc_qtr_smmy_region %>%
      group_by(Quarter) %>%
      do(plyr::rbind.fill(., data.frame(Quarter = first(.$Quarter),
                                        region = "Total",
                                        adv = sum(.$adv, na.rm = TRUE),
                                        total = sum(.$total, na.rm = TRUE)))) %>%
      ungroup(Quarter) %>%
      mutate(Year = substr(Quarter, 1, 4),
             Quarter = substr(Quarter, 6, 7),
             adv_ratio = adv / total,
             `观念进阶医生` = adv_ratio) %>%
      filter(Year == input$year3,
             Quarter == input$quarter3) %>%
      mutate(`观念未进阶医生` = 1 - `观念进阶医生`) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      select(-total, -adv, -Year, -adv_ratio) %>%
      gather(item, ratio, -region, -Quarter)
  })
  
  tmp_smmy_psc_qtr_smmy_department <- reactive({
    smmy_psc_qtr_smmy_department %>%
      group_by(Quarter) %>%
      do(plyr::rbind.fill(., data.frame(Quarter = first(.$Quarter),
                                        department = "Total",
                                        adv = sum(.$adv, na.rm = TRUE),
                                        total = sum(.$total, na.rm = TRUE)))) %>%
      ungroup() %>%
      mutate(Year = substr(Quarter, 1, 4),
             Quarter = substr(Quarter, 6, 7),
             adv_ratio = adv / total,
             `观念进阶医生` = adv_ratio) %>%
      filter(Year == input$year3,
             Quarter == input$quarter3) %>%
      mutate(`观念未进阶医生` = 1 - `观念进阶医生`) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      select(-total, -adv, -Year, -adv_ratio) %>%
      gather(item, ratio, -department, -Quarter)
  })
  
  tmp_smmy_psc_qtr_smmy_tier <- reactive({
    tmp <- smmy_psc_qtr_smmy_tier %>%
      group_by(Quarter) %>%
      do(plyr::rbind.fill(., data.frame(Quarter = first(.$Quarter),
                                        doctor.tier = "Total",
                                        adv = sum(.$adv, na.rm = TRUE),
                                        total = sum(.$total, na.rm = TRUE)))) %>%
      ungroup() %>%
      mutate(Year = substr(Quarter, 1, 4),
             Quarter = substr(Quarter, 6, 7),
             adv_ratio = adv / total,
             `观念进阶医生` = adv_ratio) %>%
      filter(Year == input$year3,
             Quarter == input$quarter3) %>%
      mutate(`观念未进阶医生` = 1 - `观念进阶医生`) %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      select(-total, -adv, -Year, -adv_ratio) %>%
      gather(item, ratio, -doctor.tier, -Quarter)
    
    tmp$doctor.tier <- factor(tmp$doctor.tier, 
                              levels = c("Total", "A", "B", "C", "U", NA))
    
    tmp
  })
  
  
  output$region_stk_pb_var <- renderPlotly({
    plot_ly(tmp_smmy_psc_qtr_smmy_region(),
            x = ~region,
            y = ~ratio,
            type = "bar",
            color = ~item) %>%
      layout(title = paste("按区域观念进阶医生的分布 ",
                           input$year3, input$quarter3, sep = ""),
             xaxis = list(title = '区域'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$department_stk_pb_var <- renderPlotly({
    plot_ly(tmp_smmy_psc_qtr_smmy_department(),
            x = ~department,
            y = ~ratio,
            type = "bar",
            color = ~item) %>%
      layout(title = paste("按科室观念进阶医生的分布 ",
                           input$year3, input$quarter3, sep = ""),
             xaxis = list(title = '科室'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$tier_stk_pb_var <- renderPlotly({
    plot_ly(tmp_smmy_psc_qtr_smmy_tier(),
            x = ~doctor.tier,
            y = ~ratio,
            type = "bar",
            color = ~item) %>%
      layout(title = paste("按医生级别观念进阶医生的分布 ",
                           input$year3, input$quarter3, sep = ""),
             xaxis = list(title = '医生级别'),
             yaxis = list(title = '比例'),
             barmode = "stack",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  ##-- 2.3
  tmp_eda_dat_15_q_adv <- reactive({
    eda_dat_15_q_adv %>%
      filter(Year == input$year4,
             Quarter == input$quarter4) %>%
      group_by(Year, Quarter, answers, doc_cnt_total) %>%
      do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                        Quarter = first(.$Quarter),
                                        answers = first(.$answers),
                                        adv_flag = 2,
                                        doc_cnt_total = first(.$doc_cnt_total),
                                        doc_cnt = sum(.$doc_cnt)
      ))) %>%
      filter(!is.na(adv_flag)) %>%
      mutate(flag = ifelse(adv_flag == 1, "观念进阶医生",
                           "所有医生"),
             doc_cnt_pct = ifelse(adv_flag == 1, doc_cnt / doc_cnt_total_adv,
                                  doc_cnt / doc_cnt_total))
  })
  
  tmp_eda_dat_16_q_adv <- reactive({
    eda_dat_16_q_adv %>%
      filter(Year == input$year4,
             Quarter == input$quarter4) %>%
      group_by(Year, Quarter, answers, doc_cnt_total) %>%
      do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                        Quarter = first(.$Quarter),
                                        answers = first(.$answers),
                                        adv_flag = 2,
                                        doc_cnt_total = first(.$doc_cnt_total),
                                        doc_cnt = sum(.$doc_cnt)
      ))) %>%
      filter(!is.na(adv_flag)) %>%
      mutate(flag = ifelse(adv_flag == 1, "观念进阶医生",
                           "所有医生"),
             doc_cnt_pct = ifelse(adv_flag == 1, doc_cnt / doc_cnt_total_adv,
                                  doc_cnt / doc_cnt_total))
  })
  
  output$q15_bar_adv <- renderPlotly({
    plot_ly(tmp_eda_dat_15_q_adv(),
            x = ~doc_cnt_pct,
            y = ~answers,
            type = "bar",
            color = ~flag,
            orientation = "h") %>%
      layout(title = paste("观念进阶医生对斯皮仁诺优势的认可情况 ",
                           input$year4, input$quarter4, sep = ""),
             xaxis = list(title = '比例'),
             yaxis = list(title = '认可情况'),
             barmode = "group",
             autosize = T,
             margin =  list(
               l = 250,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  output$q16_bar_adv <- renderPlotly({
    plot_ly(tmp_eda_dat_16_q_adv(),
            x = ~doc_cnt_pct,
            y = ~answers,
            type = "bar",
            color = ~flag,
            orientation = "h") %>%
      layout(title = paste("观念进阶医生对斯皮仁诺推广活动的接受情况 ",
                           input$year4, input$quarter4, sep = ""),
             xaxis = list(title = '比例'),
             yaxis = list(title = '推广活动'),
             barmode = "group",
             autosize = T,
             margin =  list(
               l = 250,
               r = 150,
               b = 100,
               t = 100,
               pad = 4
             ))
  })
  
  ##-- Part3
  ##-- 3.1
  tmp_eda_dat_tgt_with_meeting_all <- reactive({
    eda_dat_tgt_with_meeting_all %>%
      filter(Year == input$year5,
             Quarter == input$quarter5)
  })
  
  tmp_eda_dat_tgt_with_call_all <- reactive({
    eda_dat_tgt_with_call_all %>%
      filter(Year == input$year5,
             Quarter == input$quarter5)
  })
  
  output$meeting_bar_score <- renderPlotly({
    plot_ly(tmp_eda_dat_tgt_with_meeting_all(),
            x = ~imeeting.type,
            y = ~avg_meeting_cnt,
            type = "bar",
            color = ~hcp.major) %>%
      layout(title = paste("不同观念级别医生出席会议的平均次数 ",
                           input$year5, input$quarter5, sep = ""),
             xaxis = list(title = '会议类型'),
             yaxis = list(title = '出席会议平均次数'),
             barmode = "group",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 150,
               t = 100,
               pad = 4
             ))
  })
  
  output$call_bar_score <- renderPlotly({
    plot_ly(tmp_eda_dat_tgt_with_call_all(),
            x = ~region,
            y = ~avg_call_cnt,
            type = "bar",
            color = ~hcp.major) %>%
      layout(title = paste("不同观念级别医生接受拜访的平均次数 ",
                           input$year5, input$quarter5, sep = ""),
             xaxis = list(title = '区域'),
             yaxis = list(title = '接受拜访的平均次数'),
             barmode = "group",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 150,
               t = 100,
               pad = 4
             ))
  })
  
  ##-- 3.2
  tmp1_eda_dat_tgt_with_meeting_all <- reactive({
    eda_dat_tgt_with_meeting_all %>%
      ungroup() %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      filter(imeeting.type == input$meeting_type,
             !is.na(imeeting.type))
  })
  
  output$average_meeting_line <- renderPlotly({
    plot_ly(tmp1_eda_dat_tgt_with_meeting_all(),
            x = ~Quarter,
            y = ~avg_meeting_cnt,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~hcp.major,
            color = ~hcp.major) %>%
      layout(title = paste("每季度不同观念级别医生出席会议的平均次数"),
             xaxis = list(title = '季度'),
             yaxis = list(title = '出席会议平均次数'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 50,
               t = 100,
               pad = 4
             ))
  })
  
  tmp1_eda_dat_tgt_with_call_all <- reactive({
    eda_dat_tgt_with_call_all %>%
      ungroup() %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      filter(region == input$region1,
             Year != "2016")
  })
  
  output$average_call_line <- renderPlotly({
    plot_ly(tmp1_eda_dat_tgt_with_call_all(),
            x = ~Quarter,
            y = ~avg_call_cnt,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~hcp.major,
            color = ~hcp.major) %>%
      layout(title = paste("每季度不同观念级别医生接受拜访的平均次数"),
             xaxis = list(title = '季度'),
             yaxis = list(title = '接受拜访的平均次数'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 50,
               t = 100,
               pad = 4
             ))
  })
  
  ##-- Part4
  ##-- 4.1
  tmp_eda_dat_tgt_with_meeting_adv_all <- reactive({
    eda_dat_tgt_with_meeting_adv_all %>%
      filter(Year == input$year6,
             Quarter == input$quarter6)
  })
  
  tmp_eda_dat_tgt_with_call_adv_all <- reactive({
    eda_dat_tgt_with_call_adv_all %>%
      filter(Year == input$year6,
             Quarter == input$quarter6)
  })
  
  output$meeting_bar_adv <- renderPlotly({
    plot_ly(tmp_eda_dat_tgt_with_meeting_adv_all(),
            x = ~imeeting.type,
            y = ~avg_meeting_cnt,
            type = "bar",
            color = ~adv_flag) %>%
      layout(title = paste("观念进阶医生出席会议的平均次数 ",
                           input$year6, input$quarter6, sep = ""),
             xaxis = list(title = '会议类型'),
             yaxis = list(title = '出席会议的平均次数'),
             barmode = "group",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 150,
               t = 100,
               pad = 4
             ))
  })
  
  output$call_bar_adv <- renderPlotly({
    plot_ly(tmp_eda_dat_tgt_with_call_adv_all(),
            x = ~region,
            y = ~avg_call_cnt,
            type = "bar",
            color = ~adv_flag) %>%
      layout(title = paste("观念进阶医生接受拜访的平均次数 ",
                           input$year6, input$quarter6, sep = ""),
             xaxis = list(title = '大区'),
             yaxis = list(title = '接受拜访的平均次数'),
             barmode = "group",
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 150,
               t = 100,
               pad = 4
             ))
  })
  
  eda_dat_tgt_with_meeting_adv_all$adv_flag <-
    ifelse(eda_dat_tgt_with_meeting_adv_all$adv_flag == "Overall Physicians",
           "所有受访医生",
           "观念进阶医生")
  
  eda_dat_tgt_with_call_adv_all$adv_flag <-
    ifelse(eda_dat_tgt_with_call_adv_all$adv_flag == "Overall Physicians",
           "所有受访医生",
           "观念进阶医生")
  
  ##-- 4.2
  tmp1_eda_dat_tgt_with_meeting_adv_all <- reactive({
    eda_dat_tgt_with_meeting_adv_all %>%
      ungroup() %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      filter(imeeting.type == input$meeting_type1,
             !is.na(imeeting.type))
  })
  
  output$average_meeting_line_adv <- renderPlotly({
    plot_ly(tmp1_eda_dat_tgt_with_meeting_adv_all(),
            x = ~Quarter,
            y = ~avg_meeting_cnt,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~adv_flag,
            color = ~adv_flag) %>%
      layout(title = paste("每季度观念进阶医生出席会议的平均次数"),
             xaxis = list(title = '季度'),
             yaxis = list(title = '出席会议的平均次数'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 150,
               t = 100,
               pad = 4
             ))
  })
  
  tmp1_eda_dat_tgt_with_call_adv_all <- reactive({
    eda_dat_tgt_with_call_adv_all %>%
      ungroup() %>%
      mutate(Quarter = paste(Year, Quarter, sep = "")) %>%
      filter(region == input$region2,
             Year != "2016")
  })
  
  output$average_call_line_adv <- renderPlotly({
    plot_ly(tmp1_eda_dat_tgt_with_call_adv_all(),
            x = ~Quarter,
            y = ~avg_call_cnt,
            type = "scatter",
            mode = 'linesmarker',
            linetype = ~adv_flag,
            color = ~adv_flag) %>%
      layout(title = paste("每季度观念进阶医生接受拜访的平均次数"),
             xaxis = list(title = '季度'),
             yaxis = list(title = '接受拜访的平均次数'),
             autosize = T,
             margin =  list(
               l = 150,
               r = 150,
               b = 150,
               t = 100,
               pad = 4
             ))
  })
}
