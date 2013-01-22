From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] contrib: add safe_getenv() support to spd_readdir
Date: Mon, 21 Jan 2013 19:09:48 -0500
Message-ID: <1358813390-26466-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44696 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723Ab3AVAJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 19:09:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is part of a series of improvements from a 2008 version of
spd_readdir.c that somehow didn't make it into the version which we
checked into e2fsprogs git tree.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 contrib/spd_readdir.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/contrib/spd_readdir.c b/contrib/spd_readdir.c
index f89832c..30c01b3 100644
--- a/contrib/spd_readdir.c
+++ b/contrib/spd_readdir.c
@@ -27,6 +27,10 @@
 #define MAX_DIRSIZE	0
 
 #define DEBUG
+/* Util we autoconfiscate spd_readdir... */
+#define HAVE___SECURE_GETENV	1
+#define HAVE_PRCTL		1
+#define HAVE_SYS_PRCTL_H	1
 
 #ifdef DEBUG
 #define DEBUG_DIR(x)	{if (do_debug) { x; }}
@@ -46,6 +50,11 @@
 #include <dirent.h>
 #include <errno.h>
 #include <dlfcn.h>
+#ifdef HAVE_SYS_PRCTL_H
+#include <sys/prctl.h>
+#else
+#define PR_GET_DUMPABLE 3
+#endif
 
 struct dirent_s {
 	unsigned long long d_ino;
@@ -83,6 +92,27 @@ static int num_open = 0;
 static int do_debug = 0;
 #endif
 
+static char *safe_getenv(const char *arg)
+{
+	if ((getuid() != geteuid()) || (getgid() != getegid()))
+		return NULL;
+#if HAVE_PRCTL
+	if (prctl(PR_GET_DUMPABLE, 0, 0, 0, 0) == 0)
+		return NULL;
+#else
+#if (defined(linux) && defined(SYS_prctl))
+	if (syscall(SYS_prctl, PR_GET_DUMPABLE, 0, 0, 0, 0) == 0)
+		return NULL;
+#endif
+#endif
+
+#if HAVE___SECURE_GETENV
+	return __secure_getenv(arg);
+#else
+	return getenv(arg);
+#endif
+}
+
 static void setup_ptr()
 {
 	char *cp;
@@ -97,11 +127,11 @@ static void setup_ptr()
 	real_telldir = dlsym(RTLD_NEXT, "telldir");
 	real_seekdir = dlsym(RTLD_NEXT, "seekdir");
 	real_dirfd = dlsym(RTLD_NEXT, "dirfd");
-	if ((cp = getenv("SPD_READDIR_MAX_SIZE")) != NULL) {
+	if ((cp = safe_getenv("SPD_READDIR_MAX_SIZE")) != NULL) {
 		max_dirsize = atol(cp);
 	}
 #ifdef DEBUG
-	if (getenv("SPD_READDIR_DEBUG")) {
+	if (safe_getenv("SPD_READDIR_DEBUG")) {
 		printf("initialized!\n");
 		do_debug++;
 	}
-- 
1.7.12.rc0.22.gcdd159b

