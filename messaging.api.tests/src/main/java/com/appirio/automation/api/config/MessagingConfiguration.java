package com.appirio.automation.api.config;


import org.apache.commons.configuration.PropertiesConfiguration;

/**
 * Holds user related properties
 * @author anjalijain
 *
 */

public class MessagingConfiguration extends Configuration  {


	private static final String THREAD_EP_GET   			= "threadGetURL";
	private static final String THREAD_EP_CREATE 			= "threadCreateURL";

	private static final String PROPS_MESSAGE 				=   "message.properties"; 

	private static PropertiesConfiguration messagePropertyConfig = null;

	private static MessagingConfiguration messageConfiguration = null;

	private MessagingConfiguration() {	   
	}

	public static MessagingConfiguration initialize() {
		if(messageConfiguration == null) {  
			messageConfiguration = new MessagingConfiguration();
			messagePropertyConfig = messageConfiguration.loadConfiguration(PROPS_MESSAGE);
		}
		return messageConfiguration;
	}

	public static String getThreadGetEndPoint() {
		return getValue(messagePropertyConfig, THREAD_EP_GET);
	}


	public static String getThreadCreateEndPoint() {
		return getValue(messagePropertyConfig, THREAD_EP_CREATE);
	}


	
	


}
