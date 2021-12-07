package com.org.wepark;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CompareTime {
	
	public int compare(String arrive, String leave) {
		int check=0;
		
		if(arrive.equals(leave)) {
			return 0;
		}
		else {
			try {
				check = timeDifference(arrive, leave);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if(check==1) {
				return 1;
			}else {
				return 0;
			}
			
		}
	}
	
	private int timeDifference(String arrive, String leave) throws ParseException {
		DateFormat dateFormat=new SimpleDateFormat("HH:mm:ss");
		Date arriveTime=dateFormat.parse(arrive);
		Date leaveTime=dateFormat.parse(leave);
		
		if(arriveTime.compareTo(leaveTime)>0) {
			return 1;
		}else if(arriveTime.compareTo(leaveTime)<0){
			return 0;
		}else {
			return 0;
		}
		
	}
	

}
