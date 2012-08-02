SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .tar

NAME = skilledwaffle
VERSION = 0
LICENSE = GNU General Public License
GROUP = Emory Hughes Merryman, III
URL = https://github.com/ACRMJ3vx/skilledwaffle

CAT=/bin/cat
CP=/bin/cp
ECHO=/bin/echo
GIT=/usr/bin/git
GZIP=/bin/gzip
MKDIR=/bin/mkdir
RM=/bin/rm
TAR=/bin/tar

all : build/skilledwaffle-${VERSION}.spec build/skilledwaffle-${VERSION}.tar.gz

clean :
	${RM} --recursive --force build

build/skilledwaffle-${VERSION}.spec :
	${MKDIR} --parents $(@D)
	${ECHO} Summary: ${SUMMARY} >> $@
	${ECHO} Name: ${NAME} >> $@
	${ECHO} Version: ${VERSION} >> $@
	${ECHO} Release: ${RELEASE} >> $@
	${ECHO} License: ${LICENSE} >> $@
	${ECHO} Group: ${GROUP} >> $@
	${ECHO} URL: ${URL} >> $@
	${ECHO} Source0: %{name}-%{version}.tar.gz >> $@
	${ECHO} BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root >> $@
	${ECHO} BuildRequires: coreutils
	${ECHO} BuildRequires: sed
	${ECHO} BuildRequires: help2man
	${ECHO} Requires: coreutils
	${ECHO} Requires: sed
	${ECHO} >> $@
	${ECHO} %description >> $@
	${CAT} description >> $@
	${ECHO} >> $@
	${ECHO} %prep >> $@
	${ECHO} %setup -q >> $@
	${ECHO} >> $@
	${ECHO} %build >> $@
	${ECHO} ${MKDIR} --parents usr/bin >> $@
	${ECHO} ${SED} -e -e "s!VERSION!%{name} %{version}.%{release}!" -e "wuser/bin/skilledwaffle" >> $@
	${ECHO} >> $@
	${ECHO} %install >> $@
	${ECHO} -e "rm --recursive --force \$${RPM_BUILD_ROOT}" >> $@
	${ECHO} for FILE in usr/bin/skilledwaffle >> $@
	${ECHO} do >> $@
	${ECHO} -e "DIR=\$$(${DIRNAME} \$${FILE})" >> $@
	${ECHO} -e "${MKDIR} --parents \$${RPM_BUILD_ROOT}/\$${DIR}" >> $@
	${ECHO} -e "cp \$${FILE} \$${RPM_BUILD_ROOT}/\$${DIR}" >> $@
	${ECHO} done >> $@
	${ECHO} >> $@
	${ECHO} %clean >> $@
	${ECHO} -e "rm --recursive --force \\$${RPM_BUILD_ROOT}" >> $@
	${ECHO} >> $@
	${ECHO} %files >> $@
	${ECHO} "%defattr(-,root,root,-)" >> $@
	${ECHO} "%attr(0555,root,root) /usr/bin/skilledwaffle" >> $@

build/skilledwaffle-${VERSION}.tar.gz : build/skilledwaffle-${VERSION}.tar
	${MKDIR} --parents ${@D}
	${GZIP} -9 --to-stdout $< > $@

build/skilledwaffle-${VERSION}.tar : build/skilledwaffle-${VERSION}
	${MKDIR} --parents ${@D}
	${TAR} --create --file $@ --directory $< .

build/skilledwaffle-${VERSION} : build/skilledwaffle-${VERSION}/skilledwaffle
	${MKDIR} --parents $@

build/skilledwaffle-${VERSION}/skilledwaffle : script test
	${MKDIR} --parents ${@D}
	./test
	${CP} $< $@

build/version :
	${GIT} describe --abbrev=4 HEAD