package com.appirio.messaging.testcases;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
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
import com.appirio.automation.api.exception.AutomationException;
import com.appirio.automation.api.exception.InvalidRequestException;
import com.appirio.automation.api.model.AuthenticationInfo;
import com.appirio.automation.api.model.ThreadInfo;
import com.appirio.automation.api.model.UserInfo;
import com.appirio.automation.api.service.AuthenticationService;
import com.appirio.automation.api.service.UserService;
import com.appirio.automation.api.util.ApiUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Tests end points pertaining to Thread(Inbox)
 * @author anjalijain
 *
 */
public class ThreadTest {

	private AuthenticationService  authService;
	private UserService userService;
	private ThreadInfo threadInfo = null;
	private JsonNode threadsNode = null;
	
	private Map<String,List<UserInfo>> allThreadsPublishers = null;
	private Map<String,List<UserInfo>> allThreadsSubscribers= null;
	private AuthenticationInfo authInfo = null;
	private final String USER_TYPE_PUBLISHER = "publishers";
	private final String USER_TYPE_SUBSCRIBER = "subscribers";
	

	/**
	 * Initializes the test environment. Reads thread.json
	 * @throws Exception
	 */
	@BeforeClass
	public void setUp() throws Exception  {
		EnvironmentConfiguration.initialize();
		AuthenticationConfiguration.initialize();
		UserConfiguration.initialize();
		MessagingConfiguration.initialize();
		authService = new AuthenticationService();
		userService = new UserService();
		String jsonFile = getFile("thread.json");
		JsonNode rootNode = ApiUtil.readJsonFromFile(jsonFile);
		threadsNode = rootNode.get("threads");
		
		authInfo = authService.authenticate();
		System.out.println("ThreadsTest:setUp:authentication jwt token" + authInfo.getJwtToken());

	}
	
	public String getFile(String fileName) {
		  String jsonContents = "";
	 	  ClassLoader classLoader = getClass().getClassLoader();
		  try {
			  jsonContents = IOUtils.toString(classLoader.getResourceAsStream(fileName));
		  } catch (IOException e) {
			 throw new AutomationException("Some error occurred while reading thread.json " 
					 	+ e.getLocalizedMessage());
		  }
		  return jsonContents;
	  }
	
	public  List<com.fasterxml.jackson.databind.JsonNode> getNodeElements(JsonNode parentNode) {
		Iterator<JsonNode> elements = parentNode.elements();
		while(elements.hasNext()){
		    JsonNode childNode = elements.next();
		    System.out.println("Node = "+ childNode.toString());
		}
		return null;
	}

	private List<UserInfo> createUsers(JsonNode thread,String userType) {
		JsonNode userArr = thread.path(userType);
		Iterator<JsonNode> pubElements = userArr.elements();
		List<UserInfo> userInfoList = new ArrayList<UserInfo>();
		while(pubElements.hasNext()){
			JsonNode userNode = pubElements.next();
			UserInfo userInfo = userService.createUser(userNode, EnvironmentConfiguration.getBaseUrl() +
					UserConfiguration.getUserCreateEndPoint().toString());
			System.out.println("User obtained = "+ userInfo.getUserId());
			userInfoList.add(userInfo);
		}
		return userInfoList;
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
	 *  
	 */
	@Test(priority = 1, testName = "Create Thread", description = "Test Create Thread api")

	public void testCreateThread() throws Exception {
		Iterator<JsonNode> elements = threadsNode.elements();
		JsonNode threadsObject    = null;
		allThreadsPublishers  = new HashMap<String,List<UserInfo>>();
		allThreadsSubscribers = new HashMap<String,List<UserInfo>>();
		List<UserInfo> publishersList = null;
		List<UserInfo> subscribersList = null;
		//Iterate a thread one by one
		while(elements.hasNext()) {
			threadsObject = elements.next();
			//This holds a single thread data
			JsonNode thread = threadsObject.path("param");
			
			//publishers for the given thread - call createUsers with type to create all users of that type . 
			publishersList = createUsers(thread,USER_TYPE_PUBLISHER);
			//subscribers for the given thread - call createUsers with type to create all users of that type . 
			subscribersList = createUsers(thread,USER_TYPE_SUBSCRIBER);
			
			System.out.println("ThreadsTest:testCreateThread: " + publishersList.size() + " Publishers created!");
			System.out.println("ThreadsTest:testCreateThread: " + subscribersList.size() + " Subscribers created! " );
		
			if(publishersList.size() == 0 ) throw new InvalidRequestException("Publishers must be available to create a thread");
			if(subscribersList.size() == 0 ) throw new InvalidRequestException("Subscribers must be available to create a thread");

			String payload = constructPayload(thread,subscribersList,publishersList);
			System.out.println("ThreadTest:createThreadTest:payload "  +payload);

			HttpResponse response  = null;
			String threadCreateEndPointUrl = EnvironmentConfiguration.getBaseUrl() 
						+MessagingConfiguration.getThreadCreateEndPoint();
	
			
	
			System.out.println("ThreadTest:createThreadTest:Sending post request to url " +
						threadCreateEndPointUrl  + " payload" + payload  + " jwt token " + 
						authInfo.getJwtToken());
	
			response = DefaultRequestProcessor.postRequest(threadCreateEndPointUrl,null,getHeader(),payload);

			System.out.println("ThreadsTest:createUser: Response code obtained " + response.getStatusLine().getStatusCode());

			if(response.getStatusLine().getStatusCode() == 200)
				threadInfo = new ThreadInfo(response);
			else if(response.getStatusLine().getStatusCode() == 400)
				throw new AutomationException(String.valueOf(response.getStatusLine().getStatusCode()), "No parameter : 400 Bad Request. User creation failed !");
			else if(response.getStatusLine().getStatusCode() == 401) 
				throw new AutomationException(String.valueOf(response.getStatusLine().getStatusCode()), "Invalid parameter : 401 Unauthorized. User creation failed !");

			System.out.println("ThreadsTest:createThreadTest:Thread with Id " + threadInfo.getThreadId() + " created !!");
			allThreadsPublishers.put(threadInfo.getThreadId(), publishersList);
			allThreadsSubscribers.put(threadInfo.getThreadId(), subscribersList);
			publishersList = new ArrayList<UserInfo>();
			subscribersList = new ArrayList<UserInfo>();
			
			Assert.assertNotNull(threadInfo.getThreadId());
			Assert.assertEquals(response.getStatusLine().getStatusCode(), 200);
				
		}

	}

	@Test(priority = 2, testName = "GET Thread by ID", description = "Test GET Thread by id api")
	public void testGetThread() throws Exception{
		//Generate jwt token
		//AuthenticationInfo authInfo = authService.authenticate();
		System.out.println("ThreadsTest:testGetThread: jwt token" + authInfo.getJwtToken() +  " Thread Id " + 
				threadInfo.getThreadId());
		//List<NameValuePair> headers = new ArrayList<NameValuePair>();
		//headers.add(new BasicNameValuePair("Authorization","Bearer "+ authInfo.getJwtToken()));
		String subscriberId = null;
		for(Map.Entry entry: allThreadsSubscribers.entrySet()){
			List<UserInfo> subscribersList =  (List<UserInfo>) entry.getValue();
			subscriberId = ((UserInfo)subscribersList.get(0)).getUserId();
			break;
		}
		
		System.out.println("ThreadsTest:testGetThread: subscriberId " + subscriberId);
		String getThreadUrl = EnvironmentConfiguration.getBaseUrl() +MessagingConfiguration.getThreadGetEndPoint()
				+ threadInfo.getThreadId() + "?subscriberId=" +subscriberId;
		System.out.println("ThreadsTest:testGetThread: Sending Get request to url " + getThreadUrl  );
		
		HttpResponse response = DefaultRequestProcessor.getRequest(getThreadUrl , null, getHeader());
		System.out.println("ThreadsTest:testGetThread:  Response code obtained " + response.getStatusLine().getStatusCode());
		JSONObject jsonObject = ApiUtil.getJsonObject(response);

		String threadId2 = jsonObject.getJSONObject("result").getJSONObject("content").getString("id");
		System.out.println("ThreadsTest:testGetThread: threadId obtained " +threadId2);
		Assert.assertEquals(threadId2, threadInfo.getThreadId());
		
	} 
	
	private List<NameValuePair> getHeader() {
		List<NameValuePair> headers = new ArrayList<NameValuePair>();
		headers.add(new BasicNameValuePair(HttpHeaders.CONTENT_TYPE, "application/json"));
		headers.add(new BasicNameValuePair("Authorization", "Bearer "+ authInfo.getJwtToken()));
		return headers;
	}

	@Test(priority = 2, testName = "GET all Threads of subscribers", description = "Test GET Thread by subscriber id")
	public void testGetSubscriberThreads() throws Exception{
		//Generate jwt token
		//AuthenticationInfo authInfo = authService.authenticate();
		String subscriberId = null;
		for(Map.Entry entry: allThreadsSubscribers.entrySet()){
			List subscribersList =  (List) entry.getValue();
			subscriberId = ((UserInfo)subscribersList.get(0)).getUserId();
			break;
		}
		
		System.out.println("ThreadsTest:testGetSubscriberThreads jwt token" + authInfo.getJwtToken() +  " Subscriber Id " + 
				subscriberId);
		
		
		System.out.println("ThreadsTest:testGetSubscriberThreads: subscriberId " + subscriberId);
		String getSubscriberThreadsUrl = EnvironmentConfiguration.getBaseUrl()+MessagingConfiguration.getThreadGetEndPoint()
				+ "?subscriberId=" +subscriberId;
		System.out.println("ThreadsTest:testGetSubscriberThreads: Sending Get request to url " +
				getSubscriberThreadsUrl  );

		HttpResponse response = null;
		
		response = DefaultRequestProcessor.getRequest(getSubscriberThreadsUrl , null, getHeader());
		System.out.println("ThreadsTest:testGetSubscriberThreads:  Response code obtained " +
				response.getStatusLine().getStatusCode()  );
		JSONObject jsonObject = ApiUtil.getJsonObject(response);

		String threadId2 = jsonObject.getJSONObject("result").getJSONObject("content").getJSONArray("threads").getJSONObject(0).getString("id");
		System.out.println("ThreadsTest:testGetSubscriberThreads:jsonObject. content " + 
				jsonObject.getJSONObject("result") + "    threadId " +threadId2);
		Assert.assertEquals(threadId2, threadInfo.getThreadId());
		
	} 


	private String constructPayload(JsonNode threadNode, List<UserInfo> subscribersList,  List<UserInfo> publishersList) {
		((ObjectNode) threadNode).put("clientIdentifier",subscribersList.get(0).getUserId() );
		
		JsonNode publishersNode = ((ObjectNode)threadNode).arrayNode();
		
		for(UserInfo publisher : publishersList) {
			((com.fasterxml.jackson.databind.node.ArrayNode)publishersNode).add(publisher.getUserId());
		}
		((ObjectNode)threadNode).remove(USER_TYPE_PUBLISHER);
		((ObjectNode)threadNode).put(USER_TYPE_PUBLISHER, publishersNode);

		JsonNode subscribersNode = ((ObjectNode)threadNode).arrayNode();
		
		for(UserInfo subscriber : subscribersList) {
			((com.fasterxml.jackson.databind.node.ArrayNode)subscribersNode).add(subscriber.getUserId());
		}
		((ObjectNode)threadNode).remove(USER_TYPE_SUBSCRIBER);
		((ObjectNode)threadNode).put(USER_TYPE_SUBSCRIBER, subscribersNode);
		
		return threadNode.toString();
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
