From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] uuidd: Fix issues identified by SuSE's security team
Date: Fri, 14 Mar 2008 14:20:57 -0400
Message-ID: <1205518857-25272-1-git-send-email-tytso@mit.edu>
References: <n7xlk4lh8ff.fsf@sor.suse.de>
Cc: Matthias Koenig <mkoenig@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51741 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbYCNSU7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2008 14:20:59 -0400
In-Reply-To: <n7xlk4lh8ff.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Matthias Koenig <mkoenig@suse.de>

SuSE's security team audited uuidd and came up with these issues.
None of them are serious given that uuidd runs setuid as a
unprivileged user which has no special access other than libuuid
directory, but it's good to get them fixed.

Signed-off-by: Matthias Koenig <mkoenig@suse.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/uuidd.c |   44 +++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/misc/uuidd.c b/misc/uuidd.c
index 1b2dedd..c964b4e 100644
--- a/misc/uuidd.c
+++ b/misc/uuidd.c
@@ -52,6 +52,12 @@ static void usage(const char *progname)
 	exit(1);
 }
 
+static void die(const char *msg)
+{
+	perror(msg);
+	exit(1);
+}
+
 static void create_daemon(void)
 {
 	pid_t pid;
@@ -75,7 +81,8 @@ static void create_daemon(void)
 	chdir("/");
 	(void) setsid();
 	euid = geteuid();
-	(void) setreuid(euid, euid);
+	if (setreuid(euid, euid) < 0)
+		die("setreuid");
 }
 
 static int read_all(int fd, char *buf, size_t count)
@@ -132,7 +139,8 @@ static int call_daemon(const char *socket_path, int op, char *buf,
 	}
 
 	srv_addr.sun_family = AF_UNIX;
-	strcpy(srv_addr.sun_path, socket_path);
+	strncpy(srv_addr.sun_path, socket_path, sizeof(srv_addr.sun_path));
+	srv_addr.sun_path[sizeof(srv_addr.sun_path)-1] = '\0';
 
 	if (connect(s, (const struct sockaddr *) &srv_addr,
 		    sizeof(struct sockaddr_un)) < 0) {
@@ -252,7 +260,8 @@ static void server_loop(const char *socket_path, const char *pidfile_path,
 	 * Create the address we will be binding to.
 	 */
 	my_addr.sun_family = AF_UNIX;
-	strcpy(my_addr.sun_path, socket_path);
+	strncpy(my_addr.sun_path, socket_path, sizeof(my_addr.sun_path));
+	my_addr.sun_path[sizeof(my_addr.sun_path)-1] = '\0';
 	(void) unlink(socket_path);
 	save_umask = umask(0);
 	if (bind(s, (const struct sockaddr *) &my_addr,
@@ -415,11 +424,11 @@ int main(int argc, char **argv)
 		switch (c) {
 		case 'd':
 			debug++;
-			drop_privs++;
+			drop_privs = 1;
 			break;
 		case 'k':
 			do_kill++;
-			drop_privs++;
+			drop_privs = 1;
 			break;
 		case 'n':
 			num = strtol(optarg, &tmp, 0);
@@ -429,18 +438,18 @@ int main(int argc, char **argv)
 			}
 		case 'p':
 			pidfile_path = optarg;
-			drop_privs++;
+			drop_privs = 1;
 			break;
 		case 'q':
 			quiet++;
 			break;
 		case 's':
 			socket_path = optarg;
-			drop_privs++;
+			drop_privs = 1;
 			break;
 		case 't':
 			do_type = UUIDD_OP_TIME_UUID;
-			drop_privs++;
+			drop_privs = 1;
 			break;
 		case 'T':
 			timeout = strtol(optarg, &tmp, 0);
@@ -451,7 +460,7 @@ int main(int argc, char **argv)
 			break;
 		case 'r':
 			do_type = UUIDD_OP_RANDOM_UUID;
-			drop_privs++;
+			drop_privs = 1;
 			break;
 		default:
 			usage(argv[0]);
@@ -460,15 +469,20 @@ int main(int argc, char **argv)
 	uid = getuid();
 	if (uid && drop_privs) {
 		gid = getgid();
-#ifdef HAVE_SETRESUID
-		setresuid(uid, uid, uid);
+#ifdef HAVE_SETRESGID
+		if (setresgid(gid, gid, gid) < 0)
+			die("setresgid");
 #else
-		setreuid(uid, uid);
+		if (setregid(gid, gid) < 0)
+			die("setregid");
 #endif
-#ifdef HAVE_SETRESGID
-		setresgid(gid, gid, gid);
+	
+#ifdef HAVE_SETRESUID
+		if (setresuid(uid, uid, uid) < 0)
+			die("setresuid");
 #else
-		setregid(gid, gid);
+		if (setreuid(uid, uid) < 0)
+			die("setreuid");
 #endif
 	}
 	if (num && do_type) {
-- 
1.5.4.1.144.gdfee-dirty

