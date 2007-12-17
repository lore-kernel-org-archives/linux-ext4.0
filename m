From: Theodore Tso <tytso@mit.edu>
Subject: Re: [e2fsprogs PATCH] Userspace solution to time-based UUID
	without duplicates
Date: Sun, 16 Dec 2007 19:07:48 -0500
Message-ID: <20071217000748.GB32454@thunk.org>
References: <200711182038.22055.deller@gmx.de> <20071120230012.GF26022@thunk.org> <20071210053604.GF17037@thunk.org> <200712162253.20928.deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55954 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499AbXLQAIg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Dec 2007 19:08:36 -0500
Content-Disposition: inline
In-Reply-To: <200712162253.20928.deller@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 16, 2007 at 10:53:19PM +0100, Helge Deller wrote:
> 
> FYI, we are currently discussing and testing this proposed patch to e2fsprogs off-list in Red Hat's bugzilla:
> https://bugzilla.redhat.com/show_bug.cgi?id=233471

Note that this bug is currently not publically visible.  (You need to
be various Red Hat Beta groups in order to view it)

In any case here's the latest version of the libuuid patch, in case
anyone would like to comment.  I believe this to be a more correct way
of solving this problem than the uuid kernel patch, since it does the
right thing even if time goes backwards across a reboot.  And, of
course, it doesn't consume one or two kilobytes of non-swappable
kernel memory.  In this version, the uuidd daemon is optional (it's
mainly useful if you are running some application that requires
hundreds or thousands of UUID's generated per second[1]), and if it's
installed, the libuuid library to start the setuid helper uuidd daemon
when it is needed, and after five minutes of inactivity, the uuidd
daemon will automatically exit, thus conserving memory.

[1] This is not a hypothetical example; it was such an enterprise
application that spawned the Sourceforge, Red Hat, and Novell bug
reports.

						- Ted

commit 740837def7fc55ba6b0368f46a4b4abcaba0becd
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Dec 16 17:21:38 2007 -0500

    Add uuidd daemon to prevent duplicate time-based UUID's
    
    Also store the clock sequence information in a state file in
    /var/lib/misc/uuid-clock so that if the time goes backwards the clock
    sequence counter can get bumped.  This allows us to completely
    correctly generate time-based (version 1) UUID's according to the
    algorithm specified RFC 4122.
    
    Addresses-Sourceforge-Bug: #1529672
    Addresses-Red-Hat-Bugzilla: #233471
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/aclocal.m4 b/aclocal.m4
index 3a4c2f3..fc3ed73 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -2600,3 +2600,52 @@ AC_DEFUN([gl_XSIZE],
   AC_REQUIRE([gl_SIZE_MAX])
   AC_CHECK_HEADERS(stdint.h)
 ])
+
+# from http://autoconf-archive.cryp.to/ax_tls.html
+#
+# This was licensed under the GPL with the following exception:
+#
+# As a special exception, the respective Autoconf Macro's copyright
+# owner gives unlimited permission to copy, distribute and modify the
+# configure scripts that are the output of Autoconf when processing
+# the Macro. You need not follow the terms of the GNU General Public
+# License when using or distributing such scripts, even though
+# portions of the text of the Macro appear in them. The GNU General
+# Public License (GPL) does govern all other use of the material that
+# constitutes the Autoconf Macro.
+#
+# This special exception to the GPL applies to versions of the
+# Autoconf Macro released by the Autoconf Macro Archive. When you make
+# and distribute a modified version of the Autoconf Macro, you may
+# extend this special exception to the GPL to apply to your modified
+# version as well.
+#
+AC_DEFUN([AX_TLS], [
+  AC_MSG_CHECKING(for thread local storage (TLS) class)
+  AC_CACHE_VAL(ac_cv_tls, [
+    ax_tls_keywords="__thread __declspec(thread) none"
+    for ax_tls_keyword in $ax_tls_keywords; do
+       case $ax_tls_keyword in
+          none) ac_cv_tls=none ; break ;;
+          *)
+             AC_TRY_COMPILE(
+                [#include <stdlib.h>
+                 static void
+                 foo(void) {
+                 static ] $ax_tls_keyword [ int bar;
+                 exit(1);
+                 }],
+                 [],
+                 [ac_cv_tls=$ax_tls_keyword ; break],
+                 ac_cv_tls=none
+             )
+          esac
+    done
+])
+
+  if test "$ac_cv_tls" != "none"; then
+    dnl AC_DEFINE([TLS], [], [If the compiler supports a TLS storage class define it to that here])
+    AC_DEFINE_UNQUOTED([TLS], $ac_cv_tls, [If the compiler supports a TLS storage class define it to that here])
+  fi
+  AC_MSG_RESULT($ac_cv_tls)
+])
diff --git a/configure b/configure
index 5c8448a..244a509 100755
--- a/configure
+++ b/configure
@@ -11434,6 +11434,81 @@ done
 
 fi
 
+  { echo "$as_me:$LINENO: checking for thread local storage (TLS) class" >&5
+echo $ECHO_N "checking for thread local storage (TLS) class... $ECHO_C" >&6; }
+  if test "${ac_cv_tls+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+
+    ax_tls_keywords="__thread __declspec(thread) none"
+    for ax_tls_keyword in $ax_tls_keywords; do
+       case $ax_tls_keyword in
+          none) ac_cv_tls=none ; break ;;
+          *)
+             cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <stdlib.h>
+                 static void
+                 foo(void) {
+                 static  $ax_tls_keyword  int bar;
+                 exit(1);
+                 }
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_tls=$ax_tls_keyword ; break
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_tls=none
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+          esac
+    done
+
+fi
+
+
+  if test "$ac_cv_tls" != "none"; then
+
+cat >>confdefs.h <<_ACEOF
+#define TLS $ac_cv_tls
+_ACEOF
+
+  fi
+  { echo "$as_me:$LINENO: result: $ac_cv_tls" >&5
+echo "${ECHO_T}$ac_cv_tls" >&6; }
+
+
 
 
 
@@ -14518,7 +14593,9 @@ fi
 
 
 
-for ac_func in chflags getrusage llseek lseek64 open64 fstat64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime
+
+
+for ac_func in chflags getrusage llseek lseek64 open64 fstat64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid
 do
 as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
 { echo "$as_me:$LINENO: checking for $ac_func" >&5
diff --git a/configure.in b/configure.in
index 011df1a..061fbcf 100644
--- a/configure.in
+++ b/configure.in
@@ -570,6 +570,7 @@ if test $cross_compiling = no; then
 else
   AC_CHECK_PROGS(BUILD_CC, gcc cc)
 fi
+AX_TLS
 AC_CHECK_HEADERS(stdlib.h unistd.h stdarg.h stdint.h errno.h malloc.h mntent.h paths.h dirent.h getopt.h setjmp.h signal.h termios.h linux/fd.h linux/major.h sys/disklabel.h sys/ioctl.h sys/mman.h sys/mkdev.h sys/prctl.h sys/queue.h sys/sockio.h sys/socket.h sys/sysmacros.h sys/time.h sys/stat.h sys/types.h sys/wait.h sys/resource.h net/if_dl.h netinet/in.h utime.h)
 AC_CHECK_HEADERS(sys/disk.h sys/mount.h,,,
 [[
@@ -676,7 +677,7 @@ AC_CHECK_MEMBER(struct sockaddr.sa_len,
 	[#include <sys/types.h>
 	 #include <sys/socket.h>])
 dnl
-AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime)
+AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid)
 dnl
 dnl Check to see if -lsocket is required (solaris) to make something
 dnl that uses socket() to compile; this is needed for the UUID library
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
index 0bf778a..612c4ca 100644
--- a/debian/control
+++ b/debian/control
@@ -78,12 +78,26 @@ Package: libuuid1
 Section: libs
 Priority: required
 Depends: ${shlibs:Depends}
+Recommends: uuid-runtime
 Replaces: e2fsprogs (<< 1.34-1)
 Architecture: any
 Description: universally unique id library
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
diff --git a/debian/libuuid1.postinst b/debian/libuuid1.postinst
new file mode 100644
index 0000000..8559ffc
--- /dev/null
+++ b/debian/libuuid1.postinst
@@ -0,0 +1,8 @@
+#!/bin/sh
+
+adduser --system --group --no-create-home --disabled-login \
+	--quiet --home /var/lib/libuuid libuuid
+mkdir -p /var/lib/libuuid
+chown libuuid:libuuid /var/lib/libuuid
+chmod 2775 /var/lib/libuuid
+
diff --git a/debian/libuuid1.postrm b/debian/libuuid1.postrm
new file mode 100644
index 0000000..63d8370
--- /dev/null
+++ b/debian/libuuid1.postrm
@@ -0,0 +1,6 @@
+#!/bin/sh
+set -e
+if [ "$1" = purge ]
+then
+	rm -rf /var/lib/libuuid
+fi
diff --git a/debian/rules b/debian/rules
index 3e10091..b66555a 100755
--- a/debian/rules
+++ b/debian/rules
@@ -359,7 +359,7 @@ binary-arch: install install-udeb
 	DH_OPTIONS= dh_installchangelogs -pe2fsprogs \
 		-plibblkid${BLKID_SOVERSION} -plibcomerr${COMERR_SOVERSION} \
 		-plibss${SS_SOVERSION} -plibuuid${UUID_SOVERSION} \
-		-pe2fslibs -puuid-dev -pe2fsck-static
+		-pe2fslibs -puuid-dev -puuid-runtime -pe2fsck-static
 
 	dh_fixperms
 ifneq ($(ismips),)
diff --git a/debian/uuid-runtime.copyright b/debian/uuid-runtime.copyright
new file mode 100644
index 0000000..afcd4c5
--- /dev/null
+++ b/debian/uuid-runtime.copyright
@@ -0,0 +1,39 @@
+This package was added to the e2fsprogs debian source package by
+Theodore Ts'o <tytso@mit.edu> on Fri Dec 14 22:24:35 EST 2007
+
+It is part of the main e2fsprogs distribution, which can be found at:
+
+	http://sourceforge.net/projects/e2fsprogs
+
+Upstream Author: Theodore Ts'o <tytso@mit.edu>
+
+Copyright:
+
+Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007 by
+Theodore Ts'o
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
index 0000000..ff8d87a
--- /dev/null
+++ b/debian/uuid-runtime.files
@@ -0,0 +1,4 @@
+usr/bin/uuidgen
+usr/sbin/uuidd
+usr/share/man/man8/uuidd.*
+usr/share/man/man1/uuidgen.*
diff --git a/debian/uuid-runtime.postinst b/debian/uuid-runtime.postinst
new file mode 100644
index 0000000..4ab013a
--- /dev/null
+++ b/debian/uuid-runtime.postinst
@@ -0,0 +1,9 @@
+#!/bin/sh
+
+adduser --system --group --no-create-home --disabled-login \
+	--quiet --home /var/lib/libuuid libuuid
+mkdir -p /var/run/uuidd
+chown libuuid:libuuid /var/run/uuidd
+chmod 775 /var/run/uuidd
+chown libuuid:libuuid /usr/sbin/uuidd
+chmod 6755 /usr/sbin/uuidd
diff --git a/debian/uuid-runtime.postrm b/debian/uuid-runtime.postrm
new file mode 100644
index 0000000..62b1c7d
--- /dev/null
+++ b/debian/uuid-runtime.postrm
@@ -0,0 +1,7 @@
+#!/bin/sh
+set -e
+if [ "$1" = purge ]
+then
+	rm -rf /var/run/uuidd
+fi
+
diff --git a/debian/uuid-runtime.prerm b/debian/uuid-runtime.prerm
new file mode 100644
index 0000000..3788432
--- /dev/null
+++ b/debian/uuid-runtime.prerm
@@ -0,0 +1,6 @@
+#! /bin/sh
+
+if [ -x /usr/sbin/uuidd ]
+then
+	/usr/sbin/uuidd -k || true
+fi
diff --git a/debian/uuid-runtime.shlibs.local b/debian/uuid-runtime.shlibs.local
new file mode 100644
index 0000000..5d97674
--- /dev/null
+++ b/debian/uuid-runtime.shlibs.local
@@ -0,0 +1 @@
+libuuid 1 libuuid1 (> 1.40.3-1)
diff --git a/lib/uuid/gen_uuid.c b/lib/uuid/gen_uuid.c
index 61f2805..a84ae1c 100644
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
@@ -74,15 +76,22 @@
 #endif
 
 #include "uuidP.h"
+#include "uuidd.h"
 
 #ifdef HAVE_SRANDOM
 #define srand(x) 	srandom(x)
 #define rand() 		random()
 #endif
 
+#ifdef TLS
+#define THREAD_LOCAL static TLS
+#else
+#define THREAD_LOCAL static
+#endif
+
 #if defined(__linux__) && defined(__NR_gettid) && defined(HAVE_JRAND48)
 #define DO_JRAND_MIX
-static unsigned short jrand_seed[3];
+THREAD_LOCAL unsigned short jrand_seed[3];
 #endif
 
 static int get_random_fd(void)
@@ -247,22 +256,62 @@ static int get_node_id(unsigned char *node_id)
 /* Assume that the gettimeofday() has microsecond granularity */
 #define MAX_ADJUSTMENT 10
 
-static int get_clock(uint32_t *clock_high, uint32_t *clock_low, uint16_t *ret_clock_seq)
+static int get_clock(uint32_t *clock_high, uint32_t *clock_low,
+		     uint16_t *ret_clock_seq, int *num)
 {
-	static int			adjustment = 0;
-	static struct timeval		last = {0, 0};
-	static uint16_t			clock_seq;
+	THREAD_LOCAL int		adjustment = 0;
+	THREAD_LOCAL struct timeval	last = {0, 0};
+	THREAD_LOCAL int		state_fd = -2;
+	THREAD_LOCAL FILE		*state_f;
+	THREAD_LOCAL uint16_t		clock_seq;
 	struct timeval 			tv;
 	unsigned long long		clock_reg;
-	
-try_again:
-	gettimeofday(&tv, 0);
+	mode_t				save_umask;
+
+	if (state_fd == -2) {
+		save_umask = umask(0);
+		state_fd = open("/var/lib/libuuid/clock.txt",
+				O_RDWR|O_CREAT, 0660);
+		(void) umask(save_umask);
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
@@ -283,13 +332,124 @@ try_again:
 	clock_reg += ((unsigned long long) tv.tv_sec)*10000000;
 	clock_reg += (((unsigned long long) 0x01B21DD2) << 32) + 0x13814000;
 
+	if (num && (*num > 1)) {
+		adjustment += *num - 1;
+		last.tv_usec += adjustment / 10;
+		adjustment = adjustment % 10;
+		last.tv_sec += last.tv_usec / 1000000;
+		last.tv_usec = last.tv_usec % 1000000;
+	}
+
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
 	*clock_high = clock_reg >> 32;
 	*clock_low = clock_reg;
 	*ret_clock_seq = clock_seq;
 	return 0;
 }
 
-void uuid_generate_time(uuid_t out)
+static ssize_t read_all(int fd, char *buf, size_t count)
+{
+	ssize_t ret;
+	ssize_t c = 0;
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
+/*
+ * Try using the uuidd daemon to generate the UUID
+ *
+ * Returns 0 on success, non-zero on failure.
+ */
+static int get_uuid_via_daemon(int op, uuid_t out, int *num)
+{
+	char op_buf[64];
+	int op_len;
+	int s;
+	ssize_t ret;
+	int32_t reply_len = 0, expected = 16;
+	struct sockaddr_un srv_addr;
+	static const char *uuidd_path = UUIDD_PATH;
+	static int access_ret = -2;
+
+	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
+		return -1;
+
+	srv_addr.sun_family = AF_UNIX;
+	strcpy(srv_addr.sun_path, UUIDD_SOCKET_PATH);
+
+	if (connect(s, (const struct sockaddr *) &srv_addr,
+		    sizeof(struct sockaddr_un)) < 0) {
+		if (access_ret == -2)
+			access_ret = access(uuidd_path, X_OK);
+		if (access_ret == 0) {
+			if (fork() == 0) {
+				execl(uuidd_path, "uuidd", "-qT", "300", 0);
+				exit(1);
+			}
+			usleep(500);
+			if (connect(s, (const struct sockaddr *) &srv_addr,
+				    sizeof(struct sockaddr_un)) < 0)
+				goto fail;
+		} else
+			goto fail;
+	}
+	op_buf[0] = op;
+	op_len = 1;
+	if (op == UUIDD_OP_BULK_TIME_UUID) {
+		memcpy(op_buf+1, num, sizeof(num));
+		op_len += sizeof(num);
+		expected += sizeof(num);
+	}
+
+	ret = write(s, op_buf, op_len);
+	if (ret < 1)
+		goto fail;
+
+	ret = read_all(s, (char *) &reply_len, sizeof(reply_len));
+	if (ret < 0)
+		goto fail;
+
+	if (reply_len != expected)
+		goto fail;
+
+	ret = read_all(s, op_buf, reply_len);
+
+	if (op == UUIDD_OP_BULK_TIME_UUID)
+		memcpy(op_buf+16, num, sizeof(int));
+
+	memcpy(out, op_buf, 16);
+
+	close(s);
+	return ((ret == expected) ? 0 : -1);
+
+fail:
+	close(s);
+	return -1;
+}
+
+void uuid__generate_time(uuid_t out, int *num)
 {
 	static unsigned char node_id[6];
 	static int has_init = 0;
@@ -308,7 +468,7 @@ void uuid_generate_time(uuid_t out)
 		}
 		has_init = 1;
 	}
-	get_clock(&clock_mid, &uu.time_low, &uu.clock_seq);
+	get_clock(&clock_mid, &uu.time_low, &uu.clock_seq, num);
 	uu.clock_seq |= 0x8000;
 	uu.time_mid = (uint16_t) clock_mid;
 	uu.time_hi_and_version = ((clock_mid >> 16) & 0x0FFF) | 0x1000;
@@ -316,19 +476,82 @@ void uuid_generate_time(uuid_t out)
 	uuid_pack(&uu, out);
 }
 
-void uuid_generate_random(uuid_t out)
+void uuid_generate_time(uuid_t out)
+{
+#ifdef TLS
+	THREAD_LOCAL int		num = 0;
+	THREAD_LOCAL struct uuid	uu;
+	THREAD_LOCAL time_t		last_time = 0;
+	time_t				now;
+
+	if (num > 0) {
+		now = time(0);
+		if (now > last_time+1)
+			num = 0;
+	}
+	if (num <= 0) {
+		num = 1000;
+		if (get_uuid_via_daemon(UUIDD_OP_BULK_TIME_UUID,
+					out, &num) == 0) {
+			last_time = time(0);
+			uuid_unpack(out, &uu);
+			num--;
+			return;
+		}
+		num = 0;
+	}
+	if (num > 0) {
+		uu.time_low++;
+		if (uu.time_low == 0) {
+			uu.time_mid++;
+			if (uu.time_mid == 0)
+				uu.time_hi_and_version++;
+		}
+		num--;
+		uuid_pack(&uu, out);
+		return;
+	}
+#else
+	if (get_uuid_via_daemon(UUIDD_OP_TIME_UUID, out, 0) == 0)
+		return;
+#endif
+
+	uuid__generate_time(out, 0);
+}
+
+
+void uuid__generate_random(uuid_t out, int *num)
 {
 	uuid_t	buf;
 	struct uuid uu;
+	int i, n;
 
-	get_random_bytes(buf, sizeof(buf));
-	uuid_unpack(buf, &uu);
+	if (!num || !*num)
+		n = 1;
+	else
+		n = *num;
 
-	uu.clock_seq = (uu.clock_seq & 0x3FFF) | 0x8000;
-	uu.time_hi_and_version = (uu.time_hi_and_version & 0x0FFF) | 0x4000;
-	uuid_pack(&uu, out);
+	for (i = 0; i < n; i++) {
+		get_random_bytes(buf, sizeof(buf));
+		uuid_unpack(buf, &uu);
+
+		uu.clock_seq = (uu.clock_seq & 0x3FFF) | 0x8000;
+		uu.time_hi_and_version = (uu.time_hi_and_version & 0x0FFF)
+			| 0x4000;
+		uuid_pack(&uu, out);
+		out += sizeof(uuid_t);
+	}
 }
 
+void uuid_generate_random(uuid_t out)
+{
+	int	num = 1;
+	/* No real reason to use the daemon for random uuid's -- yet */
+
+	uuid__generate_random(out, &num);
+}
+
+
 /*
  * This is the generic front-end to uuid_generate_random and
  * uuid_generate_time.  It uses uuid_generate_random only if
diff --git a/lib/uuid/uuidd.h b/lib/uuid/uuidd.h
new file mode 100644
index 0000000..c807236
--- /dev/null
+++ b/lib/uuid/uuidd.h
@@ -0,0 +1,53 @@
+/*
+ * Definitions used by the uuidd daemon
+ *
+ * Copyright (C) 2007 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ * %End-Header%
+ */
+
+#ifndef _UUID_UUIDD_H
+#define _UUID_UUIDD_H
+
+#define UUIDD_SOCKET_PATH	"/var/run/uuidd/request"
+#define UUIDD_PIDFILE_PATH	"/var/run/uuidd/uuidd.pid"
+#define UUIDD_PATH		"/usr/sbin/uuidd"
+
+#define UUIDD_OP_GETPID			0
+#define UUIDD_OP_GET_MAXOP		1
+#define UUIDD_OP_TIME_UUID		2
+#define UUIDD_OP_RANDOM_UUID		3
+#define UUIDD_OP_BULK_TIME_UUID		4
+#define UUIDD_OP_BULK_RANDOM_UUID	5
+#define UUIDD_MAX_OP			UUIDD_OP_BULK_RANDOM_UUID
+
+extern void uuid__generate_time(uuid_t out, int *num);
+extern void uuid__generate_random(uuid_t out, int *num);
+
+#endif /* _UUID_UUID_H */
diff --git a/misc/Makefile.in b/misc/Makefile.in
index db18985..1d4444a 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -15,11 +15,11 @@ INSTALL = @INSTALL@
 @IMAGER_CMT@E2IMAGE_MAN= e2image.8
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs blkid logsave \
-			$(E2IMAGE_PROG) @FSCK_PROG@ 
-USPROGS=	mklost+found filefrag
+			$(E2IMAGE_PROG) @FSCK_PROG@
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
diff --git a/misc/uuidd.8.in b/misc/uuidd.8.in
new file mode 100644
index 0000000..e45297d
--- /dev/null
+++ b/misc/uuidd.8.in
@@ -0,0 +1,97 @@
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
+[
+.B \-T
+.I timeout
+]
+
+.B uuidd
+[
+.B \-r
+|
+.B \-t
+]
+[
+.B \-n
+.I number
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
+.BI \-n " number"
+When issuing a test request to a running uuidd, request a bulk response
+of
+.I number
+UUID's.
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
+.TP
+.BI \-T " timeout"
+Specify a timeout for uuidd.  If specified, then uuidd will exit after
+.I timeout
+seconds of inactivity.
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
index 0000000..19c8624
--- /dev/null
+++ b/misc/uuidd.c
@@ -0,0 +1,518 @@
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
+#include "uuid/uuidd.h"
+#include "nls-enable.h"
+
+#ifdef __GNUC__
+#define CODE_ATTR(x) __attribute__(x)
+#else
+#define CODE_ATTR(x)
+#endif
+
+static void usage(const char *progname)
+{
+	fprintf(stderr, _("Usage: %s [-d] [-p pidfile] [-s socketpath] "
+			  "[-T timeout]\n"), progname);
+	fprintf(stderr, _("       %s [-r|t] [-n num] [-s socketpath]\n"),
+		progname);
+	fprintf(stderr, _("       %s -k\n"), progname);
+	exit(1);
+}
+
+static void create_daemon(const char *pidfile_path)
+{
+	pid_t pid;
+	uid_t euid;
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
+	euid = geteuid();
+	(void) setreuid(euid, euid);
+
+	f = fopen(pidfile_path, "w");
+	if (f) {
+		fprintf(f, "%d\n", getpid());
+		fclose(f);
+	}
+}
+
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
+static const char *cleanup_pidfile, *cleanup_socket;
+
+static void terminate_intr(int signo CODE_ATTR((unused)))
+{
+	(void) unlink(cleanup_pidfile);
+	(void) unlink(cleanup_socket);
+	exit(0);
+}
+
+static void server_loop(const char *socket_path, int debug,
+			const char *pidfile_path,
+			int timeout, int quiet)
+{
+	struct sockaddr_un	my_addr, from_addr;
+	unsigned char		reply_buf[1024], *cp;
+	socklen_t		fromlen;
+	int32_t			reply_len = 0;
+	uuid_t			uu;
+	mode_t			save_umask;
+	char			op, str[37];
+	int			i, s, ns, len, num;
+
+	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
+		if (!quiet)
+			fprintf(stderr, _("Couldn't create unix stream "
+					  "socket: %s"), strerror(errno));
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
+		if (!quiet)
+			fprintf(stderr,
+				_("Couldn't bind unix socket %s: %s\n"),
+				socket_path, strerror(errno));
+		exit(1);
+	}
+	(void) umask(save_umask);
+
+	if (listen(s, 5) < 0) {
+		if (!quiet)
+			fprintf(stderr, _("Couldn't listen on unix "
+					  "socket %s: %s\n"), socket_path,
+				strerror(errno));
+		exit(1);
+	}
+
+	if (!debug) {
+		create_daemon(pidfile_path);
+		cleanup_pidfile = pidfile_path;
+		cleanup_socket = socket_path;
+		signal(SIGHUP, terminate_intr);
+		signal(SIGINT, terminate_intr);
+		signal(SIGPIPE, terminate_intr);
+		signal(SIGTERM, terminate_intr);
+		signal(SIGALRM, terminate_intr);
+	}
+	signal(SIGPIPE, SIG_IGN);
+
+	while (1) {
+		fromlen = sizeof(from_addr);
+		if (timeout > 0)
+			alarm(timeout);
+		ns = accept(s, (struct sockaddr *) &from_addr, &fromlen);
+		alarm(0);
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
+				printf(_("Error reading from client, "
+					 "len = %d\n"), len);
+			goto shutdown_socket;
+		}
+		if ((op == 4) || (op == 5)) {
+			if (read_all(ns, (char *) &num, sizeof(num)) != 4)
+				goto shutdown_socket;
+			if (debug)
+				printf(_("operation %d, incoming num = %d\n"),
+				       op, num);
+		} else if (debug)
+			printf("operation %d\n", op);
+
+		switch(op) {
+		case UUIDD_OP_GETPID:
+			sprintf((char *) reply_buf, "%d", getpid());
+			reply_len = strlen((char *) reply_buf)+1;
+			break;
+		case UUIDD_OP_GET_MAXOP:
+			sprintf((char *) reply_buf, "%d", UUIDD_MAX_OP);
+			reply_len = strlen((char *) reply_buf)+1;
+			break;
+		case UUIDD_OP_TIME_UUID:
+			num = 1;
+			uuid__generate_time(uu, &num);
+			if (debug) {
+				uuid_unparse(uu, str);
+				printf(_("Generated time UUID: %s\n"), str);
+			}
+			memcpy(reply_buf, uu, sizeof(uu));
+			reply_len = sizeof(uu);
+			break;
+		case UUIDD_OP_RANDOM_UUID:
+			num = 1;
+			uuid__generate_random(uu, &num);
+			if (debug) {
+				uuid_unparse(uu, str);
+				printf(_("Generated random UUID: %s\n"), str);
+			}
+			memcpy(reply_buf, uu, sizeof(uu));
+			reply_len = sizeof(uu);
+			break;
+		case UUIDD_OP_BULK_TIME_UUID:
+			uuid__generate_time(uu, &num);
+			if (debug) {
+				uuid_unparse(uu, str);
+				printf(_("Generated time UUID %s and %d "
+					 "following\n"), str, num);
+			}
+			memcpy(reply_buf, uu, sizeof(uu));
+			reply_len = sizeof(uu);
+			memcpy(reply_buf+reply_len, &num, sizeof(num));
+			reply_len += sizeof(num);
+			break;
+		case UUIDD_OP_BULK_RANDOM_UUID:
+			if (num < 0)
+				num = 1;
+			if (num > 1000)
+				num = 1000;
+			if (num*16 > (int) (sizeof(reply_buf)-sizeof(num)))
+				num = (sizeof(reply_buf)-sizeof(num)) / 16;
+			uuid__generate_random(reply_buf+sizeof(num), &num);
+			if (debug) {
+				printf(_("Generated %d UUID's:\n"), num);
+				for (i=0, cp=reply_buf+sizeof(num);
+				     i < num; i++, cp+=16) {
+					uuid_unparse(cp, str);
+					printf("\t%s\n", str);
+				}
+			}
+			reply_len = (num*16) + sizeof(num);
+			memcpy(reply_buf, &num, sizeof(num));
+			break;
+		default:
+			if (debug)
+				printf(_("Invalid operation %d\n"), op);
+			goto shutdown_socket;
+		}
+		write(ns, &reply_len, sizeof(reply_len));
+		write(ns, reply_buf, reply_len);
+	shutdown_socket:
+		close(ns);
+	}
+}
+
+static int call_daemon(const char *socket_path, int op, unsigned char *buf,
+		       int buflen, int *num, const char **err_context)
+{
+	char op_buf[8];
+	int op_len;
+	int s;
+	ssize_t ret;
+	int32_t reply_len = 0;
+	struct sockaddr_un srv_addr;
+
+	if (((op == 4) || (op == 5)) && !num) {
+		if (err_context)
+			*err_context = _("bad arguments");
+		errno = EINVAL;
+		return -1;
+	}
+
+	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
+		if (err_context)
+			*err_context = _("socket");
+		return -1;
+	}
+
+	srv_addr.sun_family = AF_UNIX;
+	strcpy(srv_addr.sun_path, socket_path);
+
+	if (connect(s, (const struct sockaddr *) &srv_addr,
+		    sizeof(struct sockaddr_un)) < 0) {
+		if (err_context)
+			*err_context = _("connect");
+		close(s);
+		return -1;
+	}
+
+	if (op == 5) {
+		if ((*num)*16 > buflen-4)
+			*num = (buflen-4) / 16;
+	}
+	op_buf[0] = op;
+	op_len = 1;
+	if ((op == 4) || (op == 5)) {
+		memcpy(op_buf+1, num, sizeof(int));
+		op_len += sizeof(int);
+	}
+
+	ret = write(s, op_buf, op_len);
+	if (ret < op_len) {
+		if (err_context)
+			*err_context = _("write");
+		close(s);
+		return -1;
+	}
+
+	ret = read_all(s, (char *) &reply_len, sizeof(reply_len));
+	if (ret < 0) {
+		if (err_context)
+			*err_context = _("read count");
+		close(s);
+		return -1;
+	}
+	if (reply_len < 0 || reply_len > buflen) {
+		if (err_context)
+			*err_context = _("bad response length");
+		close(s);
+		return -1;
+	}
+	ret = read_all(s, (char *) buf, reply_len);
+
+	if ((ret > 0) && (op == 4)) {
+		if (reply_len >= (int) (16+sizeof(int)))
+			memcpy(buf+16, num, sizeof(int));
+		else
+			*num = -1;
+	}
+	if ((ret > 0) && (op == 5)) {
+		if (*num >= (int) sizeof(int))
+			memcpy(buf, num, sizeof(int));
+		else
+			*num = -1;
+	}
+
+	close(s);
+
+	return ret;
+}
+
+
+int main(int argc, char **argv)
+{
+	const char	*socket_path = UUIDD_SOCKET_PATH;
+	const char	*pidfile_path = UUIDD_PIDFILE_PATH;
+	const char	*err_context;
+	unsigned char	buf[1024], *cp;
+	char   		str[37], *tmp;
+	uuid_t		uu;
+	uid_t		uid;
+	gid_t 		gid;
+	int		i, c, ret;
+	int		debug = 0, do_type = 0, do_kill = 0, num = 0;
+	int		timeout = 0, quiet = 0, drop_privs = 0;
+
+#ifdef ENABLE_NLS
+	setlocale(LC_MESSAGES, "");
+	setlocale(LC_CTYPE, "");
+	bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
+	textdomain(NLS_CAT_NAME);
+#endif
+
+	while ((c = getopt (argc, argv, "dkn:qp:s:tT:r")) != EOF) {
+		switch (c) {
+		case 'd':
+			debug++;
+			drop_privs++;
+			break;
+		case 'k':
+			do_kill++;
+			drop_privs++;
+			break;
+		case 'n':
+			num = strtol(optarg, &tmp, 0);
+			if ((num < 0) || *tmp) {
+				fprintf(stderr, _("Bad number: %s\n"), optarg);
+				exit(1);
+			}
+		case 'p':
+			pidfile_path = optarg;
+			drop_privs++;
+			break;
+		case 'q':
+			quiet++;
+			break;
+		case 's':
+			socket_path = optarg;
+			drop_privs++;
+			break;
+		case 't':
+			do_type = UUIDD_OP_TIME_UUID;
+			drop_privs++;
+			break;
+		case 'T':
+			timeout = strtol(optarg, &tmp, 0);
+			if ((timeout < 0) || *tmp) {
+				fprintf(stderr, _("Bad number: %s\n"), optarg);
+				exit(1);
+			}
+			break;
+		case 'r':
+			do_type = UUIDD_OP_RANDOM_UUID;
+			drop_privs++;
+			break;
+		default:
+			usage(argv[0]);
+		}
+	}
+	uid = getuid();
+	if (uid && drop_privs) {
+		gid = getgid();
+#ifdef HAVE_SETRESUID
+		setresuid(uid, uid, uid);
+#else
+		setreuid(uid, uid);
+#endif
+#ifdef HAVE_SETRESGID
+		setresgid(gid, gid, gid);
+#else
+		setregid(gid, gid);
+#endif
+	}
+	if (num && do_type) {
+		ret = call_daemon(socket_path, do_type+2, buf,
+				  sizeof(buf), &num, &err_context);
+		if (ret < 0) {
+			printf(_("Error calling uuidd daemon (%s): %s\n"),
+			       err_context, strerror(errno));
+			exit(1);
+		}
+		if (do_type == UUIDD_OP_TIME_UUID) {
+			if (ret != sizeof(uu) + sizeof(num))
+				goto unexpected_size;
+
+			uuid_unparse(buf, str);
+
+			printf(_("%s and subsequent %d UUID's\n"), str, num);
+		} else {
+			printf(_("List of UUID's:\n"));
+			cp = buf + 4;
+			if (ret != sizeof(num) + num*sizeof(uu))
+				goto unexpected_size;
+			for (i=0; i < num; i++, cp+=16) {
+				uuid_unparse(cp, str);
+				printf("\t%s\n", str);
+			}
+		}
+		exit(0);
+	}
+	if (do_type) {
+		ret = call_daemon(socket_path, do_type, (unsigned char *) &uu,
+				  sizeof(uu), 0, &err_context);
+		if (ret < 0) {
+			printf(_("Error calling uuidd daemon (%s): %s\n"),
+			       err_context, strerror(errno));
+			exit(1);
+		}
+		if (ret != sizeof(uu)) {
+		unexpected_size:
+			printf(_("Unexpected reply length from server %d\n"),
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
+	ret = call_daemon(socket_path, 0, buf, sizeof(buf), 0, 0);
+	if (ret > 0) {
+		if (do_kill && ((do_kill = atoi((char *) buf)) > 0)) {
+			ret = kill(do_kill, SIGTERM);
+			if (ret < 0) {
+				if (!quiet)
+					fprintf(stderr,
+						_("Couldn't kill uuidd running "
+						  "at pid %d: %s\n"), do_kill,
+						strerror(errno));
+				exit(1);
+			}
+			if (!quiet)
+				printf(_("Killed uuidd running at pid %d\n"),
+				       do_kill);
+			exit(0);
+		}
+		if (!quiet)
+			printf(_("uuidd daemon already running at pid %s\n"),
+			       buf);
+		exit(1);
+	}
+	if (do_kill)
+		exit(0);	/* Nothing to kill */
+
+	server_loop(socket_path, debug, pidfile_path, timeout, quiet);
+	return 0;
+}
diff --git a/misc/uuidd.rc b/misc/uuidd.rc
new file mode 100644
index 0000000..d35645a
--- /dev/null
+++ b/misc/uuidd.rc
@@ -0,0 +1,55 @@
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
+PIDFILE=/var/run/uuidd/uuidd.pid
+
+test -x $DAEMON || exit 0
+
+. /lib/lsb/init-functions
+
+case "$1" in
+    start)
+	log_daemon_msg "Starting uuid generator" "uuidd"
+	start_daemon -p $PIDFILE $DAEMON
+	log_end_msg $?
+    ;;
+  stop)
+	log_daemon_msg "Stopping uuidd generator" "uuidd"
+	killproc -p $PIDFILE $DAEMON
+	log_end_msg $?
+    ;;
+  status)
+	if pidofproc -p $PIDFILE $DAEMON >& /dev/null ; then
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
