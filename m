From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-25.diff>
Date: Fri, 9 Feb 2007 18:11:22 -0800
Message-ID: <200702100211.l1A2BM9Z007202@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:43687 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXBJCO0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:26 -0500
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
Coverity ID: 25: Resource Leak

Standardize the error handling in do_icheck() to have a single error
exit path which frees all locally allocated memory.  The only actual
leak here without this patch is the early return in the second hunk.

Index: e2fsprogs+chaos/debugfs/icheck.c
===================================================================
--- e2fsprogs+chaos.orig/debugfs/icheck.c
+++ e2fsprogs+chaos/debugfs/icheck.c
@@ -54,27 +54,27 @@ static int icheck_proc(ext2_filsys fs EX
 
 void do_icheck(int argc, char **argv)
 {
-	struct block_walk_struct bw;
+	struct block_walk_struct bw = { NULL, 0, 0, 0 };
 	struct block_info	*binfo;
 	int			i;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
 	struct ext2_inode	inode;
 	errcode_t		retval;
-	char			*block_buf;
+	char			*block_buf = NULL;
 	
 	if (argc < 2) {
 		com_err(argv[0], 0, "Usage: icheck <block number> ...");
-		return;
+		goto error_out;
 	}
 	if (check_fs_open(argv[0]))
-		return;
+		goto error_out;
 
 	bw.barray = malloc(sizeof(struct block_info) * argc);
 	if (!bw.barray) {
 		com_err("icheck", ENOMEM,
 			"while allocating inode info array");
-		return;
+		goto error_out;
 	}
 	memset(bw.barray, 0, sizeof(struct block_info) * argc);
 
@@ -86,7 +86,7 @@ void do_icheck(int argc, char **argv)
 
 	for (i=1; i < argc; i++) {
 		if (strtoblk(argv[0], argv[i], &bw.barray[i-1].blk))
-			return;
+			goto error_out;
 	}
 
 	bw.num_blocks = bw.blocks_left = argc-1;
@@ -159,8 +159,10 @@ void do_icheck(int argc, char **argv)
 	}
 
 error_out:
-	free(bw.barray);
-	free(block_buf);
+	if (bw.barray)
+		free(bw.barray);
+	if (block_buf)
+		free(block_buf);
 	if (scan)
 		ext2fs_close_inode_scan(scan);
 	return;
