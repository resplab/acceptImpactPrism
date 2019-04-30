model_run<-function(model_input=NULL)
{
   patient_data<-samplePatients[1,]

   if(length(model_input)>0)
   {
     patient_data[names(model_input)]<-model_input
   }
   else
     stop("Error: no input parameter was submitted")

  res<-predictACCEPT(patient_data)
  
  return(as.list(res))
}
