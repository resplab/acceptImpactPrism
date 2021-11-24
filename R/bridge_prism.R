#' @title Run ACCEPT Model
#' @description This function calls the predictACCEPT model. 
#' If no model_input is specified, it will use the defaults
#' If one of the columns in model_input is missing, it will replace with the default column
#' It will check all the columns of the patient_data object; if one is missing, it will
#' replace with the default, and will remove any extra columns
#' @param model_input A list/json object with "patient_data", "random_sampling_N", "random_distribution_iteration",
#' and "calculate_CIs" as columns
#' @return Returns a list of results
#' @export
model_run<-function(model_input=NULL)
{

     if(is.null(model_input$random_sampling_N)) {
       model_input$random_sampling_N = 100
     }
     if(is.null(model_input$calculate_CIs)) {
       model_input$calculate_CIs = FALSE
     }
    
    if (is.null(model_input)) {
      stop("no inputs were submitted")
    }
    #model_input <- as.data.frame(model_input)
  
    results <- accept(model_input, random_sampling_N = model_input$random_sampling_N)
     
  
    #plotting
    
    # Define the cars vector with 5 values
    cars <- c(1, 3, 6, 4, 9)
    
    # Graph cars
    barplot(cars)
    
    
    resultsPlot <- results %>% select(-c(male, age, smoker, oxygen, statin, LAMA, LABA, ICS, FEV1, BMI, SGRQ, LastYrExacCount, 
                                     LastYrSevExacCount, randomized_azithromycin,	randomized_statin,	randomized_LAMA,	
                                     randomized_LABA,	randomized_ICS, random_sampling_N, calculate_CIs ))
    
    azithroResults <- resultsPlot %>% select (ID, contains("azithro")) %>% mutate (Treatment = "With Azithromycin") %>%
      rename_all(list(~str_replace(., "azithromycin_", "")))
    baselineResults <- resultsPlot %>% select (-contains("azithro")) %>% mutate (Treatment = "Baseline")
    plotData <- rbind(azithroResults, baselineResults)
    probabilities <- plotData %>% select (Treatment, contains("probability"))
    rates <- plotData %>% select (Treatment, contains("rate"))
    
    png('rplot.png')
    p <- ggplot(probabilities , aes (x = Treatment)) + 
      geom_col(aes(y=100*predicted_exac_probability, fill=Treatment), show.legend = T, width = 0.7) + 
      geom_text(
        aes(label = paste0(ifelse(round (100*predicted_exac_probability, 1)<5, "<5", round (100*predicted_exac_probability, 1)), "%"), y = 100*predicted_exac_probability),
        nudge_x = -0.25, nudge_y = 2)  +  
      geom_errorbar(aes(ymin = 100*predicted_exac_probability_lower_PI, ymax = 100*predicted_exac_probability_upper_PI), width = 0.1) +
      #theme_tufte( base_size = 14) + labs (title="All Exacerbations", x="", y="Probability (%)" ) + ylim(c(0, 100)) +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank()) 
    
    print(p)
    dev.off()
    
    return(as.list(results))
}


prism_get_default_input <- function() {
  model_input = samplePatients[1,]
  model_input$random_sampling_N = 100
  model_input$calculate_CIs = FALSE
  return(model_input)
}


#Gets a hierarchical named list and flattens it; updating names accordingly
flatten_list<-function(lst,prefix="")
{
  if(is.null(lst)) return(lst)
  out<-list()
  if(length(lst)==0)
  {
    out[prefix]<-NULL
    return(out)
  }
  
  for(i in 1:length(lst))
  {
    nm<-names(lst[i])
    
    message(nm)
    
    if(prefix!="")  nm<-paste(prefix,nm,sep=".")
    
    if(is.list(lst[[i]]))
      out<-c(out,flatten_list(lst[[i]],nm))
    else
    {
      out[nm]<-lst[i]
    }
  }
  return(out)
}
