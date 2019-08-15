model_run<-function(model_input=NULL)
{
   
    if (is.null(model_input)) {
      print("No input parameter specified, using default data")
      model_input = list(patient_data = samplePatients[1,])
    } 
    if(is.null(model_input$patient_data)) {
      model_input$patient_data = samplePatients[1,]
    }
    if(is.null(model_input$random_sampling_N)) {
      model_input$random_sampling_N = 1000
    }
    if(is.null(model_input$random_distribution_iteration)) {
      model_input$random_distribution_iteration = 20000
    }
    if(is.null(model_input$calculate_CIs)) {
      model_input$calculate_CIs = TRUE
    }
    res <- predictACCEPT(model_input$patient_data, random_sampling_N = model_input$random_sampling_N,
                         random_distribution_iteration = model_input$random_distribution_iteration,
                         calculate_CIs = model_input$calculate_CIs)
    return(as.list(res))
}

get_default_input <- function() {
  model_input = list(patient_data = samplePatients)
  model_input$random_sampling_N = 1000
  model_input$random_distribution_iteration = 20000
  model_input$calculate_CIs = TRUE
  return(flatten_list(model_input))
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
