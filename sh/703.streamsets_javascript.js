
for(var i = 0; i < records.length; i++) {
    try {
        // var aa = records[i].sdcRecord.get('/change');
      
         var bb = records[i].change;
       // output.write(aa);
      output.write(bb);
      /*
        for( j = 0; j < records[i].change.length; j++){
            var newRecord = sdcFunctions.createRecord(records[i].sourceId + ':nid' + j );
            if( records[i].change[j].kind == 'delete'){
            	newRecord.attributes['sdc.operation.type'] = 2;
              	
                var newMap = sdcFunctions.createMap(true);
            	for(k = 0; k < records[i].change[j].columnnames.length; k++){
            		newMap[ records[i].change[j].oldkeys.keynames[k]] = records[i].change[j].oldkeys.keyvalues[k];
           		}
            	newRecord.value = newMap;
              
              
            }else if( records[i].change[j].kind == 'insert'){
                newRecord.attributes['sdc.operation.type'] = 1;
              
                var newMap = sdcFunctions.createMap(true);
            	for(k = 0; k < records[i].change[j].columnnames.length; k++){
            		newMap[ records[i].change[j].keynames[k]] = records[i].change[j].keyvalues[k];
           		}
            	newRecord.value = newMap;
              
            }else if( records[i].change[j].kind == 'update'){
                newRecord.attributes['sdc.operation.type'] = 3;
              
                var newMap = sdcFunctions.createMap(true);
            	for(k = 0; k < records[i].change[j].columnnames.length; k++){
            		newMap[ records[i].change[j].keynames[k]] = records[i].change[j].keyvalues[k];
           		}
            	newRecord.value = newMap;
              
            }
           // newbatch.add(newRecord);
          	newRecord.attributes['schemaName'] = records[i].change[j].schema;
            newRecord.attributes['tableName'] = records[i].change[j].table;
        
        	
        }
              */




















for( i = 0; i < records.length; i++){
          try{
            
            if( records[i].kind == 'insert'){
               output.write("======1");
               newRecord.attributes['sdc.operation.type'] = 1;            
               output.write("======2");
            	for(k = 0; k < records[i].columnnames.length; k++){
                   output.write("======3");
            		newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
           		}
            }
              /*
             output.write(records[i].kind);
            var newRecord = sdcFunctions.createRecord(records[i].sourceId + ':nid' + i );
            var newMap = sdcFunctions.createMap(true);
            if( records[i].kind == 'delete'){
            	newRecord.attributes['sdc.operation.type'] = 2;
            	for(k = 0; k < records[i].columnnames.length; k++){
            		newMap[ records[i].oldkeys.keynames[k]] = records[i].oldkeys.keyvalues[k];
           		}     
              
            }else if( records[i].kind == 'insert'){
               output.write("======1");
               newRecord.attributes['sdc.operation.type'] = 1;            
               output.write("======2");
            	for(k = 0; k < records[i].columnnames.length; k++){
                   output.write("======3");
            		newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
           		}
               output.write("======4");
            }else if( records[i].kind == 'update'){
                newRecord.attributes['sdc.operation.type'] = 3;
                for(k = 0; k < records[i].columnnames.length; k++){
            		newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
           		}         	
              
            }
             
           // newbatch.add(newRecord);
          	 records[i].attributes['schemaName'] = records[i].schema;
             records[i].attributes['tableName'] = records[i].table;
         records[i].value = newMap;
        	*/
       
        output.write(records[i]);
    } catch (e) {
        // Send record to error
        error.write(records[i], e);
    }
}


















for( i = 0; i < records.length; i++){
      try{
        for( j = 0; j < records[i].value['change'].length; j++){
          
             if( records[i].value['change'][j]['kind'] == 'delete'){
            //	newRecord.attributes['sdc.operation.type'] = 2;
            //	for(k = 0; k <  records[i].value['change'][j][oldkeys]['keynames'].length; k++){
            		//newMap[ records[i].oldkeys.keynames[k]] = records[i].oldkeys.keyvalues[k];
                records[i].value['change'][j][records[i].value['change'][j]['oldkeys']['keynames'][0] ] = records[i].value['change'][j]['oldkeys']['keyvalues'][0];
                records[i].value['change'][j].attributes['sdc.operation.type'] = '2';
           	//	}     
              
            }else if( records[i].value['change'][j]['kind'] == 'insert'){
             
             //  newRecord.attributes['sdc.operation.type'] = 1;   
            	for(k = 0; k < records[i].value['change'][j]['columnnames'].length; k++){              
            	//	newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
                //  records[i].value['tablename'] =  records[i].value['change'][j]['table'];
                //  records[i].value[ records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];
                  records[i].value['change'][j][records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];
                  
           		}
                records[i].value['change'][j].attributes['sdc.operation.type'] = '1';
            }else if( records[i].value['change'][j]['kind']  == 'update'){
              //  newRecord.attributes['sdc.operation.type'] = 3;
                for(k = 0; k < records[i].value['change'][j]['columnnames'].length; k++){
            	//	newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
                  records[i].value['change'][j][records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];
           		}         	
               records[i].value['change'][j].attributes['sdc.operation.type'] = '3';
            }
        }
              /*
             output.write(records[i].kind);
            var newRecord = sdcFunctions.createRecord(records[i].sourceId + ':nid' + i );
            var newMap = sdcFunctions.createMap(true);
            if( records[i].kind == 'delete'){
            	newRecord.attributes['sdc.operation.type'] = 2;
            	for(k = 0; k < records[i].columnnames.length; k++){
            		newMap[ records[i].oldkeys.keynames[k]] = records[i].oldkeys.keyvalues[k];
           		}     
              
            }else if( records[i].kind == 'insert'){
               output.write("======1");
               newRecord.attributes['sdc.operation.type'] = 1;            
               output.write("======2");
            	for(k = 0; k < records[i].columnnames.length; k++){
                   output.write("======3");
            		newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
           		}
               output.write("======4");
            }else if( records[i].kind == 'update'){
                newRecord.attributes['sdc.operation.type'] = 3;
                for(k = 0; k < records[i].columnnames.length; k++){
            		newMap[ records[i].keynames[k]] = records[i].keyvalues[k];
           		}         	
              
            }
             
           // newbatch.add(newRecord);
          	 records[i].attributes['schemaName'] = records[i].schema;
             records[i].attributes['tableName'] = records[i].table;
         records[i].value = newMap;
        	*/
       
        output.write(records[i]);
    } catch (e) {
        // Send record to error
        error.write(records[i], e);
    }
}








for( i = 0; i < records.length; i++){
      try{
        for( j = 0; j < records[i].value['change'].length; j++){          
             if( records[i].value['change'][j]['kind'] == 'delete'){
               records[i].value['change'][j][records[i].value['change'][j]['oldkeys']['keynames'][0] ] = records[i].value['change'][j]['oldkeys']['keyvalues'][0];
                records[i].value['change'][j].attributes['sdc.operation.type'] = '2';
                          
            }else if( records[i].value['change'][j]['kind'] == 'insert'){             
            
            	for(k = 0; k < records[i].value['change'][j]['columnnames'].length; k++){              
                  records[i].value['change'][j][records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];
                  
           		}
                records[i].value['change'][j].attributes['sdc.operation.type'] = '1';
            }else if( records[i].value['change'][j]['kind']  == 'update'){
                 for(k = 0; k < records[i].value['change'][j]['columnnames'].length; k++){
                  records[i].value['change'][j][records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];
           		}         	
               records[i].value['change'][j].attributes['sdc.operation.type'] = '3';
            }
        }         
       
        output.write(records[i]);
    } catch (e) {
       
        error.write(records[i], e);
    }
}










for( i = 0; i < records.length; i++){
      try{
        for( j = 0; j < records[i].value['change'].length; j++){
           var newr = sdcFunctions.createRecord('newr' + i + 'and' + j);
           var newm = sdcFunctions.createMap(true);
             if( records[i].value['change'][j]['kind'] == 'delete'){           
                newm[ records[i].value['change'][j]['oldkeys']['keynames'][0] ] = records[i].value['change'][j]['oldkeys']['keyvalues'][0];               
                newr.attributes['sdc.operation.type'] = '2';
          		newr.attributes['table'] = records[i].value['change'][j]['table'];
                newr.attributes['schema'] = records[i].value['change'][j]['schema'];
            }else if( records[i].value['change'][j]['kind'] == 'insert'){
            	for(k = 0; k < records[i].value['change'][j]['columnnames'].length; k++){              
                   newm[ records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];                  
           		}
                newr.attributes['sdc.operation.type'] = '1';
                newr.attributes['table'] = records[i].value['change'][j]['table'];
                newr.attributes['schema'] = records[i].value['change'][j]['schema'];
            }else if( records[i].value['change'][j]['kind']  == 'update'){
                for(k = 0; k < records[i].value['change'][j]['columnnames'].length; k++){
                 newm[ records[i].value['change'][j]['columnnames'][k] ] = records[i].value['change'][j]['columnvalues'][k];
           		}         	
               newr.attributes['sdc.operation.type'] = '3';
               newr.attributes['table'] = records[i].value['change'][j]['table'];
               newr.attributes['schema'] = records[i].value['change'][j]['schema'];
            }
          newr.value = newm;
          records.add(newr);
        }
             
    } catch (e) {
      
        error.write(records[i], e);
    }
}


