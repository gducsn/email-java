![output](https://user-images.githubusercontent.com/94108883/174633306-77e56ead-c915-4b2f-9d69-8cc755e44a20.gif)

# Email Form

Pagina per poter inviare email.

Sono presenti due classi principali e due pagine JSP.

La prima classe ci permette di configurare le proprietà del server SMPT, 
creare l’autorizzazione, configurare il MIME, definire l’email vera e 
propria e infine inviarla.

La seconda classe, il servlet, ci serve per recuperare le informazioni dal 
form, aggiungerle al metodo della prima classe, gestire l’azione 
dell’utente e gestire le possibili eccezioni.

Quello che ci serve fare:

- Dobbiamo configurare gmail. La prima cosa è andare nelle impostazioni, 
inoltro e POP/IMAP e attivare l’accesso IMAP.
- Successivamente dobbiamo attivare l’autenticazione a due fattori attiva 
e creare una nuova password app. Questa password ci serve per poter 
accedere dopo.
- Dobbiamo importare nella sottocartella WEB-INF/LIB del nostro progetto 
due librerie:
- 
[activation](https://www.oracle.com/java/technologies/java-beans-activation.html)
- [javax.mail](https://javaee.github.io/javamail/)
- Ora dobbiamo aggiungere il file ‘web.xml’ nel quale possiamo inserire le 
nostre credenziali per l’accesso. Si crea facilmente facendo tasto destro 
su ‘**Deployment Descriptor’** e cliccando su ‘**Generate Deployment 
Descriptor Stub’.** Una volta fatto si creerà automaticamente il file 
web.xml nella directory /webapp.

---

Configurare web.xml:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns="http://xmlns.jcp.org/xml/ns/javaee" 
xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" version="4.0">
  
  
  <welcome-file-list>
    <welcome-file>FormEmail.jsp</welcome-file>
  </welcome-file-list>
  
	<context-param>
		<param-name>username</param-name>
		<param-value> email </param-value>
	</context-param>

	<context-param>
		<param-name>password</param-name>
		<param-value> app password google </param-value>
	</context-param>

  
  
</web-app>
```

Il file web.xml è utile come descrittore e contenitore. Abbiamo definito 
al suo interno l’home page, cioè quale pagina verrà caricata fin da 
subito, nel tag ‘welcome-file-list’.

Successivamente abbiamo definito nel tag ‘context-param’, username e 
password per poter accedere al nostro servizio email, nel nostro caso 
google.

---

Classe CreateEmail

```java
package emails;

import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class CreateEmail {
	public static void sendEmail(final String userName, final String 
password, String toAddress, String subject,
			String message) throws AddressException, 
MessagingException {

		// sets SMTP server properties

		Properties properties = new Properties();
		properties.put("mail.smtp.host", "smtp.gmail.com");
		properties.put("mail.smtp.port", 587);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");

		// creates a new session with an authenticator
		Authenticator auth = new Authenticator() {
			public PasswordAuthentication 
getPasswordAuthentication() {
				return new 
PasswordAuthentication(userName, password);
			}
		};

		Session session = Session.getInstance(properties, auth);

		// creates a new e-mail message
		Message msg = new MimeMessage(session);

		msg.setFrom(new InternetAddress(userName));
		InternetAddress[] toAddresses = { new 
InternetAddress(toAddress) };
		msg.setRecipients(Message.RecipientType.TO, toAddresses);
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		msg.setText(message);

		// sends the e-mail
		Transport.send(msg);

	}
}
```

La classe ‘CreateEmail’ contiene il metodo che ci permette di creare e 
inviare l’email.

```java
		Properties properties = new Properties();
		properties.put("mail.smtp.host", "smtp.gmail.com");
		properties.put("mail.smtp.port", 587);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
```

La prima cosa fare è configurare il server SMPT creando un nuovo oggetto 
dalla classe Properties.

Con il metodo .put() inseriamo le proprietà. Il primo argomento è la 
chiave e il secondo è il valore.

- host: server che invierà l’email
- port: porta di connessione al server
- auth: autenticazione richiesta
- starttls.enable: ci permette di informare il server di voler passare da 
una connessione non sicura ad una sicura.

Abbiamo a disposizione l’oggetto configurato che ci permette la 
connessione. Adesso dobbiamo crearne un altro che ci permette 
l’autorizzazione.

```java
Authenticator auth = new Authenticator() {
			public PasswordAuthentication 
getPasswordAuthentication() {
				return new 
PasswordAuthentication(userName, password);
			}
		};
```

La classe 
[Authenticator](https://docs.oracle.com/javase/8/docs/api/java/net/Authenticator.html) 
rappresenta un oggetto che sa come ottenere l’autorizzazione per una 
connessione. Al suo interno troviamo innestato un altro metodo che accetta 
due parametri: username e password.

Questi due parametri sono stati definiti all’interno della pagine web.xml 
e li gestiremo nel servlet. 

Una volta configurato il server SMPT e l’autorizzazione dobbiamo creare 
una sessione. 

```java
Session session = Session.getInstance(properties, auth);
```

‘Session’ rappresenta una sessione di posta e raccoglie proprietà poi 
utilizzate dall’API email.

Al metodo .getInstance() passiamo due argomenti, le nostre proprietà e la 
nostra autenticazione.

Adesso possiamo dare vita alla nostra email.

```java
		Message msg = new MimeMessage(session);

		msg.setFrom(new InternetAddress(userName));
		InternetAddress[] toAddresses = { new 
InternetAddress(toAddress) };
		msg.setRecipients(Message.RecipientType.TO, toAddresses);
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		msg.setText(message);

		// sends the e-mail
		Transport.send(msg);
```

La classe 
[Message](https://docs.oracle.com/javaee/7/api/javax/mail/Message.html) ci 
permette di modellare il nostro messaggio.

Per prima cosa dobbiamo definire il tipo di messaggio nella configurazione 
**[MIME](https://www.sinte.net/files/help/altri.htm).** 

Una volta definito abbiamo a disposizione altri metodi per configurare al 
meglio la nostra email.

Il metodo .setFrom definisce da chi è stato inviato il messaggio. Al suo 
interno istanziamo un nuovo oggetto 
[InternetAddress](https://docs.oracle.com/javaee/6/api/javax/mail/internet/InternetAddress.html) 
passando l’email di chi invia il messaggio.

La classe InternetAddress rappresenta proprio l’indirizzo email. Nel 
.setFrom() quindi definiamo chi invia, mentre nell’array ‘toAddresses’ 
tutti i possibili riceventi.

La classe message ha vari metodi per configurare l’invio vero e proprio.

Il metodo ‘setRecipients’ ci permette di definire a chi verrà inviato il 
messaggio. La lista delle emails è il secondo argomento.

`setSubject(subject)` = definisce l’oggetto della mail.

`setSentDate(new Date())` = definisce la data di invio.

`setText(message)` = definisce il messaggio.

Infine per inviare il messaggio utilizziamo la classe 
[Transport](https://docs.oracle.com/javaee/7/api/javax/mail/Transport.html) 
con il suo metodo send.

---

Servlet SendEmail

```java
package emails;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/sent")
public class SendEmail extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private String user;
	private String pass;

	public void init() {
		// reads SMTP server setting from web.xml file
		ServletContext context = getServletContext();
		user = context.getInitParameter("username");
		pass = context.getInitParameter("password");
	}

	protected void doPost(HttpServletRequest request, 
HttpServletResponse response)
			throws ServletException, IOException {

		String recipient = request.getParameter("recipient");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");

		String message = "";

		try {
			CreateEmail.sendEmail(user, pass, recipient, 
subject, content);
			message = "The e-mail was sent successfully";
		} catch (Exception ex) {
			ex.printStackTrace();
			message = "There were an error: " + 
ex.getMessage();
		} finally {
			request.setAttribute("Message", message);
			
getServletContext().getRequestDispatcher("/ResultPage.jsp").forward(request, 
response);
		}
	}
}
```

Nel servlet utilizziamo il metodo 
[init](https://docs.oracle.com/javaee/6/api/javax/servlet/Servlet.html#:~:text=init,-void%20init(ServletConfig&text=config)%20throws%20ServletException-,Called%20by%20the%20servlet%20container%20to%20indicate%20to%20a%20servlet,servlet%20can%20receive%20any%20requests.)() 
per poter prelevare fin da subito i valori contenuti nel file web.xml.

```java
	private String user;
	private String pass;

	public void init() {
		// reads SMTP server setting from web.xml file
		ServletContext context = getServletContext();
		user = context.getInitParameter("username");
		pass = context.getInitParameter("password");
	}
```

Tramite l’interfaccia 
[ServletContext](https://docs.oracle.com/javaee/6/api/javax/servlet/ServletContext.html) 
recuperiamo il contesto del servlet e successivamente quello che ci serve 
per definire l’username e password.

I valori li recuperiamo dalla pagina web.xml definiti all’inizio, il 
contesto si riferisce proprio a questa pagina.

Ora abbiamo le nostre credenziali e possiamo gestire la chiamata post che 
avviene quando l’utente clicca sul form.

```java
protected void doPost(HttpServletRequest request, HttpServletResponse 
response)
			throws ServletException, IOException {

		String recipient = request.getParameter("recipient");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");

		String message = "";

		try {
			CreateEmail.sendEmail(user, pass, recipient, 
subject, content);
			message = "The e-mail was sent successfully";
		} catch (Exception ex) {
			ex.printStackTrace();
			message = "There were an error: " + 
ex.getMessage();
		} finally {
			request.setAttribute("Message", message);
			
getServletContext().getRequestDispatcher("/ResultPage.jsp").forward(request, 
response);
		}
	}
```

Fin da subito ci interessa recuperare i valori nel form, lo facciamo 
utilizzando il metodo .getParameter();

In seguito creiamo una nuova stringa che ci servirà per descrivere il 
successo o meno dell’invio.

Utilizziamo il blocco try-catch-finally per gestire eventuali eccezioni.

Nel blocco try inseriamo il metodo sendEmail con tutti gli argomenti 
richiesti e modifichiamo il messaggio per mostrare l’avvenuto successo.
Nel blocco catch stampiamo l’errore e lo riportiamo nel messaggio.

Nel blocco finally, che è il blocco che verrà eseguito a prescindere alla 
fine, creiamo un nuovo attributo contenente il messaggio e lo passiamo 
alla pagina successiva con il dispatcher.

---

Pagina Form

```java
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet"
	
href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
	
	<link rel="icon" type="image/x-icon" 
href="https://img.icons8.com/ios/344/circled-envelope.png">
	
<title>Send an e-mail</title>
</head>
<body>
	<div class="d-flex justify-content-center align-items-center p-5">

		<form action="sent" method="post" class="form-group">
			<div class="form-group">
				<label for="exampleInputEmail1">Email 
address</label> <input placeholder="Address to send to" required
					name="recipient" type="email" 
class="form-control"
					id="exampleInputEmail1">
			</div>
			<div class="form-group">
				<label 
for="exampleInputPassword1">Subject</label> <input placeholder="Subject"
					name="subject" type="text" 
class="form-control"
					id="exampleInputPassword1">
			</div>
			<div class="form-group">
				<textarea rows="8" cols="39" 
name="content" name="content" placeholder="Content"></textarea>
			</div>
			<button type="submit" class="btn btn-primary 
btn-dark w-100">Submit</button>
		</form>
	</div>
</body>
</html>
```

Questa pagina JSP contiene il form che l’utente compila per poter inviare 
l’email. I campi di input e testo hanno un attributo ‘name’. Ci riferiamo 
a questo attributo quando nel servlet vogliamo recuperare i valori dei 
vari input.

---

Result Page

```java
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" 
href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
<link rel="icon" type="image/x-icon" 
href="https://img.icons8.com/ios/344/circled-envelope.png">
<title>Result</title>
</head>
<body>
<div class="d-flex justify-content-center p-5 align-items-center">
		<h3 class="h-3 
lead"><%=request.getAttribute("Message")%></h3>
	</div>
</body>
</html>
```

La pagina non fa altro che mostrare il messaggio creato nel servlet in 
base al risultato finale.
