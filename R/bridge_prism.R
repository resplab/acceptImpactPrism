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
    
    return(as.list(results))
}


get_default_input <- function() {
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
