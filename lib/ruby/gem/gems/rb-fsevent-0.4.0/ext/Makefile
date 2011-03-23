
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /Users/tka/.rvm/rubies/jruby-1.6.0/lib/native/include
hdrdir = /Users/tka/.rvm/rubies/jruby-1.6.0/lib/native/include/ruby
VPATH = $(srcdir):$(topdir):$(hdrdir)
prefix = $(DESTDIR) 
exec_prefix = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0
libdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib
rubylibdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/ruby/1.8
sitedir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/ruby/site_ruby
sitelibdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/ruby/site_ruby/1.8
sitearchdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/ruby/site_ruby/1.8/java
archdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/native/include
datadir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/share
mandir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/man
sysconfdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/etc
localstatedir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/var
includedir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/native/include
rubyhdrdir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/lib/native/include
bindir = $(DESTDIR)/Users/tka/.rvm/rubies/jruby-1.6.0/bin

CC = cc
LIBRUBY = 
LIBRUBY_A = 
LIBRUBYARG_SHARED = 
LIBRUBYARG_STATIC = 

RUBY_EXTCONF_H = 
CFLAGS   =   -fPIC -DTARGET_RT_MAC_CFM=0  -fno-omit-frame-pointer -fno-strict-aliasing  -fexceptions $(cflags) $(cflags)  -arch x86_64
INCFLAGS = -I. -I$(topdir) -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS =   -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE  $(DEFS) $(cppflags) $(DEFS) $(cppflags)
CXXFLAGS = $(CFLAGS)  -fno-omit-frame-pointer -fno-strict-aliasing  -fexceptions $(cflags) $(cxxflags) $(cflags) $(cxxflags)
ldflags  =  -bundle -framework JavaVM -Wl,-syslibroot,$(SDKROOT) -mmacosx-version-min=10.4 
dldflags = 
archflag =  -arch x86_64
DLDFLAGS = $(ldflags) $(dldflags) $(archflag)
LDSHARED = cc -dynamic -bundle -undefined dynamic_lookup 
AR = 
EXEEXT = 

RUBY_INSTALL_NAME = jruby
RUBY_SO_NAME = 
arch = java
sitearch = java
ruby_version = 1.8
ruby = /Users/tka/.rvm/rubies/jruby-1.6.0/bin/jruby
RUBY = $(ruby)
RM = rm -f
MAKEDIRS = mkdir -p 
INSTALL = install -c 
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 0644
COPY = cp 

#### End of system configuration section. ####

preload = 

libpath = . $(libdir)
LIBPATH =  -L"." -L"$(libdir)"
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS =    
SRCS = 
OBJS = 
TARGET = 
DLLIB = 
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR = /Users/tka/Project/CompassApp/lib/ruby/gem/gems/rb-fsevent-0.4.0/lib$(target_prefix)
RUBYARCHDIR = /Users/tka/Project/CompassApp/lib/ruby/gem/gems/rb-fsevent-0.4.0/lib$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).bundle $(TARGET).il? $(TARGET).tds $(TARGET).map
CLEANOBJS     = *.o *.a *.s[ol] *.pdb *.exp *.bak

all:    Makefile
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-rb

clean:
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean:	clean
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)

realclean:	distclean
install: install-so install-rb

install-so: Makefile
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

