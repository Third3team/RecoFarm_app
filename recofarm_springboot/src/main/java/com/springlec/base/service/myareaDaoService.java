package com.springlec.base.service;

import java.util.List;

import com.springlec.base.model.myareaDto;

public interface myareaDaoService {
	/*
	 * Description : myarea Dao service 
	 * Detail : 
	 * Date : 2024.04.21
	 * Author : pdg
	 * Update :
	 * 	2024.04.21 by pdg
	 * 	- myarea select and insert dao interface generate
	 */

	// 관심 소재지 리스트 출력 
	public List<myareaDto> myareaListDao(
			String userId
			) throws Exception;
	
	// 관심 소재지 리스트 하나의 재배 작물 출력  
	public String myareaOneDao(
			String userId
			) throws Exception;
	
	// 관심 소재지 입력 
	public void myareaInsertDao(
			String userId,
			Double area_lat,
			Double area_lng,
			Double area_size,
			String area_product,
			String area_address
			) throws Exception ;
		
}