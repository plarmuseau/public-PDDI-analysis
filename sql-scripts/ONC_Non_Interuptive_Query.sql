	--Script to get Mapped ONC_Non_Interuptive Dataset
	--Added 9/17/2014 By Serkan 


	--All available PDDIs, total 2994 PDDIs
	SELECT DISTINCT	
		   [ID]
		  ,[Object_Class]
		  ,[Object_Drug]  
		  ,[Preciptiant_Class]
		  ,Precipitant_Drug  
	  FROM [PDDI_Databases].[dbo].[ONC_Non_Interuptive]  
	  ORDER BY [ID],[Object_Drug],Precipitant_Drug


	--Per John Horn: Don't Include Iron Salts. Set them IsVisible, 63 total
	UPDATE o
	SET IsVisible = 0
	FROM [PDDI_Databases].[dbo].[ONC_Non_Interuptive] o
	WHERE [Object_Class] Like '%iron%' 
		OR [Preciptiant_Class] Like '%iron%' 
		
   
   
    --All Visible PDDIs, total 2931 PDDIs
	SELECT DISTINCT	
		   [ID]
		  ,[Object_Class]
		  ,[Object_Drug]  
		  ,[Preciptiant_Class]
		  ,Precipitant_Drug  
	  FROM [PDDI_Databases].[dbo].[ONC_Non_Interuptive] 
	  WHERE IsVisible = 1
	  ORDER BY [ID],[Object_Drug],Precipitant_Drug

/********************************************************/
--Get Mapped Results
/*******************************************************/ 
	
	--All Mapped Dataset -- in total 2101 PDDIs
	 SELECT DISTINCT	  		 
		   COALESCE(d1.name, sy1.[DrugName]) 
		  +'$'+COALESCE(d1.drugbankid, sy1.[drugbankid])  
		  +'$'+COALESCE(d2.name, sy2.[DrugName]) 
		  +'$'+ COALESCE(d2.drugbankid, sy2.[drugbankid])
		  +'$'
	 FROM [PDDI_Databases].[dbo].[ONC_Non_Interuptive] o	
		LEFT JOIN [PDDI_Databases].[dbo].[DrugbankDrugs] d1 ON d1.name= o.Object_Drug 
		LEFT JOIN [PDDI_Databases].[dbo].[DrugbankDrugs] d2 ON d2.name= o.Precipitant_Drug 
		LEFT JOIN (Select d.drugbankid,d.[DrugName],d.[Synonym] 
					From [PDDI_Databases].[dbo].[DrugbankSynonyms] d
						LEFT JOIN [PDDI_Databases].[dbo].[MultipleSynonyms] m ON m.Common_Synonym = d.[Synonym]
					Where Common_Synonym IS NULL
					) sy1 ON sy1.[Synonym]= o.Object_Drug 
		LEFT JOIN (Select d.drugbankid,d.[DrugName],d.[Synonym] 
					From [PDDI_Databases].[dbo].[DrugbankSynonyms] d
						LEFT JOIN [PDDI_Databases].[dbo].[MultipleSynonyms] m ON m.Common_Synonym = d.[Synonym]
					Where Common_Synonym IS NULL
					) sy2 ON sy2.[Synonym]= o.Precipitant_Drug  
	WHERE IsVisible = 1
		AND (d1.[DrugbankID] is not null  or sy1.drugbankid is not null)
		AND (d2.[DrugbankID] is not null  or sy2.drugbankid is not null)


  

			 