From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] mke2fs: fix up the commit "mke2fs.c: add an option: -d root-directory"
Date: Mon, 14 Oct 2013 08:22:15 -0400
Message-ID: <1381753335-13449-1-git-send-email-tytso@mit.edu>
References: <20131014024126.GA24871@thunk.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: liezhi.yang@windriver.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45854 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab3JNMWS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Oct 2013 08:22:18 -0400
In-Reply-To: <20131014024126.GA24871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise lots of test failures!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d82ccbb..28537da 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2779,26 +2779,8 @@ no_journal:
 				       EXT4_FEATURE_RO_COMPAT_QUOTA))
 		create_quota_inodes(fs);
 
-	if (!quiet)
-		printf(_("Writing superblocks and "
-		       "filesystem accounting information: "));
 	checkinterval = fs->super->s_checkinterval;
 	max_mnt_count = fs->super->s_max_mnt_count;
-	if (retval) {
-		fprintf(stderr,
-			_("\nWarning, had trouble writing out superblocks."));
-	} else if (!quiet) {
-		printf(_("done\n\n"));
-		if (!getenv("MKE2FS_SKIP_CHECK_MSG"))
-			print_check_message(max_mnt_count, checkinterval);
-	}
-
-	remove_error_table(&et_ext2_error_table);
-	remove_error_table(&et_prof_error_table);
-	profile_release(profile);
-	for (i=0; fs_types[i]; i++)
-		free(fs_types[i]);
-	free(fs_types);
 
 	/* Copy files from the specified directory */
 	if (root_dir) {
@@ -2824,7 +2806,25 @@ no_journal:
 				_("\nError while populating %s"), root_dir);
 	}
 
+	if (!quiet)
+		printf(_("Writing superblocks and "
+		       "filesystem accounting information: "));
 	retval = ext2fs_close(fs);
+	if (retval) {
+		fprintf(stderr,
+			_("\nWarning, had trouble writing out superblocks."));
+	} else if (!quiet) {
+		printf(_("done\n\n"));
+		if (!getenv("MKE2FS_SKIP_CHECK_MSG"))
+			print_check_message(max_mnt_count, checkinterval);
+	}
+
+	remove_error_table(&et_ext2_error_table);
+	remove_error_table(&et_prof_error_table);
+	profile_release(profile);
+	for (i=0; fs_types[i]; i++)
+		free(fs_types[i]);
+	free(fs_types);
 
 	return retval;
 }
-- 
1.7.12.rc0.22.gcdd159b

