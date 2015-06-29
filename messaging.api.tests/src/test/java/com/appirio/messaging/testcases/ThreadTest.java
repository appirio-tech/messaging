package com.appirio.messaging.testcases;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.GeneralSecurityException;
import java.security.KeyStoreException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.appirio.automation.api.DefaultRequestProcessor;
import com.appirio.automation.api.config.AuthenticationConfiguration;
import com.appirio.automation.api.config.EnvironmentConfiguration;
import com.appirio.automation.api.config.MessagingConfiguration;
import com.appirio.automation.api.config.UserConfiguration;
import com.appirio.automation.api.dataprovider.DefaultDataProvider;
import com.appirio.automation.api.exception.AutomationException;
import com.appirio.automation.api.exception.InvalidRequestException;
import com.appirio.automation.api.model.AuthenticationInfo;
import com.appirio.automation.api.model.ThreadInfo;
import com.appirio.automation.api.model.UserInfo;
import com.appirio.automation.api.service.AuthenticationService;
import com.appirio.automation.api.util.ApiUtil;

public class ThreadTest {


	private AuthenticationService  authService;
	private List<UserInfo> publishersList = null;
	private List<UserInfo> subscribersList = null;
	private DefaultDataProvider defaultDataProvider = null;
	private ThreadInfo threadInfo = null;

	@BeforeClass
	public void setUp() throws ParseException, AutomationException, IOException, KeyStoreException, GeneralSecurityException, URISyntaxException  {
		EnvironmentConfiguration.initialize();
		AuthenticationConfiguration.initialize();
		UserConfiguration.initialize();
		MessagingConfiguration.initialize();
		authService = new AuthenticationService();
		defaultDataProvider = new DefaultDataProvider();
		publishersList = createUsers(defaultDataProvider.getUsersData(2));
		System.out.println("ThreadsTest:setUpTestData: " + publishersList.size() + " Publishers created!");
		subscribersList = createUsers(defaultDataProvider.getUsersData(2));
		System.out.println("ThreadsTest:setUpTestData: " + subscribersList.size() + " Subscribers created! " );

	}

	//@BeforeMethod
	//public void setUpTestData() {

	//}

	private List<UserInfo> createUsers(List<JSONObject> usersJsonList) throws AutomationException, ParseException, IOException, KeyStoreException, GeneralSecurityException, URISyntaxException {
		List<UserInfo> userList = new ArrayList<UserInfo>();
		for(JSONObject userJson :usersJsonList) {
			UserInfo user = createUser(userJson);
			userList.add(user);
		}
		return userList;
	}

	//@todo  this method should go to UserService munmun pls do that !
	private UserInfo createUser(JSONObject userJson) throws AutomationException, ParseException, IOException, KeyStoreException, GeneralSecurityException, URISyntaxException {
		UserInfo userInfo = null;
		AuthenticationInfo authInfo = authService.authenticate();
		System.out.println("UserTest:testCreateUser:authentication jwt token" + authInfo.getJwtToken());

		String userCreateEndPointUrl = EnvironmentConfiguration.getBaseUrl() 
				+UserConfiguration.getUserCreateEndPoint();

		List<NameValuePair> headers = new ArrayList<NameValuePair>();
		headers.add(new BasicNameValuePair(HttpHeaders.CONTENT_TYPE, "application/json"));
		headers.add(new BasicNameValuePair("Authorization", "Bearer "+ authInfo.getJwtToken()));

		System.out.println("ThreadsTest:createUser:Sending post request to url " +
				userCreateEndPointUrl  + " params" + userJson.toString() + " jwt token " + 
				authInfo.getJwtToken());

		HttpResponse response  = null;

		response = DefaultRequestProcessor.postRequest(userCreateEndPointUrl,null, 
				headers,userJson.toString());
		if(response.getStatusLine().getStatusCode() == 200)
			userInfo = new UserInfo(response);
		else if(response.getStatusLine().getStatusCode() == 400)
			throw new AutomationException(String.valueOf(response.getStatusLine().getStatusCode()), "No parameter : 400 Bad Request. User creation failed !");
		else if(response.getStatusLine().getStatusCode() == 401) 
			throw new AutomationException(String.valueOf(response.getStatusLine().getStatusCode()), "Invalid parameter : 401 Unauthorized. User creation failed !");

		System.out.println("ThreadsTest:createUser: Response code obtained " + response.getStatusLine().getStatusCode());
		System.out.println("UserService:createUsers:User with Id " + userInfo.getUserId() + " created !!");



		return userInfo;
	}

	/**
	 * Create a thread.A thread object has the following attributes
	 * clientIdentifier -a unique identifier coming from the consumer of the Messaging Service.
	 * The combination of clientIdentifier and the list of Publishers make up the unique key that 
	 * identifies a ThreadId
	 * context - context refers to a string identifier on which this message is being posted, 
	 * if the message is posted as a generic one on the project then it has a context of 'work'
	 * subject - This is the subject for a threaded message. Typically this will be the Project Title in our use case.
	 * publishers - list of user identifiers who have the ability to publish to this thread. This will be the 
	 * numeric id for a user
	 * subscribers - list of the user identifiers who have the ability to read from a thread. This will be the
	 * numeric id for a user
	 * @return 
	 * @throws AutomationException 
	 * @throws InvalidRequestException 
	 * @throws IOException 
	 * @throws ParseException 
	 */

	@Test(priority = 1, testName = "Create Thread", description = "Test Create Thread api")

	public void testCreateThread() throws AutomationException, InvalidRequestException, ParseException, IOException {
		if(publishersList == null ) throw new InvalidRequestException("Publishers must be available to create a thread");
		if(subscribersList == null ) throw new InvalidRequestException("Subscribers must be available to create a thread");

		for(UserInfo user : publishersList) {
			System.out.println("ThreadsTest:testCreateThread:publisher Id " + user.getUserId());
		}
		for(UserInfo user : subscribersList) {
			System.out.println("ThreadsTest:testCreateThread:subscriber Id " + user.getUserId());
		}

		String payload = constructPayload();
		System.out.println("ThreadTest:createThreadTest:payload "  +payload);

		AuthenticationInfo authInfo = authService.authenticate();
		System.out.println("ThreadsTest:createThreadTest:authentication jwt token" + authInfo.getJwtToken());

		HttpResponse response  = null;

		try {
			String threadCreateEndPointUrl = EnvironmentConfiguration.getBaseUrl() 
					+MessagingConfiguration.getThreadCreateEndPoint();

			List<NameValuePair> headers = new ArrayList<NameValuePair>();
			headers.add(new BasicNameValuePair(HttpHeaders.CONTENT_TYPE, "application/json"));
			headers.add(new BasicNameValuePair("Authorization", "Bearer "+ authInfo.getJwtToken()));

			System.out.println("ThreadTest:createThreadTest:Sending post request to url " +
					threadCreateEndPointUrl  + " payload" + payload  + " jwt token " + 
					authInfo.getJwtToken());

			response = DefaultRequestProcessor.postRequest(threadCreateEndPointUrl,null, 
					headers,payload);
		}catch(ParseException pe) {
			//log
			System.out.println("ThreadsTest:createUser:Parse exception occurred while creating user "+ pe.getMessage() );
			throw new AutomationException(pe);
		}catch(URISyntaxException uri) {
			System.out.println("ThreadsTest:URI Syntax exception occurred while creating user "+ uri.getMessage() );
			throw new AutomationException(uri);
		}catch(IOException ioe) {
			System.out.println("ThreadsTest:IO exception occurred while creating user "+ ioe.getMessage() );
			throw new AutomationException(ioe);
		}catch (KeyStoreException ke) {
			System.out.println("ThreadsTest:KeyStoreException occurred while creating user "+ ke.getMessage() );
			throw new AutomationException(ke);
		} catch (GeneralSecurityException ge) {
			System.out.println("ThreadsTest:GeneralSecurityException occurred while creating user "+ ge.getMessage() );
			throw new AutomationException(ge);
		}

		System.out.println("ThreadsTest:createUser: Response code obtained " + response.getStatusLine().getStatusCode());

		if(response.getStatusLine().getStatusCode() == 200)
			threadInfo = new ThreadInfo(response);
		else if(response.getStatusLine().getStatusCode() == 400)
			throw new AutomationException(String.valueOf(response.getStatusLine().getStatusCode()), "No parameter : 400 Bad Request. User creation failed !");
		else if(response.getStatusLine().getStatusCode() == 401) 
			throw new AutomationException(String.valueOf(response.getStatusLine().getStatusCode()), "Invalid parameter : 401 Unauthorized. User creation failed !");

		System.out.println("ThreadsTest:createThreadTest:Thread with Id " + threadInfo.getThreadId() + " created !!");

	}

	@Test(priority = 2, testName = "GET Thread by ID", description = "Test GET Thread by id api")
	public void testGetThread() throws ClientProtocolException, URISyntaxException, IOException, ParseException, AutomationException{
		//Generate jwt token
		AuthenticationInfo authInfo = authService.authenticate();
		System.out.println("ThreadsTest:testGetThread: jwt token" + authInfo.getJwtToken() +  " Thread Id " + 
				threadInfo.getThreadId());
		List<NameValuePair> headers = new ArrayList<NameValuePair>();
		headers.add(new BasicNameValuePair("Authorization","Bearer "+ authInfo.getJwtToken()));
		String subscriberId = subscribersList.get(0).getUserId();
		System.out.println("ThreadsTest:testGetThread: subscriberId " + subscriberId);
		String getThreadUrl = EnvironmentConfiguration.getBaseUrl() +MessagingConfiguration.getThreadGetEndPoint()
				+ threadInfo.getThreadId() + "?subscriberId=" +subscriberId;
		System.out.println("ThreadsTest:testGetThread: Sending Get request to url " +
				getThreadUrl  );

		HttpResponse response = null;
		try {
			response = DefaultRequestProcessor.getRequest(getThreadUrl , null, headers);
			System.out.println("ThreadsTest:testGetThread:  Response code obtained " +
					response.getStatusLine().getStatusCode());
			JSONObject jsonObject = ApiUtil.getJsonObject(response);

			String threadId2 = jsonObject.getJSONObject("result").getJSONObject("content").getString("id");
			System.out.println(" *******jsonObject. content " + 
					jsonObject.getJSONObject("result") + "    threadId " +threadId2);
			Assert.assertEquals(threadId2, threadInfo.getThreadId());
		}catch (IOException e) {
			System.out.println("ThreadsTest:testGetThread: IO Exception occurred while getting thread "+ e.getMessage() );
			throw new AutomationException(e);
		}

	} 


	private String constructPayload() {
		JSONObject mainObject = new JSONObject();

		mainObject.put("clientIdentifier", subscribersList.get(0).getUserId());
		mainObject.put("context", getContext());
		mainObject.put("subject", getSubject());
		JSONArray pubArr = new JSONArray();
		for(UserInfo publisher : publishersList) {
			pubArr.put(publisher.getUserId());
		}
		mainObject.put("publishers", pubArr);

		JSONArray subsArr = new JSONArray();
		for(UserInfo subscriber : subscribersList) {
			subsArr.put(subscriber.getUserId());
		}
		mainObject.put("subscribers", subsArr);

		return mainObject.toString();

	}


	private String getSubject() {
		return "My Test project";


	}

	private String getContext() {
		return "work";

	}


	@AfterClass
	public void tearDown() {
		//delete the users created
		//delete the thread
	}


	@AfterMethod
	public void afterMethod() {
	}





}
