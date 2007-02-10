From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-51.diff>
Date: Fri, 9 Feb 2007 18:11:42 -0800
Message-ID: <200702100211.l1A2BgSO007505@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXBJCOw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 51: Use After Free

ext2fs_get_pathname() can return without having allocated memory for pathname.
Probably also should be more careful about using printf with NULL value as well
(even though GNU probably handles this well).

Index: e2fsprogs+chaos/debugfs/debugfs.c
===================================================================
--- e2fsprogs+chaos.orig/debugfs/debugfs.c
+++ e2fsprogs+chaos/debugfs/debugfs.c
@@ -950,15 +950,23 @@ void do_print_working_directory(int argc
 		com_err(argv[0], retval,
 			"while trying to get pathname of cwd");
 	}
-	printf("[pwd]   INODE: %6u  PATH: %s\n", cwd, pathname);
-	free(pathname);
+	printf("[pwd]   INODE: %6u  PATH: %s\n",
+	       cwd, pathname ? pathname : "NULL");
+        if(pathname) {
+		free(pathname);
+		pathname = NULL;
+        }
 	retval = ext2fs_get_pathname(current_fs, root, 0, &pathname);
 	if (retval) {
 		com_err(argv[0], retval,
 			"while trying to get pathname of root");
 	}
-	printf("[root]  INODE: %6u  PATH: %s\n", root, pathname);
-	free(pathname);
+	printf("[root]  INODE: %6u  PATH: %s\n",
+	       root, pathname ? pathname : "NULL");
+	if(pathname) {
+		free(pathname);
+		pathname = NULL;
+	}
 	return;
 }
 
