package com.hongen.recharge.bean;

import java.util.Random;
import java.util.UUID;



public class Beantools {
	
	
   public  int getRandom(int min, int max){
   	Random random = new Random();
   	 int ran = Math.abs(random.nextInt());
   	 int returnRan = ran%(max-min+1)+min;
   	 return returnRan;
   }
   
  
   
   
   
  
   
   public static void main(String[] args) {
	   String s = UUID.randomUUID().toString(); 
       //去掉“-”符号 
       String str=s.substring(0,8)+s.substring(9,13)+s.substring(14,18)+s.substring(19,23)+s.substring(24);
       System.out.println(s);
       System.out.println(str);
       System.out.println(str.length());
       
       Beantools bt = new Beantools();
       String ran = "";
       for (int i=0; i<4; i++)
       {
       	ran +=  bt.getRandom(0, 9);
		}
       System.out.println(ran);
}

}
