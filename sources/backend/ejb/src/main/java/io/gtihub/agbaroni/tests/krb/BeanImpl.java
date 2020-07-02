package io.github.agbaroni.tests.krb;

import java.io.Serializable;

import javax.annotation.Resource;
import javax.annotation.security.PermitAll;
import javax.ejb.EJBContext;
import javax.ejb.Remote;
import javax.ejb.Stateless;

import org.jboss.ejb3.annotation.SecurityDomain;

@PermitAll
@Remote(Bean.class)
@SecurityDomain("backend")
@Stateless
public class BeanImpl implements Bean {
    private static final long serialVersionUID = 283937163837382L;

    @Resource
    private EJBContext context;

    @Override
    public String getUser() throws Exception {
	return context.getCallerPrincipal().getName();
    }
}
