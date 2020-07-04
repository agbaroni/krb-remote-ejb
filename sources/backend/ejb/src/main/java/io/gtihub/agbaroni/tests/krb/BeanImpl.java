package io.github.agbaroni.tests.krb;

import java.io.Serializable;
import java.util.Properties;

import javax.annotation.Resource;
import javax.annotation.security.PermitAll;
import javax.ejb.EJBContext;
import javax.ejb.Remote;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceUnit;

import org.jboss.ejb3.annotation.SecurityDomain;

@PermitAll
@Remote(Bean.class)
@SecurityDomain("backend")
@Stateless
public class BeanImpl implements Bean {
    private static final long serialVersionUID = 283937163837382L;

    @Resource
    private EJBContext context;

    @PersistenceUnit(unitName = "database")
    private EntityManagerFactory entityManagerFactory;

    @Override
    public String getUser() throws Exception {
	return context.getCallerPrincipal().getName();
    }

    @Override
    public String getWord() throws Exception {
	Properties properties = new Properties();
	EntityManager entityManager;
	Word w = null;
	String word = null;

	// properties.put("javax.persistence.jdbc.user", context.getCallerPrincipal().getName());

	entityManager = entityManagerFactory.createEntityManager(properties);

	System.out.println("@@@ " + entityManager);

	w = entityManager.find(Word.class, new Integer(0));
	// word = entityManager.find(Word.class, new Integer(0)).getName();

	System.out.println("@@@ " + w);

	entityManager.close();

	return word;
    }
}
