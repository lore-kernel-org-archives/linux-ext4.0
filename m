From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-1.diff>
Date: Fri, 9 Feb 2007 18:08:16 -0800
Message-ID: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:21911 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbXBJCRm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:17:42 -0500
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
Coverity ID: 2: Checked Return

Found 2 of the three places where a return code for ext2fs_write_inode() was
not being checked.

The second fix in e2fsck/emptydir.c is basically just to shut coverity up even
though it really is unnecessary.

Index: e2fsprogs+chaos/resize/resize2fs.c
===================================================================
--- e2fsprogs+chaos.orig/resize/resize2fs.c
+++ e2fsprogs+chaos/resize/resize2fs.c
@@ -1303,7 +1303,9 @@ static int check_and_change_inodes(ext2_
 	retval = ext2fs_read_inode(is->rfs->old_fs, dir, &inode);
 	if (retval == 0) {
 		inode.i_mtime = inode.i_ctime = time(0);
-		ext2fs_write_inode(is->rfs->old_fs, dir, &inode);
+		retval = ext2fs_write_inode(is->rfs->old_fs, dir, &inode);
+		if (retval)
+			return DIRENT_ERROR;
 	}
 
 	return DIRENT_CHANGED;
Index: e2fsprogs+chaos/e2fsck/emptydir.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/emptydir.c
+++ e2fsprogs+chaos/e2fsck/emptydir.c
@@ -170,7 +170,9 @@ static int fix_directory(ext2_filsys fs,
 		edi->inode.i_size -= edi->freed_blocks * fs->blocksize;
 		edi->inode.i_blocks -= edi->freed_blocks *
 			(fs->blocksize / 512);
-		(void) ext2fs_write_inode(fs, db->ino, &edi->inode);
+		retval = ext2fs_write_inode(fs, db->ino, &edi->inode);
+		if (retval)
+			return 0;
 	}
 	return 0;
 }
