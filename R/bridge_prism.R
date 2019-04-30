model_run<-function(model_input=NULL)
{
   patient_data<-samplePatients[1,]

   if(length(model_input)>0)
   {
     patient_data[names(model_input)]<-model_input
   }
   else
     stop("Error: no input parameter was submitted")

  res <- predictACCEPT(patient_data, 
                     random_sampling_N = model_input$random_sampling_N, 
                     random_distribution_iteration = model_input$random_distribution_iteration, 
                     calculate_CIs = model_input$calculate_CIs)
  
  return(as.list(res))
}
