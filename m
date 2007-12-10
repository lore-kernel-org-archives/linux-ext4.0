From: Theodore Tso <tytso@mit.edu>
Subject: [e2fsprogs PATCH] Userspace solution to time-based UUID without
	duplicates
Date: Mon, 10 Dec 2007 00:36:04 -0500
Message-ID: <20071210053604.GF17037@thunk.org>
References: <200711182038.22055.deller@gmx.de> <200711182240.35015.deller@gmx.de> <20071120063120.GD17536@waste.org> <200711202259.58745.deller@gmx.de> <20071120230012.GF26022@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Helge Deller <deller@gmx.de>, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752667AbXLJFgk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071120230012.GF26022@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 20, 2007 at 06:00:12PM -0500, Theodore Tso wrote:
> Basically, the only way to solve this problem 100% in userspace would
> be with a userspace daemon running as a privileged user, and some kind
> of Unix domain socket.
> 
> Patches to implement this in the e2fsprogs UUID library would be
> greatfully accepted.

This patch creates a userspace uuidd which correctly generates
time-based (version 1) UUID's, with the clock sequence number stored
in the filesystem so we correctly detect time going backwards across
processes and even across reboots.

I believe this patch is a better solution than Helge's kernel patch
solution or the kludgy patch to e2fsprogs in the the SLES RPM which
tries to solve this problem in another way, but which has been
problematic in the past.

Helge, could you try this out and see if it meets your needs?

     	   	     	    	      	       - Ted


commit 84e7405d89cb79b43d84e86051bf2f34d9ae5216
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 10 00:22:16 2007 -0500

    Add uuidd daemon to prevent duplicate time-based UUID's
    
    Also store the clock sequence information in a state file in
    /var/lib/misc/uuid-clock so that if the time goes backwards the clock
    sequence counter can get bumped.  This allows us to completely
    correctly generate time-based (version 1) UUID's according to the
    algorithm specified RFC 4122.
    
    Addresses-Sourceforge-Bug: #1529672
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/debian/changelog b/debian/changelog
index 737242a..04a068b 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+e2fsprogs (1.40.3-2) unstable; urgency=low
+
+  * Add uuidd daemon
+
+ -- Theodore Y. Ts'o <tytso@mit.edu>  Sun, 09 Dec 2007 22:47:53 -0500
+
 e2fsprogs (1.40.3-1) unstable; urgency=medium
 
   * New upstream release
diff --git a/debian/control b/debian/control
index 448be70..03305d6 100644
--- a/debian/control
+++ b/debian/control
@@ -84,6 +84,19 @@ Description: universally unique id library
  libuuid generates and parses 128-bit universally unique id's (UUID's).
  See RFC 4122 for more information.
 
+Package: uuid-runtime
+Section: libs
+Priority: optional
+Depends: ${shlibs:Depends}
+Replaces: e2fsprogs (<= 1.40.3-1ubuntu1)
+Architecture: any
+Description: universally unique id library
+ libuuid generates and parses 128-bit universally unique id's (UUID's).
+ See RFC 4122 for more information.
+ .
+ This package contains the uuidd daemon which is used by libuuid as well as
+ the uuidgen program.
+
 Package: libuuid1-udeb
 Section: debian-installer
 Priority: optional
diff --git a/debian/rules b/debian/rules
index 842965e..ebbe062 100755
--- a/debian/rules
+++ b/debian/rules
@@ -354,7 +354,7 @@ binary-arch: install install-udeb
 	DH_OPTIONS= dh_installchangelogs -pe2fsprogs \
 		-plibblkid${BLKID_SOVERSION} -plibcomerr${COMERR_SOVERSION} \
 		-plibss${SS_SOVERSION} -plibuuid${UUID_SOVERSION} \
-		-pe2fslibs -puuid-dev -pe2fsck-static
+		-pe2fslibs -puuid-dev -puuid-runtime -pe2fsck-static
 
 	dh_fixperms
 ifneq ($(ismips),)
diff --git a/debian/uuid-runtime.copyright b/debian/uuid-runtime.copyright
new file mode 100644
index 0000000..f346739
--- /dev/null
+++ b/debian/uuid-runtime.copyright
@@ -0,0 +1,38 @@
+This package was added to the e2fsprogs debian source package by
+Theodore Ts'o <tytso@mit.edu> on Sat Mar 15 15:33:37 EST 2003
+
+It is part of the main e2fsprogs distribution, which can be found at:
+
+	http://sourceforge.net/projects/e2fsprogs
+
+Upstream Author: Theodore Ts'o <tytso@mit.edu>
+
+Copyright:
+
+Copyright (C) 1999, 2000, 2003, 2004 by Theodore Ts'o
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted provided that the following conditions
+are met:
+1. Redistributions of source code must retain the above copyright
+   notice, and the entire permission notice in its entirety,
+   including the disclaimer of warranties.
+2. Redistributions in binary form must reproduce the above copyright
+   notice, this list of conditions and the following disclaimer in the
+   documentation and/or other materials provided with the distribution.
+3. The name of the author may not be used to endorse or promote
+   products derived from this software without specific prior
+   written permission.
+
+THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+DAMAGE.
diff --git a/debian/uuid-runtime.files b/debian/uuid-runtime.files
new file mode 100644
index 0000000..4f3784b
--- /dev/null
+++ b/debian/uuid-runtime.files
@@ -0,0 +1,5 @@
+usr/bin/uuidgen
+usr/sbin/uuidd
+etc/init.d/uuidd
+usr/share/man/man8/uuidd.*
+usr/share/man/man1/uuidgen.*
diff --git a/debian/uuid-runtime.postinst b/debian/uuid-runtime.postinst
new file mode 100755
index 0000000..6523637
--- /dev/null
+++ b/debian/uuid-runtime.postinst
@@ -0,0 +1,5 @@
+#!/bin/sh -e
+
+mkdir -p /var/lib/misc
+update-rc.d uuidd defaults 25 20 > /dev/null
+invoke-rc.d uuidd start
diff --git a/debian/uuid-runtime.postrm b/debian/uuid-runtime.postrm
new file mode 100755
index 0000000..212cc76
--- /dev/null
+++ b/debian/uuid-runtime.postrm
@@ -0,0 +1,8 @@
+#!/bin/sh
+set -e
+if [ "$1" = purge ]
+then
+	update-rc.d uuidd remove >/dev/null;
+	rm -rf /var/lib/misc/uuid-clock /var/run/uuidd.sock /var/run/uuidd.pid
+fi
+
diff --git a/debian/uuid-runtime.prerm b/debian/uuid-runtime.prerm
new file mode 100755
index 0000000..f83060c
--- /dev/null
+++ b/debian/uuid-runtime.prerm
@@ -0,0 +1,6 @@
+#! /bin/sh
+
+if [ -x /etc/init.d/uuidd ]
+then
+	invoke-rc.d uuidd stop || true
+fi
diff --git a/lib/uuid/gen_uuid.c b/lib/uuid/gen_uuid.c
index 61f2805..b178fc8 100644
--- a/lib/uuid/gen_uuid.c
+++ b/lib/uuid/gen_uuid.c
@@ -38,6 +38,7 @@
  */
 #define _SVID_SOURCE
 
+#include <stdio.h>
 #ifdef HAVE_UNISTD_H
 #include <unistd.h>
 #endif
@@ -57,6 +58,7 @@
 #ifdef HAVE_SYS_SOCKET_H
 #include <sys/socket.h>
 #endif
+#include <sys/un.h>
 #ifdef HAVE_SYS_SOCKIO_H
 #include <sys/sockio.h>
 #endif
@@ -251,18 +253,54 @@ static int get_clock(uint32_t *clock_high, uint32_t *clock_low, uint16_t *ret_cl
 {
 	static int			adjustment = 0;
 	static struct timeval		last = {0, 0};
+	static int state_fd = -2;
+	static FILE *state_f;
 	static uint16_t			clock_seq;
 	struct timeval 			tv;
 	unsigned long long		clock_reg;
-	
-try_again:
-	gettimeofday(&tv, 0);
+
+	if (state_fd == -2) {
+		state_fd = open("/var/lib/misc/uuid-clock", 
+				O_RDWR|O_CREAT, 0600);
+		state_f = fdopen(state_fd, "r+");
+		if (!state_f) {
+			close(state_fd);
+			state_fd = -1;
+		}
+	}
+	if (state_fd >= 0) {
+		rewind(state_f);
+		while (lockf(state_fd, F_LOCK, 0) < 0) {
+			if ((errno == EAGAIN) || (errno == EINTR))
+				continue;
+			fclose(state_f);
+			close(state_fd);
+			state_fd = -1;
+		}
+	}
+	if (state_fd >= 0) {
+		unsigned int cl;
+		unsigned long tv1, tv2;
+		int a;
+
+		if (fscanf(state_f, "clock: %04x tv: %lu %lu adj: %d\n", 
+			   &cl, &tv1, &tv2, &a) == 4) {
+			clock_seq = cl & 0x3FFF;
+			last.tv_sec = tv1;
+			last.tv_usec = tv2;
+			adjustment = a;
+		}
+	}
+		
 	if ((last.tv_sec == 0) && (last.tv_usec == 0)) {
 		get_random_bytes(&clock_seq, sizeof(clock_seq));
 		clock_seq &= 0x3FFF;
 		last = tv;
 		last.tv_sec--;
 	}
+
+try_again:
+	gettimeofday(&tv, 0);
 	if ((tv.tv_sec < last.tv_sec) ||
 	    ((tv.tv_sec == last.tv_sec) &&
 	     (tv.tv_usec < last.tv_usec))) {
@@ -279,6 +317,16 @@ try_again:
 		last = tv;
 	}
 		
+	if (state_fd > 0) {
+		rewind(state_f);
+		ftruncate(state_fd, 0);
+		fprintf(state_f, "clock: %04x tv: %lu %lu adj: %d\n",
+			clock_seq, last.tv_sec, last.tv_usec, adjustment);
+		fflush(state_f);
+		rewind(state_f);
+		lockf(state_fd, F_ULOCK, 0);
+	}
+
 	clock_reg = tv.tv_usec*10 + adjustment;
 	clock_reg += ((unsigned long long) tv.tv_sec)*10000000;
 	clock_reg += (((unsigned long long) 0x01B21DD2) << 32) + 0x13814000;
@@ -289,7 +337,81 @@ try_again:
 	return 0;
 }
 
-void uuid_generate_time(uuid_t out)
+static int read_all(int fd, char *buf, size_t count)
+{
+	ssize_t ret;
+	int c = 0;
+
+	memset(buf, 0, count);
+	while (count > 0) {
+		ret = read(fd, buf, count);
+		if (ret < 0) {
+			if ((errno == EAGAIN) || (errno == EINTR))
+				continue;
+			return -1;
+		}
+		count -= ret;
+		buf += ret;
+		c += ret;
+	}
+	return c;
+}
+
+
+#define OP_TIME		2
+#define OP_RANDOM	3
+
+/*
+ * Try using the uuidd daemon to generate the UUID
+ *
+ * Returns 0 on success, non-zero on failure.
+ */
+static int get_uuid_via_daemon(int op, uuid_t out)
+{
+#define SOCKET_PATH "/var/run/uuidd.sock"
+
+	char c;
+	int s;
+	ssize_t ret;
+	uint32_t reply_len = 0;
+	struct sockaddr_un srv_addr;
+
+	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
+		return -1;
+
+	srv_addr.sun_family = AF_UNIX;
+	strcpy(srv_addr.sun_path, SOCKET_PATH);
+
+	if (connect(s, (const struct sockaddr *) &srv_addr, 
+		    sizeof(struct sockaddr_un)) < 0) {
+		close(s);
+		return -1;
+	}
+	c = op;
+	ret = write(s, &c, 1);
+	if (ret < 1) {
+		close(s);
+		return -1;
+	}
+
+	ret = read_all(s, (char *) &reply_len, sizeof(reply_len));
+	if (ret < 0) {
+		close(s);
+		return -1;
+	}
+	if (reply_len != 16) {
+		close(s);
+		return -1;
+	}
+
+	ret = read_all(s, out, reply_len);
+
+	close(s);
+
+	return ((ret == 16) ? 0 : -1);
+}
+
+void uuid__generate_time(uuid_t out)
 {
 	static unsigned char node_id[6];
 	static int has_init = 0;
@@ -316,7 +438,16 @@ void uuid_generate_time(uuid_t out)
 	uuid_pack(&uu, out);
 }
 
-void uuid_generate_random(uuid_t out)
+void uuid_generate_time(uuid_t out)
+{
+	if (get_uuid_via_daemon(OP_TIME, out) == 0)
+		return;
+
+	uuid__generate_time(out);
+}
+
+
+void uuid__generate_random(uuid_t out)
 {
 	uuid_t	buf;
 	struct uuid uu;
@@ -329,6 +460,13 @@ void uuid_generate_random(uuid_t out)
 	uuid_pack(&uu, out);
 }
 
+void uuid_generate_random(uuid_t out)
+{
+	/* No real reason to use the daemon for random uuid's -- yet */
+	uuid__generate_random(out);
+}
+
+
 /*
  * This is the generic front-end to uuid_generate_random and
  * uuid_generate_time.  It uses uuid_generate_random only if
diff --git a/misc/Makefile.in b/misc/Makefile.in
index db18985..8ca7af6 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -16,10 +16,10 @@ INSTALL = @INSTALL@
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs blkid logsave \
 			$(E2IMAGE_PROG) @FSCK_PROG@ 
-USPROGS=	mklost+found filefrag
+USPROGS=	mklost+found filefrag uuidd
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 findfs.8 blkid.8 $(E2IMAGE_MAN) \
-			logsave.8 filefrag.8 @FSCK_MAN@ 
+			logsave.8 filefrag.8 uuidd.8 @FSCK_MAN@ 
 FMANPAGES=	mke2fs.conf.5
 
 UPROGS=		chattr lsattr uuidgen
@@ -33,6 +33,7 @@ MKE2FS_OBJS=	mke2fs.o util.o profile.o prof_err.o default_profile.o
 CHATTR_OBJS=	chattr.o
 LSATTR_OBJS=	lsattr.o
 UUIDGEN_OBJS=	uuidgen.o
+UUIDD_OBJS=	uuidd.o
 DUMPE2FS_OBJS=	dumpe2fs.o
 BADBLOCKS_OBJS=	badblocks.o
 E2IMAGE_OBJS=	e2image.o
@@ -144,6 +145,10 @@ uuidgen: $(UUIDGEN_OBJS) $(DEPLIBUUID)
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -o uuidgen $(UUIDGEN_OBJS) $(LIBUUID) $(LIBINTL)
 
+uuidd: $(UUIDD_OBJS) $(DEPLIBUUID)
+	@echo "	LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o uuidd $(UUIDD_OBJS) $(LIBUUID) $(LIBINTL)
+
 dumpe2fs: $(DUMPE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBUUID)
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -o dumpe2fs $(DUMPE2FS_OBJS) $(LIBS) \
@@ -213,6 +218,10 @@ logsave.8: $(DEP_SUBSTITUTE) $(srcdir)/logsave.8.in
 	@echo "	SUBST $@"
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/logsave.8.in logsave.8
 
+uuidd.8: $(DEP_SUBSTITUTE) $(srcdir)/uuidd.8.in
+	@echo "	SUBST $@"
+	@$(SUBSTITUTE_UPTIME) $(srcdir)/uuidd.8.in uuidd.8
+
 chattr.1: $(DEP_SUBSTITUTE) $(srcdir)/chattr.1.in
 	@echo "	SUBST $@"
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/chattr.1.in chattr.1 
@@ -239,7 +248,8 @@ installdirs:
 		$(DESTDIR)$(root_sbindir) $(DESTDIR)$(bindir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man8dir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man5dir) \
-		$(DESTDIR)$(libdir) $(DESTDIR)/$(root_sysconfdir)
+		$(DESTDIR)$(libdir) $(DESTDIR)/$(root_sysconfdir) \
+		$(DESTDIR)/etc/init.d
 
 install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	@for i in $(SPROGS); do \
@@ -304,6 +314,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
 			$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
 	fi
+	$(INSTALL_SCRIPT) $(srcdir)/uuidd.rc $(DESTDIR)/etc/init.d/uuidd
 
 install-strip: install
 	@for i in $(SPROGS); do \
@@ -350,6 +361,7 @@ uninstall:
 	if cmp -s $(srcdir)/mke2fs.conf $(DESTDIR)/$(root_sysconfdir)/mke2fs.conf; then \
 		$(RM) $(DESTDIR)/$(root_sysconfdir)/mke2fs.conf; \
 	fi
+	$(RM) -f $(DESTDIR)/etc/init.d/uuidd
 
 clean:
 	$(RM) -f $(SPROGS) $(USPROGS) $(UPROGS) $(UMANPAGES) $(SMANPAGES) \
diff --git a/misc/uuidd.8.in b/misc/uuidd.8.in
new file mode 100644
index 0000000..779996d
--- /dev/null
+++ b/misc/uuidd.8.in
@@ -0,0 +1,78 @@
+.\" -*- nroff -*-
+.\" Copyright 2007 by Theodore Ts'o.  All Rights Reserved.
+.\" This file may be copied under the terms of the GNU Public License.
+.\" 
+.TH UUIDD 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+uuidd \- UUID generation daemon
+.SH SYNOPSIS
+.B uuidd 
+[
+.B \-d
+] 
+[
+.B \-p
+.I pidfile
+]
+[
+.B \-s
+.I socketpath
+]
+
+.B uuidd
+[
+.B \-r
+|
+.B \-t
+]
+[
+.B \-s 
+.I socketpath
+]
+
+.B uuidd \-k
+.SH DESCRIPTION
+The
+.B uuidd
+daemon is used by the UUID library to generate 
+universally unique identifiers (UUIDs), especially time-based UUID's
+in a secure and guaranteed-unique fashion, even in the face of large
+numbers of threads trying to grab UUID's running on different CPU's.
+.SH OPTIONS
+.TP
+.B \-d
+Run 
+.B uuidd
+in debugging mode.  This prevents uuidd from running as a daemon.
+.TP
+.B \-k
+If a currently uuidd daemon is running, kill it.
+.TP
+.BI \-p  " pidfile"
+Specify the pathname where the pid file should be written.  By default,
+the pid file is written to /var/run/uuidd.pid.
+.TP
+.BI \-s " socketpath"
+Specify the pathname used for the unix-domain socket used by uuidd.  By
+qdefault, the pathname used is /var/run/uuidd.sock.  This is primarily
+for debugging purposes, since the pathname is hard-coded in the libuuid
+library.
+.TP
+.B \-r
+Test uuidd by trying to connect to a running uuidd daemon and 
+request it to return a random-based UUID.
+.TP
+.B \-t
+Test uuidd by trying to connect to a running uuidd daemon and 
+request it to return a time-based UUID.
+.SH AUTHOR
+The
+.B uuidd
+daemon  was written by Theodore Ts'o <tytso@mit.edu>.
+.SH AVAILABILITY
+.B uuidd
+is part of libuuid from the e2fsprogs package and is available from
+http://e2fsprogs.sourceforge.net.
+.SH "SEE ALSO"
+.BR libuuid (3),
+.BR uuidgen (1)
diff --git a/misc/uuidd.c b/misc/uuidd.c
new file mode 100644
index 0000000..174140c
--- /dev/null
+++ b/misc/uuidd.c
@@ -0,0 +1,331 @@
+/*
+ * uuidd.c --- UUID-generation daemon
+ *
+ * Copyright (C) 2007  Theodore Ts'o
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#ifdef HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#include <unistd.h>
+#include <inttypes.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <fcntl.h>
+#include <signal.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#else
+extern int getopt(int argc, char * const argv[], const char *optstring);
+extern char *optarg;
+extern int optind;
+#endif
+#include "uuid/uuid.h"
+#include "nls-enable.h"
+
+char *socket_path = "/tmp/uuid.sock";
+
+static void usage(const char *progname)
+{
+	fprintf(stderr, _("Usage: %s [-d] [-p pidfile] [-s socketpath]\n"), 
+		progname);
+	fprintf(stderr, _("       %s [-r|t] [-s socketpath]\n"), progname);
+	fprintf(stderr, _("       %s -k\n"), progname);
+	exit(1);
+}
+
+void create_daemon(const char *pidfile_path)
+{
+	pid_t pid;
+	FILE *f;
+
+	pid = fork();
+	if (pid == -1) {
+		perror("fork");
+		exit(1);
+	} else if (pid != 0) {
+	    exit(0);
+	}
+
+	close(0);
+	close(1);
+	close(2);
+	open("/dev/null", O_RDWR);
+	open("/dev/null", O_RDWR);
+	open("/dev/null", O_RDWR);
+
+	chdir("/");
+	(void) setsid();
+
+	f = fopen(pidfile_path, "w");
+	if (f) {
+		fprintf(f, "%d\n", getpid());
+		fclose(f);
+	}
+}
+
+extern void uuid__generate_time(uuid_t out);
+extern void uuid__generate_random(uuid_t out);
+
+void server_loop(char *socket_path, int debug, char *pidfile_path)
+{
+	char op;
+	socklen_t fromlen;
+	int s, ns, len;
+	char reply_buf[1024];
+	uint32_t reply_len = 0;
+	struct sockaddr_un my_addr, from_addr;
+	uuid_t uu;
+	mode_t save_umask;
+
+	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
+		fprintf(stderr, "Couldn't create unix stream socket: %s",
+			strerror(errno));
+		exit(1);
+	}
+
+	/*
+	 * Create the address we will be binding to.
+	 */
+	my_addr.sun_family = AF_UNIX;
+	strcpy(my_addr.sun_path, socket_path);
+	(void) unlink(socket_path);
+	save_umask = umask(0);
+	if (bind(s, (const struct sockaddr *) &my_addr, 
+		 sizeof(struct sockaddr_un)) < 0) {
+		fprintf(stderr, "Couldn't bind unix socket %s: %s\n",
+			socket_path, strerror(errno));
+		exit(1);
+	}
+	umask(save_umask);
+
+	if (listen(s, 5) < 0) {
+		fprintf(stderr, "Couldn't listen on unix socket %s: %s\n",
+			socket_path, strerror(errno));
+		exit(1);
+	}
+
+	if (!debug) {
+		create_daemon(pidfile_path);
+	}
+
+	while (1) {
+		fromlen = sizeof(from_addr);
+		ns = accept(s, (struct sockaddr *) &from_addr, &fromlen);
+		if (ns < 0) {
+			if ((errno == EAGAIN) || (errno == EINTR))
+				continue;
+			perror("accept");
+			exit(1);
+		}
+		len = read(ns, &op, 1);
+		if (len != 1) {
+			if (len < 0)
+				perror("read");
+			else
+				printf("Error reading from client, len = %d\n",
+				       len);
+			close(ns);
+			continue;
+		}
+		printf("operation %d\n", op);
+		switch(op) {
+		case 0:
+			sprintf(reply_buf, "%d", getpid());
+			reply_len = strlen(reply_buf)+1;
+			break;
+		case 1:
+			sprintf(reply_buf, "3"); /* Max valid op */
+			reply_len = strlen(reply_buf)+1;
+			break;
+		case 2:
+			uuid__generate_time(uu);
+			memcpy(reply_buf, uu, sizeof(uu));
+			reply_len = sizeof(uu);
+			break;
+		case 3:
+			uuid__generate_random(uu);
+			memcpy(reply_buf, uu, sizeof(uu));
+			reply_len = sizeof(uu);
+			break;
+		}
+		write(ns, &reply_len, sizeof(reply_len));
+		write(ns, reply_buf, reply_len);
+		close(ns);
+	}
+}
+
+int read_all(int fd, char *buf, size_t count)
+{
+	ssize_t ret;
+	int c = 0;
+
+	memset(buf, 0, count);
+	while (count > 0) {
+		ret = read(fd, buf, count);
+		if (ret < 0) {
+			if ((errno == EAGAIN) || (errno == EINTR))
+				continue;
+			return -1;
+		}
+		count -= ret;
+		buf += ret;
+		c += ret;
+	}
+	return c;
+}
+
+int call_daemon(char *socket_path, int op, char *buf, int buflen, 
+		const char **err_context)
+{
+	char c;
+	int s;
+	ssize_t ret;
+	uint32_t reply_len = 0;
+	struct sockaddr_un srv_addr;
+
+	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
+		if (err_context)
+			*err_context = "socket";
+		return -1;
+	}
+
+	srv_addr.sun_family = AF_UNIX;
+	strcpy(srv_addr.sun_path, socket_path);
+
+	if (connect(s, (const struct sockaddr *) &srv_addr, 
+		    sizeof(struct sockaddr_un)) < 0) {
+		if (err_context)
+			*err_context = "connect";
+		close(s);
+		return -1;
+	}
+
+	c = op;
+	ret = write(s, &c, 1);
+	if (ret < 1) {
+		if (err_context)
+			*err_context = "write";
+		close(s);
+		return -1;
+	}
+
+	ret = read_all(s, (char *) &reply_len, sizeof(reply_len));
+	if (ret < 0) {
+		if (err_context)
+			*err_context = "read count";
+		close(s);
+		return -1;
+	}
+	if (reply_len > buflen) {
+		if (err_context)
+			*err_context = "response too big";
+		close(s);
+		return -1;
+	}
+	ret = read_all(s, buf, reply_len);
+
+	close(s);
+
+	return ret;
+}
+
+
+#define DO_TYPE_TIME	2
+#define DO_TYPE_RANDOM	3
+
+int main(int argc, char **argv)
+{
+	int	c;
+	int	debug = 0;
+	int	do_type = 0;
+	int	do_kill = 0;
+	int	ret;
+	char	*socket_path = "/var/run/uuidd.sock";
+	char	*pidfile_path = "/var/run/uuidd.pid";
+	uuid_t	uu;
+	const char *err_context;
+	char   str[37];
+
+	while ((c = getopt (argc, argv, "dkp:s:tr")) != EOF) {
+		switch (c) {
+		case 'd':
+			debug++;
+			break;
+		case 'k':
+			do_kill++;
+			break;
+		case 'p':
+			pidfile_path = optarg;
+			break;
+		case 's':
+			socket_path = optarg;
+			break;
+		case 't':
+			do_type = DO_TYPE_TIME;
+			break;
+		case 'r':
+			do_type = DO_TYPE_RANDOM;
+			break;
+		default:
+			usage(argv[0]);
+		}
+	}
+	if (do_type) {
+		ret = call_daemon(socket_path, do_type, (char *) &uu,
+				  sizeof(uu), &err_context);
+		if (ret < 0) {
+			printf("Error calling uuidd daemon (%s): %s\n",
+			       err_context, strerror(errno));
+			exit(1);
+		}
+		if (ret != sizeof(uu)) {
+			printf("Unexpected reply length from server %d\n", 
+			       ret);
+			exit(1);
+		}
+		uuid_unparse(uu, str);
+
+		printf("%s\n", str);
+		exit(0);
+	}
+
+	/*
+	 * Check to make sure there isn't another daemon running already
+	 */
+	ret = call_daemon(socket_path, 0, str, sizeof(str), 0);
+	if (ret > 0) {
+		if (do_kill) {
+			do_kill = atoi(str);
+			if (do_kill > 0) {
+				ret = kill(do_kill, SIGTERM);
+				if (ret < 0) {
+					fprintf(stderr,
+						"Couldn't kill uuidd running "
+						"at pid %d: %s\n", do_kill,
+						strerror(errno));
+					exit(1);
+				}
+				printf("Killed uuidd running at pid %d\n",
+				       do_kill);
+			}
+			exit(0);
+		}
+		printf("uuidd daemon already running at pid %s\n", str);
+		exit(1);
+	}
+	if (do_kill)
+		exit(0);	/* Nothing to kill */
+	
+	server_loop(socket_path, debug, pidfile_path);
+	return 0;
+}
diff --git a/misc/uuidd.rc b/misc/uuidd.rc
new file mode 100644
index 0000000..73c067a
--- /dev/null
+++ b/misc/uuidd.rc
@@ -0,0 +1,54 @@
+#! /bin/sh -e
+### BEGIN INIT INFO
+# Provides:          uuidd
+# Required-Start:    $time $local_fs
+# Required-Stop:     $time $local_fs
+# Default-Start:     2 3 4 5
+# Default-Stop:      0 1 6
+# Short-Description: uuidd daemon
+# Description:       Init script for the uuid generation daemon
+### END INIT INFO
+#
+# Author:	"Theodore Ts'o" <tytso@mit.edu>
+#
+set -e
+
+PATH=/bin:/usr/bin:/sbin:/usr/sbin
+DAEMON=/usr/sbin/uuidd
+
+test -x $DAEMON || exit 0
+
+. /lib/lsb/init-functions
+
+case "$1" in
+    start)
+	log_daemon_msg "Starting uuid generator" "uuidd"
+	start_daemon $DAEMON
+	log_end_msg $?
+    ;;
+  stop)
+	log_daemon_msg "Stopping uuidd generator" "uuidd"
+	killproc $DAEMON
+	log_end_msg $?
+    ;;
+  status)
+	if pidofproc $DAEMON >& /dev/null ; then
+	    echo "$DAEMON is running";
+	    exit 0;
+	else
+	    echo "$DAEMON is NOT running";
+	    if test -f /var/run/uuidd.pid; then exit 2; fi 
+	    exit 3;
+	fi
+	;;
+  force-reload|restart)
+    $0 stop
+    $0 start
+    ;;
+  *)
+    echo "Usage: /etc/init.d/uuidd {start|stop|restart|force-reload}"
+    exit 1
+    ;;
+esac
+
+exit 0
