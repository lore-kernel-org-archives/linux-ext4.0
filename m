From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-43.diff>
Date: Fri, 9 Feb 2007 18:11:39 -0800
Message-ID: <200702100211.l1A2Bdxm007477@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXBJCOs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:48 -0500
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
Coverity ID: 43: Resource Leak

Two read memory leaks we're possible due to early returns. The fix I commited
to our tree set's retval and uses the proper errout label to properal free
anything allocated.

The patch also does a little extraneous white-space cleanup

Index: e2fsprogs+chaos/e2fsck/journal.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/journal.c
+++ e2fsprogs+chaos/e2fsck/journal.c
@@ -206,9 +206,9 @@ static errcode_t e2fsck_get_journal(e2fs
 	int			ext_journal = 0;
 	int			tried_backup_jnl = 0;
 	int			i;
-		
+
 	clear_problem_context(&pctx);
-	
+
 	journal = e2fsck_allocate_memory(ctx, sizeof(journal_t), "journal");
 	if (!journal) {
 		return EXT2_ET_NO_MEMORY;
@@ -220,19 +220,21 @@ static errcode_t e2fsck_get_journal(e2fs
 		goto errout;
 	}
 	dev_journal = dev_fs+1;
-	
+
 	dev_fs->k_ctx = dev_journal->k_ctx = ctx;
 	dev_fs->k_dev = K_DEV_FS;
 	dev_journal->k_dev = K_DEV_JOURNAL;
-	
+
 	journal->j_dev = dev_journal;
 	journal->j_fs_dev = dev_fs;
 	journal->j_inode = NULL;
 	journal->j_blocksize = ctx->fs->blocksize;
 
 	if (uuid_is_null(sb->s_journal_uuid)) {
-		if (!sb->s_journal_inum)
-			return EXT2_ET_BAD_INODE_NUM;
+		if (!sb->s_journal_inum) {
+			retval = EXT2_ET_BAD_INODE_NUM;
+			goto errout;
+		}
 		j_inode = e2fsck_allocate_memory(ctx, sizeof(*j_inode),
 						 "journal inode");
 		if (!j_inode) {
@@ -242,7 +244,7 @@ static errcode_t e2fsck_get_journal(e2fs
 
 		j_inode->i_ctx = ctx;
 		j_inode->i_ino = sb->s_journal_inum;
-		
+
 		if ((retval = ext2fs_read_inode(ctx->fs,
 						sb->s_journal_inum,
 						&j_inode->i_ext2))) {
@@ -311,12 +313,13 @@ static errcode_t e2fsck_get_journal(e2fs
 				ctx->journal_name = blkid_devno_to_devname(sb->s_journal_dev);
 		}
 		journal_name = ctx->journal_name;
-			
+
 		if (!journal_name) {
 			fix_problem(ctx, PR_0_CANT_FIND_JOURNAL, &pctx);
-			return EXT2_ET_LOAD_EXT_JOURNAL;
+			retval = EXT2_ET_LOAD_EXT_JOURNAL;
+			goto errout;
 		}
-		
+
 		jfs_debug(1, "Using journal file %s\n", journal_name);
 		io_ptr = unix_io_manager;
 	}
@@ -368,7 +371,7 @@ static errcode_t e2fsck_get_journal(e2fs
 			retval = EXT2_ET_LOAD_EXT_JOURNAL;
 			goto errout;
 		}
-		
+
 		journal->j_maxlen = jsuper.s_blocks_count;
 		start++;
 	}
@@ -377,10 +380,10 @@ static errcode_t e2fsck_get_journal(e2fs
 		retval = EXT2_ET_NO_MEMORY;
 		goto errout;
 	}
-	
+
 	journal->j_sb_buffer = bh;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
-	
+
 #ifdef USE_INODE_IO
 	if (j_inode)
 		ext2fs_free_mem(&j_inode);
@@ -397,7 +400,6 @@ errout:
 	if (journal)
 		ext2fs_free_mem(&journal);
 	return retval;
-	
 }
 
 static errcode_t e2fsck_journal_fix_bad_inode(e2fsck_t ctx,
