From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-24.diff>
Date: Fri, 9 Feb 2007 18:11:21 -0800
Message-ID: <200702100211.l1A2BLYK007181@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXBJCOb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:31 -0500
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
Coverity ID: 24: Resource Leak

Handle leaked cbuf due to early returns with a generic failure path.

Index: e2fsprogs+chaos/debugfs/htree.c
===================================================================
--- e2fsprogs+chaos.orig/debugfs/htree.c
+++ e2fsprogs+chaos/debugfs/htree.c
@@ -149,27 +149,29 @@ static void htree_dump_int_block(ext2_fi
 	cbuf = malloc(fs->blocksize);
 	if (!cbuf) {
 		fprintf(pager, "Couldn't allocate child block.\n");
-		return;
+		goto errout;
 	}
 	
 	errcode = ext2fs_bmap(fs, ino, inode, buf, 0, blk, &pblk);
 	if (errcode) {
 		com_err("htree_dump_int_block", errcode,
 			"while mapping logical block %u\n", blk);
-		return;
+		goto errout;
 	}
 
 	errcode = io_channel_read_blk(current_fs->io, pblk, 1, buf);
 	if (errcode) {
 		com_err("htree_dump_int_block", errcode,
 			"while 	reading block %u\n", blk);
-		return;
+		goto errout;
 	}
 
 	htree_dump_int_node(fs, ino, inode, rootnode,
 			    (struct ext2_dx_entry *) (buf+8),
 			    cbuf, level);
-	free(cbuf);
+errout:
+	if (cbuf)
+		free(cbuf);
 }
 
 
