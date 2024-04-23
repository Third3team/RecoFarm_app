package com.springlec.base.dao;

import java.util.List;

import com.springlec.base.model.myareaDto;

/*
 * Description	: Recofarm service users DB table 정보 가져오기 위한 DAO mapper interface 
 *    Date		: 2024.04.21
 *    Author	: Forrest Park (pdg)
 *    Update	: 
 *    	2024.04.21 by pdg
 *    		- myarea dao 추가
 *    		- myarea select user id 로 찾아야함.  
 *    

 */
public interface myareaDao {
	
	// select dao
	public List<myareaDto> myareaListDao(String userId) throws Exception;

	// select one area dao
	public String  myareaOneDao(String userId) throws Exception;
	
	// insert dao
	public void myareaInsertDao(
			String userId,
			Double area_lat,
			Double area_lng,
			Double area_size,
			String area_product,
			String area_address
			
			) throws Exception ;


} // End