<%@page import="com.org.wepark.ConnectionManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="com.sun.mail.handlers.message_rfc822"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="org.apache.catalina.Authenticator"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Base64"%>
<%@page import="javax.crypto.SecretKey"%>
<%@page import="javax.crypto.spec.PBEKeySpec"%>
<%@page import="java.security.spec.KeySpec"%>
<%@page import="javax.crypto.SecretKeyFactory"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.security.MessageDigest"%>
<%@ page import = "java.io.*,java.util.*, java.sql.*"%>
<%@ page import = "javax.mail.*,javax.activation.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">

        <link rel="stylesheet" type="text/css" href="css/otp.css"> 
        <title>WePark SignUp</title>
    </head>
    <body>
        <div class="container" id="container">
            
            <div class="form-container ">
                <form action="forgotpassword.jsp">
                    <h1>Enter registered email</h1>
                    <p>We shall mail you the password so that you can start using WePark again</p>                
                    <input type="email" placeholder="Enter your registered mail address" name="email"/><br>
                    <button name="submit">Submit</button>
                </form>
            </div>
            
        </div>
        
    </body>
</html>
<%

if (request.getParameter("submit")!=null)
{
	String email=request.getParameter("email");
	String password=null;

	ConnectionManager connectionManager=new ConnectionManager();
	Connection con=connectionManager.connectDB();
	
	try
	{
		PreparedStatement ps=con.prepareStatement("SELECT PASSWORD FROM WEPARKUSERS WHERE EMAIL = ?");
		ps.setString(1, email);
		
		ResultSet rs=ps.executeQuery();
		
		while(rs.next())
		{
			password=rs.getString("PASSWORD");
		}
		
		
		if(password!=null)		
		{
			//MAIL CODE
			
			//CREATING SECURE TOKEN
			//generate random alphanumberic string
			String SALTCHARS = "qwertyuiopasdfghjklzxcvbnmABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	        StringBuilder salt = new StringBuilder();
	        Random rnd = new Random();
	        while (salt.length() < 28) { // length of the random string.
	            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
	            salt.append(SALTCHARS.charAt(index));
	        }
	        String encToken = salt.toString();
			
			//INSERT into the pwd reset table
			PreparedStatement pstmt=con.prepareStatement("INSERT INTO WEPARK_PWDRESET (TIME, EMAIL, SECRETKEY, STATUS) VALUES(SYSDATE,?,?,SYSDATE+10/24/60)");
			pstmt.setString(1, email);
			pstmt.setString(2, encToken);
			pstmt.executeUpdate();
			
			//username and pass for gmail
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
				msg.setSubject("WePark Password Recovery Mail");
				msg.setContent("<!doctype html> <head> <meta charset="+"UTF-8"+"> <meta http-equiv="+"X-UA-Compatible"+" content="+"IE=edge"+"> <meta name="+"viewport"+" content="+"width=device-width, initial-scale=1"+"> <title>Reset Your WePark Password</title> <link href='https://fonts.googleapis.com/css?family=Asap:400,400italic,700,700italic' rel='stylesheet' type='text/css'> <style type="+"text/css"+">.button { display: block; width: 115px;margin:auto; height: 25px; background: #4890d9;color: #ffffff; padding: 10px; text-align: center;text-decoration:none; border-radius: 40px; font-weight: bold; } @media only screen and (min-width:768px){ .templateContainer{ width:600px !important; } } @media only screen and (max-width: 480px){ body,table,td,p,a,li,blockquote{ -webkit-text-size-adjust:none !important; } } @media only screen and (max-width: 480px){ body{ width:100% !important; min-width:100% !important; } } @media only screen and (max-width: 480px){ #bodyCell{ padding-top:10px !important; } } @media only screen and (max-width: 480px){ .mcnImage{ width:100% !important; } } @media only screen and (max-width: 480px){ .mcnCaptionTopContent,.mcnCaptionBottomContent,.mcnTextContentContainer,.mcnBoxedTextContentContainer,.mcnImageGroupContentContainer,.mcnCaptionLeftTextContentContainer,.mcnCaptionRightTextContentContainer,.mcnCaptionLeftImageContentContainer,.mcnCaptionRightImageContentContainer,.mcnImageCardLeftTextContentContainer,.mcnImageCardRightTextContentContainer{ max-width:100% !important; width:100% !important; } } @media only screen and (max-width: 480px){ .mcnBoxedTextContentContainer{ min-width:100% !important; } } @media only screen and (max-width: 480px){ .mcnImageGroupContent{ padding:9px !important; } } @media only screen and (max-width: 480px){ .mcnCaptionLeftContentOuter .mcnTextContent,.mcnCaptionRightContentOuter .mcnTextContent{ padding-top:9px !important; } } @media only screen and (max-width: 480px){ .mcnImageCardTopImageContent,.mcnCaptionBlockInner .mcnCaptionTopContent:last-child .mcnTextContent{ padding-top:18px !important; } } @media only screen and (max-width: 480px){ .mcnImageCardBottomImageContent{ padding-bottom:9px !important; } } @media only screen and (max-width: 480px){ .mcnImageGroupBlockInner{ padding-top:0 !important; padding-bottom:0 !important; } } @media only screen and (max-width: 480px){ .mcnImageGroupBlockOuter{ padding-top:9px !important; padding-bottom:9px !important; } } @media only screen and (max-width: 480px){ .mcnTextContent,.mcnBoxedTextContentColumn{ padding-right:18px !important; padding-left:18px !important; } } @media only screen and (max-width: 480px){ .mcnImageCardLeftImageContent,.mcnImageCardRightImageContent{ padding-right:18px !important; padding-bottom:0 !important; padding-left:18px !important; } } @media only screen and (max-width: 480px){ .mcpreview-image-uploader{ display:none !important; width:100% !important; } } @media only screen and (max-width: 480px){ h1{ font-size:20px !important; line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Heading 2 @tip Make the second-level headings larger in size for better readability on small screens. */ h2{ /*@editable*/font-size:20px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Heading 3 @tip Make the third-level headings larger in size for better readability on small screens. */ h3{ /*@editable*/font-size:18px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Heading 4 @tip Make the fourth-level headings larger in size for better readability on small screens. */ h4{ /*@editable*/font-size:16px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Boxed Text @tip Make the boxed text larger in size for better readability on small screens. We recommend a font size of at least 16px. */ .mcnBoxedTextContentContainer .mcnTextContent,.mcnBoxedTextContentContainer .mcnTextContent p{ /*@editable*/font-size:16px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Preheader Visibility @tip Set the visibility of the email's preheader on small screens. You can hide it to save space. */ #templatePreheader{ /*@editable*/display:block !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Preheader Text @tip Make the preheader text larger in size for better readability on small screens. */ #templatePreheader .mcnTextContent,#templatePreheader .mcnTextContent p{ /*@editable*/font-size:12px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Header Text @tip Make the header text larger in size for better readability on small screens. */ #templateHeader .mcnTextContent,#templateHeader .mcnTextContent p{ /*@editable*/font-size:16px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Body Text @tip Make the body text larger in size for better readability on small screens. We recommend a font size of at least 16px. */ #templateBody .mcnTextContent,#templateBody .mcnTextContent p{ /*@editable*/font-size:16px !important; /*@editable*/line-height:150% !important; } } @media only screen and (max-width: 480px){ /* @tab Mobile Styles @section Footer Text @tip Make the footer content text larger in size for better readability on small screens. */ #templateFooter .mcnTextContent,#templateFooter .mcnTextContent p{ /*@editable*/font-size:12px !important; /*@editable*/line-height:150% !important; } } </style> </head> <body style="+"-ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: #FF416C; height: 100%; margin: 0; padding: 0; width: 100%"+"> <center> <table align="+"center"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" height="+"100%"+" id="+"bodyTable"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: #FF416C; height: 100%; margin: 0; padding: 0; width: 100%"+" width="+"100%"+"> <tr> <td align="+"center"+" id="+"bodyCell"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-top: 0; height: 100%; margin: 0; padding: 0; width: 100%"+" valign="+"top"+"> <!-- BEGIN TEMPLATE // --> <!--[if gte mso 9]> <table align="+"center"+" border="+"0"+" cellspacing="+"0"+" cellpadding="+"0"+" width="+"600"+" style="+"width:600px;"+"> <tr> <td align="+"center"+" valign="+"top"+" width="+"600"+" style="+"width:600px;"+"> <![endif]--> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"templateContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; max-width: 600px; border: 0"+" width="+"100%"+"> <tr> <td id="+"templatePreheader"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: #FF416C; border-top: 0; border-bottom: 0; padding-top: 16px; padding-bottom: 8px"+" valign="+"top"+"> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnTextBlockOuter"+"> <tr> <td class="+"mcnTextBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%"+" valign="+"top"+"> <table align="+"left"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextContentContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody> <tr> <td class="+"mcnTextContent"+" style='mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; word-break: break-word; color: #2a2a2a; font-family: "+"Asap"+", Helvetica, sans-serif; font-size: 12px; line-height: 150%; text-align: left; padding-top:9px; padding-right: 18px; padding-bottom: 9px; padding-left: 18px;' valign="+"top"+"> <a href="+"https://www.lingoapp.com"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; color: #2a2a2a; font-weight: normal; text-decoration: none"+" target="+"_blank"+" title="+"Lingo is the best way to organize, share and use all your visual assets in one place - all on your desktop."+"> <img align="+"none"+" height="+"52"+" src="+"https://lh3.googleusercontent.com/fqzvviJbpme1VhUuigAIe6Cof4pajqmDPbqbVieRwpDJCRc4LobUFHM18C9XbJOMbgc2jWqLWtHpCFRaqUOkKI0JV4O-1uVewK1GrqS-c9ygUz9Di7KHuKkNSi1BpUWQb5_Z6jnG3Bu29VAI8FtvJkBwhG7Ny5hpFbaoZKiXLyHP7tc3nl4wRpyY7x3gwGAVFVi1xX4jF2q-J5jSPP53kxS8cB6HLZUdbaF64hr9PT1vwOeCFvBjBK_eD9sx9A54H_RoABRNXctdC2tBamKMbKzjsVmajVSugfxlb7OZT9WqobLViCsGz2GLOs2ASW6giySpsqdsg-RZQv-GZExV26HdAQmID26SV_rwozBZIIE_RwN2xf-7fQFSkoeaokRGQ_VZkvk91lICXpn228B53Edj7YfcS398sSm3TGuNVAZrZOgnDuQ6VYgJ-mmboAB0V2A5cibBA9Z2YyxPWATW7639kgJ-AqKkdlU4rzLpsUFx5aIYZfITC0pQvh6CTy3KLTwS4heZLVrZK_eHtmbUwKVUq3p2mjXrzWXR7QZu3pNNjxc1kBEY6yVbaJZT7iHfbf5WgX8ftuJb-i7pLsDgGHQFqS7O14gtcqaiaIRg6rI59EKaKmyTUPAZGcdZ9azIWAj0vOhP_CBbj3cvlStTIMgFX6_5oUUePfymMmDocykmmH1wN40mTvqNLg_rHSQ=w328-h100-no"+" style="+"-ms-interpolation-mode: bicubic; border: 0; outline: none; text-decoration: none; height: auto; width: 157px; height: 52px; margin: 0px;"+" width="+"157"+" /> </a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> <tr> <td id="+"templateHeader"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: #f7f7ff; border-top: 0; border-bottom: 0; padding-top: 16px; padding-bottom: 0"+" valign="+"top"+"> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnImageBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnImageBlockOuter"+"> <tr> <td class="+"mcnImageBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding:0px"+" valign="+"top"+"> <table align="+"left"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnImageContentContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody> <tr> <td class="+"mcnImageContent"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-right: 0px; padding-left: 0px; padding-top: 0; padding-bottom: 0; text-align:center;"+" valign="+"top"+"> <a class="+""+" href="+"https://www.lingoapp.com"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; color: #f57153; font-weight: normal; text-decoration: none"+" target="+"_blank"+" title="+""+"> <a class="+""+" href="+"https://www.lingoapp.com/"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; color: #f57153; font-weight: normal; text-decoration: none"+" target="+"_blank"+" title="+""+"> <img align="+"center"+" alt="+"Forgot your password?"+" class="+"mcnImage"+" src="+"https://static.lingoapp.com/assets/images/email/il-password-reset@2x.png"+" style="+"-ms-interpolation-mode: bicubic; border: 0; height: auto; outline: none; text-decoration: none; vertical-align: bottom; max-width:1200px; padding-bottom: 0; display: inline !important; vertical-align: bottom;"+" width="+"600"+"></img> </a> </a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> <tr> <td id="+"templateBody"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: #f7f7ff; border-top: 0; border-bottom: 0; padding-top: 0; padding-bottom: 0"+" valign="+"top"+"> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnTextBlockOuter"+"> <tr> <td class="+"mcnTextBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%"+" valign="+"top"+"> <table align="+"left"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextContentContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody> <tr> <td class="+"mcnTextContent"+" style='mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; word-break: break-word; color: #2a2a2a; font-family: "+"Asap"+", Helvetica, sans-serif; font-size: 16px; line-height: 150%; text-align: center; padding-top:9px; padding-right: 18px; padding-bottom: 9px; padding-left: 18px;' valign="+"top"+"> <h1 class="+"null"+" style='color: #2a2a2a; font-family: "+"Asap"+", Helvetica, sans-serif; font-size: 32px; font-style: normal; font-weight: bold; line-height: 125%; letter-spacing: 2px; text-align: center; display: block; margin: 0; padding: 0'><span style="+"text-transform:uppercase"+">Forgot</span></h1> <h2 class="+"null"+" style='color: #2a2a2a; font-family: "+"Asap"+", Helvetica, sans-serif; font-size: 24px; font-style: normal; font-weight: bold; line-height: 125%; letter-spacing: 1px; text-align: center; display: block; margin: 0; padding: 0'><span style="+"text-transform:uppercase"+">your password?</span></h2> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnTextBlockOuter"+"> <tr> <td class="+"mcnTextBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%"+" valign="+"top"+"> <table align="+"left"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextContentContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody> <tr> <td class="+"mcnTextContent"+" style='mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; word-break: break-word; color: #2a2a2a; font-family: "+"Asap"+", Helvetica, sans-serif; font-size: 16px; line-height: 150%; text-align: center; padding-top:9px; padding-right: 18px; padding-bottom: 9px; padding-left: 18px;' valign="+"top"+">Not to worry, we got you! Click on the button below to change your password for WePark. <br></br> <br></br> <a href="+"http://localhost:8088/WePark/verifyToken.jsp?token="+encToken+" class="+"button"+">Reset</a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnButtonBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnButtonBlockOuter"+"> <tr> <td align="+"center"+" class="+"mcnButtonBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top:18px; padding-right:18px; padding-bottom:18px; padding-left:18px;"+" valign="+"top"+"> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnButtonBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnButtonBlockOuter"+"> <tr> <td align="+"center"+" class="+"mcnButtonBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top:0; padding-right:18px; padding-bottom:18px; padding-left:18px;"+" valign="+"top"+"> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnButtonContentContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; border-collapse: separate !important;border-radius: 48px;background-color: #F57153;"+"> <tbody> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnImageBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnImageBlockOuter"+"> <tr> <td class="+"mcnImageBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding:0px"+" valign="+"top"+"> <table align="+"left"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnImageContentContainer"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody> <tr> <td class="+"mcnImageContent"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-right: 0px; padding-left: 0px; padding-top: 0; padding-bottom: 0; text-align:center;"+" valign="+"top"+"></td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> <tr> <td id="+"templateFooter"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: #FF416C; border-top: 0; border-bottom: 0; padding-top: 8px; padding-bottom: 80px"+" valign="+"top"+"> <table border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" class="+"mcnTextBlock"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody class="+"mcnTextBlockOuter"+"> <tr> <td class="+"mcnTextBlockInner"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%"+" valign="+"top"+"> <table align="+"center"+" bgcolor="+"#F7F7FF"+" border="+"0"+" cellpadding="+"32"+" cellspacing="+"0"+" class="+"card"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background: #000000;; margin:auto; text-align:left; max-width:600px; font-family: 'Asap', Helvetica, sans-serif;"+" text-align="+"left"+" width="+"100%"+"> </table> <table align="+"center"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; min-width:100%;"+" width="+"100%"+"> <tbody> <tr> <td style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; padding-top: 24px; padding-right: 18px; padding-bottom: 24px; padding-left: 18px; color: #7F6925; font-family: 'Asap', Helvetica, sans-serif; font-size: 12px;"+" valign="+"top"+"> <div style="+"text-align: center; columns: #000000; ;"+">Developed by <a href="+"https://thenounproject.com/"+" style="+"mso-line-height-rule: exactly; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; color: #f57153; font-weight: normal; text-decoration: none; columns: #000000;;"+" target="+"_blank"+" title="+"Noun Project - Icons for Everything"+">WePark</a> in Kristu Jayanti College, BLR 560043</div> </td> </tr> <tbody></tbody> </tbody> </table> <table align="+"center"+" border="+"0"+" cellpadding="+"12"+" style="+"border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; "+"> <tbody> <tr> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </table> </td> </tr> </table> </center> </body> </html>","text/html" );
				Transport.send(msg);
				//out.print("Sent!");
				//response.sendRedirect("location='http://localhost:8088/WePark/signUpLogin.html';");
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Check your mail for the password.');");
				out.println("location='http://localhost:8088/WePark/signUpLogin.html';");
				out.println("</script>");
			}
			catch(Exception e)
			{
				System.out.println(e);
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Error in Sending Mail! Try again later.');");
				out.println("location='http://localhost:8088/WePark/signUpLogin.html';");
				out.println("</script>");
			}
			
		}
		else
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('User not registered with WePark. Please Register!');");
			out.println("location='http://localhost:8088/WePark/signUpLogin.html';");
			out.println("</script>");
		}
		
		
	}
	catch(Exception e)
	{
		out.print(e);
	}
}


%>