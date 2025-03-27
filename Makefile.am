# Install vendor library directly (precompiled)
vendorlibdir = $(libdir)
vendorlib_DATA = vendor/libevolinuxagent.so.1

# Build PAM module
pammoddir = $(pamdir)
pammod_LTLIBRARIES = pam_evo_common.la
pam_evo_common_la_SOURCES = src/main.c
pam_evo_common_la_CPPFLAGS = -I$(top_srcdir)/include -DSYSCONFDIR='"$(sysconfdir)"'
pam_evo_common_la_CFLAGS = -Wall -Werror
pam_evo_common_la_LDFLAGS = -module -avoid-version -shared -Wl,-rpath,$(libdir)
pam_evo_common_la_LIBADD = -lpam -L$(abs_top_builddir)/vendor -levolinuxagent

# Headers
include_HEADERS = include/evopam.h

# Install configuration
sysconf_DATA = config/.config.default
configdir = $(sysconfdir)/evosecurity.d
config_DATA = config/.config.default

# PAM configuration directory
pamconfdir = @pamconfdir@

install-data-hook:
	$(MKDIR_P) $(DESTDIR)$(configdir)
	$(MKDIR_P) $(DESTDIR)$(pamconfdir)
	if [ ! -f $(DESTDIR)$(configdir)/.config ]; then \
		cp $(DESTDIR)$(configdir)/.config.default $(DESTDIR)$(configdir)/.config; \
	fi
	if [ ! -f $(DESTDIR)$(pamconfdir)/evo_common ]; then \
		echo -e "auth [success=1 default=ignore] pam_succeed_if.so user = user \n auth [success=2 default=die] pam_evo_common.so" > $(DESTDIR)$(pamconfdir)/evo_common; \
	fi

install-exec-hook:
	rm -f $(DESTDIR)$(pammoddir)/pam_evo_common.la
	rm -f $(DESTDIR)$(vendorlibdir)/libevolinuxagent.la
	-test -n "$(DESTDIR)" || /sbin/ldconfig

uninstall-hook:
	sed -i '/@include evo_common/d' "$(DESTDIR)$(pamconfdir)/common-auth"
	if [ -f "/etc/pam.d/common-auth-legacy" ]; then \
	       	rm /etc/pam.d/common-auth-legacy \
	fi
	if grep -q "@include common-auth-legacy" /etc/pam.d/chfn; then \
                sed -i 's|@include common-auth-legacy|@include common-auth|' /etc/pam.d/chfn \
	fi
	if grep -q "@include common-auth-legacy" /etc/pan.d/other; then \
		sed -i 's|@include common-auth-legacy|@include common-auth|' /etc/pam.d/other\
	fi
	rm -f $(DESTDIR)$(pamconfdir)/evo_common
	rm -f $(DESTDIR)$(configdir)/.config
	rm -f $(DESTDIR)$(configdir)/.config.default
	rm -f $(DESTDIR)$(vendorlibdir)/libevolinuxagent.so.1
	-rmdir $(DESTDIR)$(configdir) 2>/dev/null || true
	-test -n "$(DESTDIR)" || /sbin/ldconfig
