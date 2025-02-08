# BillieProject

Go to Salesforce Developer Signup and create a fresh Developer org.
Use a generic email ID if possible (e.g., submission-specific email like yourname+challenge@gmail.com).
Set Up the Org:

Deploy the solution to the new org.
The repository contains service class, queuable class, schedular, named credentials and lwc components.
Ensure to add the endpoint url in remote site settings.
Create an App Page/Record Page/Home Page and add the LWC component in it.
For testing purposes, I created an App page.
Open the anonymous window, and write the following command to hit the endpoint:
->If you want to hit the enpoint instantly:
new MostPublishedBooksScheduler().execute(null); 
OR
String jobId = System.schedule('Test MostPublishedBooksScheduler', '0 0 12 * * ?', new MostPublishedBooksScheduler()); //Best way to call.

->If you want to hit the endpoint after sometime. For example, 10 minutes:
Integer minutesFromNow = 10;
String cronExp = System.now().addMinutes(minutesFromNow).format('s m H d M ? yyyy');
System.schedule('Fetch Most Published Books', cronExp, new MostPublishedBooksScheduler());

After hitting the endpoint, refresh the App Page that has been created. The list of books with latest edition details in sorted manner will appear.
The output should look like the image below:

![image](https://github.com/user-attachments/assets/f0b881f0-db8a-4c7f-892f-fd4e47d4e043)


