package com.springlec.base.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springlec.base.dao.myareaDao;
import com.springlec.base.model.myareaDto;
/*
 * Description 	: myarea dao service interface
 * 		Detail 	:  
 * 		Date	: 2024.04.21
 * 		Author 	: pdg
 * 		Update	:
 * 			2024.04.21 by pdg
 * 				- myarea dao insert, select gen 

 */
@Service
public class myareaDaoServiceImpl implements myareaDaoService{
	 	
	@Autowired
	myareaDao dao;
	
	// 내 관심 소재지 조회 함수 
	@Override
	public List<myareaDto> myareaListDao(
			String userId
			) throws Exception {
		System.out.println(" >> myareaDaoService Implement 실행");
		System.out.println("	: -> myareaListDao(impl) 실행");
		return dao.myareaListDao(userId); // Select 조회 결과물을 반환
		
	}

	// 내 관심 소재지 Insert action  
	@Override
	public void myareaInsertDao(
			String userId,
			Double area_lat,
			Double area_lng,
			Double area_size,
			String area_product,
			String area_address
			) throws Exception {
		System.out.println(" >> myareaDaoService Implement 실행");
		System.out.println("	: -> myareaInsertDao 실행");
		
		dao.myareaInsertDao(
			userId,
			area_lat,
			area_lng,
			area_size,
			area_product,
			area_address
				);
		
	}

	@Override
	public String myareaOneDao(String userId) throws Exception {
		return dao.myareaOneDao(userId);
	}
} // END



