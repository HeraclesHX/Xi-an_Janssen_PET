library(shiny)
library(shinythemes)
library(plotly)
library(dplyr)
library(shinydashboard)
library(tidyr)


tagList(
  # shinythemes::themeSelector(),
  navbarPage(
    # theme = "cosmo",  # <--- To use a theme, uncomment this
    theme = shinytheme("yeti"),
    "西安杨森",
    id = "panels",
    
    tabPanel("主页",
             fluidPage(
               # fluidRow(h3("Outline")),
               fluidRow(
                 h3("目录", 
                    style = "font-family: 'Lobster', cursive;
                    font-weight: 500; line-height: 1.1; 
                    color: #ad1d28;")
                 ),
               fluidRow(h4("1. 受访医生概况")),
               fluidRow(actionLink("link_to_1.1", 
                                   "1.1 每一跟踪时段的医生数目和新增人数")),
               fluidRow(actionLink("link_to_1.2", 
                                   "1.2 所选维度的医生分布")),
               fluidRow(actionLink("link_to_1.3", 
                                   "1.3 各个观念级别的受访医生数目及比例变化情况")),
               fluidRow(actionLink("link_to_1.4", 
                                   "1.4 不同观念级别医生的分布情况")),
               fluidRow(actionLink("link_to_1.5", 
                                   "1.5 不同观念级别医生对斯皮仁诺及其推广活动的接受和认可情况")),
               fluidRow(h4("2. 医生观念进阶情况")),
               fluidRow(actionLink("link_to_2.1", 
                                   "2.1 观念进阶医生的总体及在某一特定维度中的变化情况")),
               fluidRow(actionLink("link_to_2.2", 
                                   "2.2 观念进阶医生的分布情况")),
               fluidRow(actionLink("link_to_2.3", 
                                   "2.3 观念进阶医生对斯皮仁诺及其推广活动的接受和认可情况")),
               fluidRow(h4("3. 推广活动与受访医生")),
               fluidRow(actionLink("link_to_3.1", 
                                   "3.1 不同观念级别医生参与推广活动情况")),
               fluidRow(actionLink("link_to_3.2", 
                                   "3.2 不同观念级别医生参与推广活动情况的变化情况")),
               fluidRow(h4("4. 推广活动对观念进阶医生的影响")),
               fluidRow(actionLink("link_to_4.1", 
                                   "4.1 观念进阶医生参与推广活动情况")),
               fluidRow(actionLink("link_to_4.2", 
                                   "4.2 观念进阶医生参与推广活动的变化情况"))
               
               
             )),
    
    navbarMenu("1. 受访医生概况",
               tabPanel("1.1 每一跟踪时段的医生数目和新增人数",
                        sidebarPanel(
                          tags$h3("每季度受访医生数目递增情况及总体分析人数"),
                          actionLink("link_to_home_page_1.1", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("total_doc_bar")
                          ),
                          fluidRow(
                            tags$h2("")
                          ),
                          fluidRow(
                            plotlyOutput("new_doc_bar")
                          )
                        )
               ),
               
               tabPanel("1.2 所选维度的医生分布",
                        sidebarPanel(
                          tags$h3("各季度受访医生的总体分布情况"),
                          selectizeInput("year", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter",
                                         "季度", 
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_1.2", 
                                     "返回主页")
                        ),
                        mainPanel(
                          #- several distribution of physicians
                          fluidRow(
                            # h4("Total Physicians' Count by Quarter"),
                            splitLayout(cellWidths = c("50%", "50%"), 
                                        plotlyOutput("region_pie"), 
                                        plotlyOutput("level_pie"))
                          ),
                          fluidRow(
                            tags$h2("")
                          ),
                          fluidRow(
                            # h4("Total Physicians' Count by Quarter"),
                            splitLayout(cellWidths = c("50%", "50%"), 
                                        plotlyOutput("department_pie"))
                          )
                        )
               ),
               tabPanel("1.3 各个观念级别的受访医生数目及比例变化情况",
                        sidebarPanel(
                          tags$h3("每季度各个观念级别的受访医生数目及比例变化情况"),
                          selectizeInput("level",
                                         "医生级别", 
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_1.3", 
                                     "返回主页")
                        ),
                        mainPanel(
                          #- Tracking of physicians score and ratio 
                          # fluidRow(
                          #   # h4("Total Physicians' Count by Quarter"),
                          #   splitLayout(cellWidths = c("50%", "50%"),
                          #               plotlyOutput("doc_line"),
                          #               plotlyOutput("doc_cnt_stk_bar"))
                          #   )
                          fluidRow(
                            plotlyOutput("doc_line")
                          ),
                          fluidRow(
                            tags$h2("")
                          ),
                          fluidRow(
                            plotlyOutput("doc_cnt_stk_bar")
                          )
                        )
               ),
               tabPanel("1.4 不同观念级别医生的分布情况",
                        sidebarPanel(
                          tags$h3("各季度不同观念级别医生的分布情况"),
                          selectizeInput("year1", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter1",
                                         "季度", 
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_1.4", 
                                     "返回主页")
                        ),
                        mainPanel(
                          #- Tracking of distribution of physicians score and ratio 
                          fluidRow(
                            # h4("Total Physicians' Count by Quarter"),
                            plotlyOutput("region_stk")
                          ),
                          fluidRow(
                            tags$h2("")
                          ),
                          fluidRow(
                            # h4("Total Physicians' Count by Quarter"),
                            plotlyOutput("level_stk")
                          ),
                          fluidRow(
                            tags$h2("")
                          ),
                          fluidRow(
                            # h4("Total Physicians' Count by Quarter"),
                            plotlyOutput("department_stk")
                          )
                        )
               ),
               tabPanel("1.5 不同观念级别医生对斯皮仁诺及其推广活动的接受和认可情况",
                        sidebarPanel(
                          tags$h3("不同观念级别医生对斯皮仁诺及其推广活动的接受和认可情况（问卷第15、16题）"),
                          selectizeInput("year2", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter2",
                                         "季度", 
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_1.5", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("q15_line")
                          ),
                          fluidRow(
                            tags$h2("")
                          ),
                          fluidRow(
                            plotlyOutput("q16_line")
                          )
                        ))
    ),
    navbarMenu("2. 医生观念进阶情况",
               tabPanel("2.1 观念进阶医生的总体及在某一特定维度中的变化情况",
                        sidebarPanel(
                          tags$h3("每季度进阶医生的总体及在某一特定维度中的变化情况"),
                          selectInput("field", "请选择一个维度：区域/ 医生级别/ 科室",
                                      list(`区域` = c("region"),
                                           `医生级别` = c("tier"),
                                           `科室` = c("department")),
                                      selected = "Region"),
                          
                          selectizeInput("item", "请选择",
                                         choices = NULL,
                                         multiple = FALSE),
                          
                          
                          actionLink("link_to_home_page_2.1", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("track_pb_overall")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("pb_in_field")
                          )
                        )),
               
               tabPanel("2.2 观念进阶医生的分布情况",
                        sidebarPanel(
                          tags$h3("各季度观念进阶医生的分布情况"),
                          selectizeInput("year3", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter3", "季度",
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_2.2", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          # fluidRow(
                          #   splitLayout(cellWidths = c("50%", "50%"), 
                          #               plotlyOutput("region_stk_pb_var"), 
                          #               plotlyOutput("tier_stk_pb_var"))
                          # ),
                          fluidRow(
                            plotlyOutput("region_stk_pb_var")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("tier_stk_pb_var")
                          ),
                          # fluidRow(
                          #   splitLayout(cellWidths = c("50%", "50%"), 
                          #               plotlyOutput("department_stk_pb_var"))
                          # )
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("department_stk_pb_var")
                          )
                        )),
               
               tabPanel("2.3 观念进阶医生对斯皮仁诺及其推广活动的接受和认可情况",
                        sidebarPanel(
                          tags$h3("观念进阶医生对斯皮仁诺及其推广活动的接受和认可情况（问卷第15、16题）"),
                          selectizeInput("year4", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter4", "季度",
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_2.3", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("q15_bar_adv")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("q16_bar_adv")
                          )
                        ))
               
    ),
    
    navbarMenu("3. 推广活动与受访医生",
               tabPanel("3.1 不同观念级别医生参与推广活动情况",
                        sidebarPanel(
                          tags$h3("不同观念级别医生参与推广活动情况"),
                          selectizeInput("year5", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter5", "季度",
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_3.1", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("meeting_bar_score")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("call_bar_score")
                          )
                        )
               ),
               tabPanel("3.2 不同观念级别医生参与推广活动情况的变化情况",
                        sidebarPanel(
                          tags$h3("每季度不同观念级别医生参与的推广活动情况"),
                          selectizeInput("meeting_type", "会议类型",
                                         choices = NULL,
                                         multiple = FALSE),
                          
                          selectizeInput("region1", "区域",
                                         choices = NULL,
                                         multiple = FALSE),
                          
                          actionLink("link_to_home_page_3.2", 
                                     "返回主页")
                          
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("average_meeting_line")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("average_call_line")
                          )
                        )
               )
    ),
    
    navbarMenu("4. 推广活动对观念进阶医生的影响",
               tabPanel("4.1 观念进阶医生参与推广活动情况",
                        sidebarPanel(
                          tags$h3("不同观念级别医生参与推广活动情况"),
                          selectizeInput("year6", "年份",
                                         choices = NULL,
                                         multiple = FALSE),
                          selectizeInput("quarter6", "季度",
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_4.1", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("meeting_bar_adv")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("call_bar_adv")
                          )
                        )
               ),
               tabPanel("4.2 观念进阶医生参与推广活动的变化情况",
                        sidebarPanel(
                          tags$h3("每季度不同观念级别医生参与的推广活动情况"),
                          selectizeInput("meeting_type1", "会议类型",
                                         choices = NULL,
                                         multiple = FALSE),
                          
                          selectizeInput("region2", "区域",
                                         choices = NULL,
                                         multiple = FALSE),
                          actionLink("link_to_home_page_4.2", 
                                     "返回主页")
                        ),
                        
                        mainPanel(
                          fluidRow(
                            plotlyOutput("average_meeting_line_adv")
                          ),
                          fluidRow(
                            tags$h1("")
                          ),
                          fluidRow(
                            plotlyOutput("average_call_line_adv")
                          )
                        )
               )
               
    )
  )
  
)