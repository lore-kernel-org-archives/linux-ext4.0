From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 1/4] Allow debugfs to be extended for use by test programs
Date: Sun, 16 Sep 2007 22:57:38 -0400
Message-ID: <11899978613069-git-send-email-tytso@mit.edu>
References: <1189997861181-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33737 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbXIQC5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Sep 2007 22:57:48 -0400
In-Reply-To: <1189997861181-git-send-email-tytso@mit.edu>
Message-Id: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This change allows debugfs to be reused as the base for e2fsprogs
internal test programs, by linking debugfs object files with
additional object file(s) that define additional commands.  The test
program's object file(s) should define their own comand table, and
define the symbol extra_cmds to be a pointer to the ss_request_table.
In addition, the symbol debug_prog_name can be used to override the
name of the program printed in the version banner and in the ss
prompt.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debugfs.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..76542d8 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -38,6 +38,8 @@ extern char *optarg;
 #include "../version.h"
 
 extern ss_request_table debug_cmds;
+ss_request_table *extra_cmds;
+char *debug_prog_name;
 
 ext2_filsys	current_fs = NULL;
 ext2_ino_t	root, cwd;
@@ -1802,7 +1804,7 @@ int main(int argc, char **argv)
 {
 	int		retval;
 	int		sci_idx;
-	const char	*usage = "Usage: debugfs [-b blocksize] [-s superblock] [-f cmd_file] [-R request] [-V] [[-w] [-c] device]";
+	const char	*usage = "Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] [-R request] [-V] [[-w] [-c] device]";
 	int		c;
 	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES;
 	char		*request = 0;
@@ -1813,9 +1815,12 @@ int main(int argc, char **argv)
 	int		catastrophic = 0;
 	char		*data_filename = 0;
 	
+	if (debug_prog_name == 0)
+		debug_prog_name = "debugfs";
+
 	add_error_table(&et_ext2_error_table);
-	fprintf (stderr, "debugfs %s (%s)\n", E2FSPROGS_VERSION,
-		 E2FSPROGS_DATE);
+	fprintf (stderr, "%s %s (%s)\n", debug_prog_name, 
+		 E2FSPROGS_VERSION, E2FSPROGS_DATE);
 
 	while ((c = getopt (argc, argv, "iwcR:f:b:s:Vd:")) != EOF) {
 		switch (c) {
@@ -1851,7 +1856,7 @@ int main(int argc, char **argv)
 				error_message(EXT2_ET_BASE));
 			exit(0);
 		default:
-			com_err(argv[0], 0, usage);
+			com_err(argv[0], 0, usage, debug_prog_name);
 			return 1;
 		}
 	}
@@ -1860,7 +1865,7 @@ int main(int argc, char **argv)
 				superblock, blocksize, catastrophic,
 				data_filename);
 	
-	sci_idx = ss_create_invocation("debugfs", "0.0", (char *) NULL,
+	sci_idx = ss_create_invocation(debug_prog_name, "0.0", (char *) NULL,
 				       &debug_cmds, &retval);
 	if (retval) {
 		ss_perror(sci_idx, retval, "creating invocation");
@@ -1873,6 +1878,12 @@ int main(int argc, char **argv)
 		ss_perror(sci_idx, retval, "adding standard requests");
 		exit (1);
 	}
+	if (extra_cmds)
+		ss_add_request_table (sci_idx, extra_cmds, 1, &retval);
+	if (retval) {
+		ss_perror(sci_idx, retval, "adding extra requests");
+		exit (1);
+	}
 	if (request) {
 		retval = 0;
 		retval = ss_execute_line(sci_idx, request);
-- 
1.5.3.1.19.gb5ef6
