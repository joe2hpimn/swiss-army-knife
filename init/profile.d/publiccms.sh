#!/usr/bin/env bash
#shellcheck disable=2164

publiccms-backup(){
	mysqldump -uroot -p cms > ./cms.sql
	tar -cvzf data.tar.gz ${HOME}/opt/data/PublicCMS/
}

publiccms-build(){
	${OPT}/tomcat/bin/shutdown.sh || true

	rm -rf ${OPT}/tomcat/webapps/publiccms
	rm -rf ${OPT}/tomcat/webapps/publiccms.war

	pushd ${HOME}/github/baotingfang/PublicCMS/publiccms-parent
		mvn clean
		mvn package
		pushd ${HOME}/github/baotingfang/PublicCMS/publiccms-parent/publiccms/target
			cp publiccms.war ${OPT}/tomcat/webapps/publiccms.war
		popd
		${OPT}/tomcat/bin/startup.sh
	popd

	echo "done!"
}
