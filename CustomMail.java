package com.org.wepark;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class CustomMail {
	
	public int sendMail(String email,String subject,String content) {
		int res=0;
		
		final String from="16cs1k354@gmail.com";
		final String pass="chandra@1840";
	
		String host = "smtp.gmail.com";
	
		Properties props = new Properties();
		props.put("mail.transport.protocol", "smtp");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", "587");
	
		Session ss= Session.getInstance(props, new javax.mail.Authenticator()
				{
						protected PasswordAuthentication getPasswordAuthentication()
						{
							return new PasswordAuthentication(from,pass);
						}
				});
	
		try
		{
			Message msg= new MimeMessage(ss);
			msg.setFrom(new InternetAddress("16cs1k354@gmail.com"));
			msg.setRecipients(
					Message.RecipientType.TO, InternetAddress.parse(email)
					);
			msg.setSubject(subject);
			msg.setContent(content, "text/html");
			Transport.send(msg);
			res=1;
			//out.print("Sent!");\
		}
		catch(Exception e)
		{
			System.out.print(e);
		}
	
		
		return res;
	}

}
