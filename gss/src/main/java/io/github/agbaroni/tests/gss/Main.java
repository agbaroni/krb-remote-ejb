package io.github.agbaroni.tests.gss;

import org.ietf.jgss.*;

public final class Main {
    public static void main(String... args) throws Exception {
        System.setProperty("java.security.krb5.realm","REDHAT.COM");
        System.setProperty("java.security.krb5.kdc","redhat.com");
        System.setProperty("javax.security.auth.useSubjectCredsOnly","false");

	Oid mechanism = new Oid("1.2.840.113554.1.2.2");
	GSSManager manager = GSSManager.getInstance();
	GSSName name = manager.createName("abaroni", GSSName.NT_USER_NAME);
	GSSCredential credential = manager.createCredential(name,
							    GSSCredential.DEFAULT_LIFETIME,
							    mechanism,
							    GSSCredential.INITIATE_ONLY);
	GSSName serverName = manager.createName("http@redhat.com", GSSName.NT_HOSTBASED_SERVICE);

	GSSContext context = manager.createContext(serverName,
						   mechanism,
						   credential,
						   GSSContext.DEFAULT_LIFETIME);
	byte[] outToken = context.initSecContext(new byte[0], 0, 0);

	context.dispose();
    }
}
