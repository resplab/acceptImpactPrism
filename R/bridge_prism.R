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
