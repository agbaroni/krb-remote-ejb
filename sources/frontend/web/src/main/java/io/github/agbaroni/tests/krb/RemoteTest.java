package io.github.agbaroni.tests.krb;

import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/remote")
public class RemoteTest {

    @GET
    public String getUser() throws Exception {
        Properties prop = new Properties();
        prop.put(Context.INITIAL_CONTEXT_FACTORY, "org.wildfly.naming.client.WildFlyInitialContextFactory");
        prop.put(Context.PROVIDER_URL, "remote+http://backend:8080");
	InitialContext ic = new InitialContext(prop);
	Bean b = (Bean) ic.lookup("ejb:krb-propagate-backend-application-0.1.0-SNAPSHOT/io.github.agbaroni.tests-krb-propagate-backend-ejb-0.1.0-SNAPSHOT/BeanImpl!io.github.agbaroni.tests.krb.Bean");

	return b.getUser();
    }
}
