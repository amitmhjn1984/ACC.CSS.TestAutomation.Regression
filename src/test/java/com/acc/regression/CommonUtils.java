package com.acc.regression;

import java.util.*;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.mail.BodyPart;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.search.FlagTerm;

import org.apache.commons.lang.StringUtils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import cucumber.api.java.it.Date;

public class CommonUtils {

	public static final String defaultDateFormat = "dd/MM/yyyy";
	//public static final String defaultEpochDateFormat = "dd/MM/yyyy HH:mm:ss:sss";
	public static final String defaultEpochDateFormat = "yyyy/MM/dd";

	/**
	 * Convert String date format into Java Epoch format
	 * Returns Null, if parse for
	 * @param strDate
	 * @param DateFormate
	 * @return
	 */
	public static Long ConvertStrDateToJavaEpoch(String strDate,String DateFormate) throws ParseException {
		Long epoch = null;
		epoch = new SimpleDateFormat(DateFormate).parse(strDate).getTime();
		return epoch;
	} 
	
	public static Long ConvertStrDateToJavaEpoch(String strDate) throws ParseException {
		return ConvertStrDateToJavaEpoch(strDate,defaultDateFormat) ;
	}
	
	public static String ConvertEpochDateToDateStr(String strEpochDate) {
		return ConvertEpochDateToDateStr(strEpochDate,defaultEpochDateFormat);
	}
	
	public static String ConvertEpochDateToDateStr(String strEpochDate,String strFormate) {
		long longVal = Long.valueOf(strEpochDate);
		String date = new SimpleDateFormat(defaultEpochDateFormat).format(new java.util.Date (longVal));
		return date;
	}	

	public static String checkRegistrationEmail(String host,  String user,String password) {
			      String protocol="imaps";
			      boolean foundRegisCode = false;
			      String regristration_code = "";

			      try {
				  //test

			      //create properties field
			      Properties properties = new Properties();
			      
			      properties.setProperty("mail.store.protocol", protocol);

			      properties.setProperty("mail.imaps.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			      properties.setProperty("mail.imaps.socketFactory.fallback", "false");
			      properties.setProperty("mail.imaps.port", "993");
			      properties.setProperty("mail.imaps.socketFactory.port", "993");			      
			      
			      Session emailSession = Session.getDefaultInstance(properties);
			  
			      Store store = emailSession.getStore(protocol);

			      store.connect(host, user, password);
			      

			      Folder emailFolder = store.getFolder("Inbox");
			      emailFolder.open(Folder.READ_ONLY);
			      Message messages[] = emailFolder.search(new FlagTerm(new Flags(Flag.SEEN), false));
			      
			      System.out.println("messages.length---" + messages.length);
			      for (int i = 0, n = messages.length; i < n; i++) {
			         System.out.println("---------------------------------");
			         Message message = messages[i];

			         
			         int line_count = message.getLineCount();
			         System.out.println(line_count);

			         String msg = message.getDataHandler().getContent().toString();
			         System.out.println(msg);
			         
			         String searchStr = "Your registration code:";
			         String endStr = "<o:p></o:p></p>";
			         int searchStr_l = searchStr.length(); 
			         int endstr_l = endStr.length();
			         
			         String[] str = msg.split("\n");
				         for (String lineItem : str) {
							if (lineItem.contains(searchStr)) {
								int lineItem_l = lineItem.length();
								regristration_code = lineItem.substring(searchStr_l+4, lineItem_l-endstr_l-1);
								System.out.println(regristration_code);	
								foundRegisCode = true;
								break;
							}
						}
			         if (foundRegisCode) break;
			      }

			      //close the store and folder objects
			      emailFolder.close(false);
			      store.close();

			      } catch (NoSuchProviderException e) {
			         e.printStackTrace();
			      } catch (MessagingException e) {
			         e.printStackTrace();
			      } catch (Exception e) {
			         e.printStackTrace();
			      }
			     
			      return regristration_code;  
			   }

	
	
	
}
