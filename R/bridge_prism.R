#' @title Run ACCEPT Model
#' @description This function calls the predictACCEPT model. 
#' If no model_input is specified, it will use the defaults
#' If one of the columns in model_input is missing, it will replace with the default column
#' It will check all the columns of the patient_data object; if one is missing, it will
#' replace with the default, and will remove any extra columns
#' @param model_input A list/json object with "patient_data", "random_sampling_N", "random_distribution_iteration",
#' and "calculate_CIs" as columns
#' @return Returns a list of results
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
    patient_data = tibble::as_tibble(model_input$patient_data)
    patient_data = checkPatientInput(patient_data)
    model_input$patient_data = patient_data
    
    results = predictACCEPT(model_input$patient_data, random_sampling_N = model_input$random_sampling_N,
                      random_distribution_iteration = model_input$random_distribution_iteration,
                      calculate_CIs = model_input$calculate_CIs)
    return(as.list(results))
}

checkPatientInput = function(patientData) {
  samplePatients = samplePatients[1,]
  columnNames = names(samplePatients)
  dataNames = names(patientData)
  for(name in columnNames) {
    if(!(name %in% dataNames)) {
      patientData[[name]] = samplePatients[[name]]
      message(paste0(name, " is missing in patient input data, setting it to default value"))
    }
  }
  for(name in dataNames) {
    if(!(name %in% columnNames)) {
      patientData[[name]] = NULL
      message(paste0(name, " is not a valid column. Removing from patient input"))
    }
  }
  return(patientData)
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
