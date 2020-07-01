package io.github.agbaroni.tests.krb;

import java.util.Properties;
import java.util.concurrent.Callable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;

import org.ietf.jgss.GSSCredential;
import org.wildfly.security.auth.client.AuthenticationConfiguration;
import org.wildfly.security.auth.client.AuthenticationContext;
import org.wildfly.security.auth.client.MatchRule;
import org.wildfly.security.auth.server.SecurityDomain;
import org.wildfly.security.auth.server.SecurityIdentity;
import org.wildfly.security.credential.GSSKerberosCredential;
import org.wildfly.security.sasl.SaslMechanismSelector;

@Path("/remote")
public class RemoteTest {

    private String complexCall() throws Exception {
	SecurityIdentity securityIdentity = SecurityDomain.getCurrent().getCurrentSecurityIdentity();
	GSSKerberosCredential gssKerberosCredential = securityIdentity.getPrivateCredentials().getCredential(GSSKerberosCredential.class);
	GSSCredential credential = gssKerberosCredential.getGssCredential();
        AuthenticationConfiguration configuration = AuthenticationConfiguration.empty()
	    .setSaslMechanismSelector(SaslMechanismSelector.NONE.addMechanism("GS2-KRB5"))
	    .useGSSCredential(credential);
        AuthenticationContext context = AuthenticationContext.empty().with(MatchRule.ALL, configuration);
        Callable<String> callable = () -> {
	    Properties prop = new Properties();
	    prop.put(Context.INITIAL_CONTEXT_FACTORY, "org.wildfly.naming.client.WildFlyInitialContextFactory");
	    prop.put(Context.PROVIDER_URL, "remote+http://backend:8080");
	    InitialContext ic = new InitialContext(prop);
	    Bean b = (Bean) ic.lookup("ejb:krb-propagate-backend-application-0.1.0-SNAPSHOT/io.github.agbaroni.tests-krb-propagate-backend-ejb-0.1.0-SNAPSHOT/BeanImpl!io.github.agbaroni.tests.krb.Bean");

	    return b.getUser();
        };

        return context.runCallable(callable);
    }

    private String simpleCall() throws Exception {
	InitialContext ic = new InitialContext();
	Bean b = (Bean) ic.lookup("ejb:krb-propagate-backend-application-0.1.0-SNAPSHOT/io.github.agbaroni.tests-krb-propagate-backend-ejb-0.1.0-SNAPSHOT/BeanImpl!io.github.agbaroni.tests.krb.Bean");

	return b.getUser();
    }

    @GET
    public String getUser() throws Exception {
	return complexCall();
    }
}
