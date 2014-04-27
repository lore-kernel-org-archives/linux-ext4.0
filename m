From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/7] mke2fs: proceed if the user doesn't type anything after 5 seconds
Date: Sat, 26 Apr 2014 20:00:32 -0400
Message-ID: <1398556834-31913-5-git-send-email-tytso@mit.edu>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34711 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaD0AAv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2014 20:00:51 -0400
In-Reply-To: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If mke2fs needs to ask the user for permission, and the user doesn't
type anything for five seconds, proceed as if the user had said yes.

This will allow us to add more stringent checks without breaking
existing scripts (much).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c  | 12 ++++++++----
 misc/tune2fs.c |  2 +-
 misc/util.c    | 29 ++++++++++++++++++++++++++---
 misc/util.h    |  2 +-
 4 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a2b1f65..799132a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -102,6 +102,7 @@ static __u32	fs_stride;
 static int	quotatype = -1;  /* Initialize both user and group quotas by default */
 static __u64	offset;
 static blk64_t journal_location = ~0LL;
+static int	proceed_delay = -1;
 
 static struct ext2_super_block fs_param;
 static char *fs_uuid = NULL;
@@ -1749,9 +1750,12 @@ profile_error:
 	if (optind < argc)
 		usage();
 
+	profile_get_integer(profile, "options", "proceed_delay", 0, 5,
+			    &proceed_delay);
+
 	if (!check_plausibility(device_name, CREATE_FILE,
 				&is_device) && !force)
-		proceed_question();
+		proceed_question(proceed_delay);
 
 	check_mount(device_name, force, _("filesystem"));
 
@@ -1797,7 +1801,7 @@ profile_error:
 	} else if (!force && is_device && (fs_blocks_count > dev_size)) {
 		com_err(program_name, 0, "%s",
 			_("Filesystem larger than apparent device size."));
-		proceed_question();
+		proceed_question(proceed_delay);
 	}
 
 	if (!fs_type)
@@ -2071,7 +2075,7 @@ profile_error:
 			com_err(program_name, 0,
 				_("%d-byte blocks too big for system (max %d)"),
 				blocksize, sys_page_size);
-			proceed_question();
+			proceed_question(proceed_delay);
 		}
 		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
 				  "(max %d), forced to continue\n"),
@@ -2785,7 +2789,7 @@ int main (int argc, char *argv[])
 
 		if (!check_plausibility(journal_device, CHECK_BLOCK_DEV,
 					NULL) && !force)
-			proceed_question();
+			proceed_question(proceed_delay);
 		check_mount(journal_device, force, _("journal"));
 
 		retval = ext2fs_open(journal_device, EXT2_FLAG_RW|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index fbf5f52..7b3723b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -675,7 +675,7 @@ static int add_journal(ext2_filsys fs)
 	if (journal_device) {
 		if (!check_plausibility(journal_device, CHECK_BLOCK_DEV,
 					NULL))
-			proceed_question();
+			proceed_question(-1);
 		check_mount(journal_device, 0, _("journal"));
 #ifdef CONFIG_TESTIO_DEBUG
 		if (getenv("TEST_IO_FLAGS") || getenv("TEST_IO_BLOCK")) {
diff --git a/misc/util.c b/misc/util.c
index f85942e..afb0058 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -14,6 +14,8 @@
 
 #include "config.h"
 #include <fcntl.h>
+#include <setjmp.h>
+#include <signal.h>
 #include <stdio.h>
 #include <string.h>
 #ifdef HAVE_ERRNO_H
@@ -68,18 +70,39 @@ char *get_progname(char *argv_zero)
 		return cp+1;
 }
 
-void proceed_question(void)
+static jmp_buf alarm_env;
+
+static void alarm_signal(int signal)
+{
+	longjmp(alarm_env, 1);
+}
+
+void proceed_question(int delay)
 {
 	char buf[256];
 	const char *short_yes = _("yY");
 
 	fflush(stdout);
 	fflush(stderr);
-	fputs(_("Proceed anyway? (y,n) "), stdout);
+	if (delay > 0) {
+		if (setjmp(alarm_env)) {
+			signal(SIGALRM, SIG_IGN);
+			printf(_("<proceeding>\n"));
+			return;
+		}
+		signal(SIGALRM, alarm_signal);
+		printf(_("Proceed anyway (or wait %d seconds) ? (y,n) "),
+		       delay);
+		alarm(delay);
+	} else
+		fputs(_("Proceed anyway? (y,n) "), stdout);
 	buf[0] = 0;
 	if (!fgets(buf, sizeof(buf), stdin) ||
-	    strchr(short_yes, buf[0]) == 0)
+	    strchr(short_yes, buf[0]) == 0) {
+		putc('\n', stdout);
 		exit(1);
+	}
+	signal(SIGALRM, SIG_IGN);
 }
 
 /*
diff --git a/misc/util.h b/misc/util.h
index b80d489..9de3fbf 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -25,7 +25,7 @@ extern char	*journal_location_string;
 extern int strcasecmp (char *s1, char *s2);
 #endif
 extern char *get_progname(char *argv_zero);
-extern void proceed_question(void);
+extern void proceed_question(int delay);
 extern int check_plausibility(const char *device, int flags,
 			      int *ret_is_dev);
 extern void parse_journal_opts(const char *opts);
-- 
1.9.0

