package com.springlec.base.model;

public class myareaDto {

	/*
	 * Description : myarea dto Author : pdg Date : 2024.04.22 Udate : 2024.04.22 by
	 * pdg - dto 생
	 * 
	 */
	// Field
	int area_code;
	String userId;
	Double area_lat;
	Double area_lng;
	Double area_size;
	String area_product;
	String area_address;

	public myareaDto() {
		// TODO Auto-generated constructor stub
	}

	public myareaDto(int area_code, String userId, Double area_lat, Double area_lng, Double area_size,
			String area_product, String area_address) {
		super();
		this.area_code = area_code;
		this.userId = userId;
		this.area_lat = area_lat;
		this.area_lng = area_lng;
		this.area_size = area_size;
		this.area_product = area_product;
		this.area_address = area_address;
	}

	public int getArea_code() {
		return area_code;
	}

	public void setArea_code(int area_code) {
		this.area_code = area_code;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Double getArea_lat() {
		return area_lat;
	}

	public void setArea_lat(Double area_lat) {
		this.area_lat = area_lat;
	}

	public Double getArea_lng() {
		return area_lng;
	}

	public void setArea_lng(Double area_lng) {
		this.area_lng = area_lng;
	}

	public Double getArea_size() {
		return area_size;
	}

	public void setArea_size(Double area_size) {
		this.area_size = area_size;
	}

	public String getArea_product() {
		return area_product;
	}

	public void setArea_product(String area_product) {
		this.area_product = area_product;
	}

	public String getArea_address() {
		return area_address;
	}

	public void setArea_address(String area_address) {
		this.area_address = area_address;
	}

}
