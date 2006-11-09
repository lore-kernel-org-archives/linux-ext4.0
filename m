From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Fw: Errors reported by Coverity in ext3.
Date: Thu, 9 Nov 2006 14:21:21 -0700
Message-ID: <20061109212121.GJ6012@schatzie.adilger.int>
References: <20061109111409.89092bf2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:19379 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1424138AbWKIVVX
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Nov 2006 16:21:23 -0500
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061109111409.89092bf2.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 09, 2006  11:14 -0800, Andrew Morton wrote:
> 2. Error reported in ext3/inode.c
> ---
> CID: 3548
> Checker: CHECKED_RETURN
> File: fs/ext3/inode.c
> Function: ext3_clear_blocks
> Description: Return value of "__ext3_journal_get_write_access" is not checked
> 
> 1816    if (bh) {
> 1817            BUFFER_TRACE(bh, "retaking write access");
> 
> Event check_return: Called function "__ext3_journal_get_write_access"
>       whose return value should be checked (checked 32 out of 39 times)
> Event unchecked_value: Return value of
>      "__ext3_journal_get_write_access" is not checked Also see events:
> 
> 1818    ext3_journal_get_write_access(handle, bh);
> 1819    }
> ---

Here is a patch we have locally for this one (though against a 2.6.9-RHEL4
kernel, likely usable in mainline with minor tweaks).

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

- ext3-check-jbd-errors-2.6.9.patch ---------------------------------------
Index: linux-2.6.9-full/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.9-full.orig/include/linux/ext3_fs.h	2006-08-09 17:56:39.000000000 +0400
+++ linux-2.6.9-full/include/linux/ext3_fs.h	2006-08-22 12:36:22.000000000 +0400
@@ -826,6 +826,7 @@ extern void ext3_put_super (struct super
 extern void ext3_write_super (struct super_block *);
 extern void ext3_write_super_lockfs (struct super_block *);
 extern void ext3_unlockfs (struct super_block *);
+extern void ext3_commit_super (struct super_block *, struct ext3_super_block *, int);
 extern int ext3_remount (struct super_block *, int *, char *);
 extern int ext3_statfs (struct super_block *, struct kstatfs *);
 
Index: linux-2.6.9-full/fs/ext3/super.c
===================================================================
--- linux-2.6.9-full.orig/fs/ext3/super.c	2006-08-09 17:56:40.000000000 +0400
+++ linux-2.6.9-full/fs/ext3/super.c	2006-08-09 17:56:40.000000000 +0400
@@ -43,7 +43,7 @@ static int ext3_load_journal(struct supe
 			     unsigned long journal_devnum);
 static int ext3_create_journal(struct super_block *, struct ext3_super_block *,
 			       int);
-static void ext3_commit_super (struct super_block * sb,
+void ext3_commit_super (struct super_block * sb,
 			       struct ext3_super_block * es,
 			       int sync);
 static void ext3_mark_recovery_complete(struct super_block * sb,
@@ -1991,7 +1991,7 @@ static int ext3_create_journal(struct su
 	return 0;
 }
 
-static void ext3_commit_super (struct super_block * sb,
+void ext3_commit_super (struct super_block * sb,
 			       struct ext3_super_block * es,
 			       int sync)
 {
Index: linux-2.6.9-full/fs/ext3/namei.c
===================================================================
--- linux-2.6.9-full.orig/fs/ext3/namei.c	2006-08-09 17:56:40.000000000 +0400
+++ linux-2.6.9-full/fs/ext3/namei.c	2006-08-09 17:56:40.000000000 +0400
@@ -1599,7 +1599,7 @@ static int ext3_delete_entry (handle_t *
 			      struct buffer_head * bh)
 {
 	struct ext3_dir_entry_2 * de, * pde;
-	int i;
+	int i, err;
 
 	i = 0;
 	pde = NULL;
@@ -1609,7 +1609,9 @@ static int ext3_delete_entry (handle_t *
 			return -EIO;
 		if (de == de_del)  {
 			BUFFER_TRACE(bh, "get_write_access");
-			ext3_journal_get_write_access(handle, bh);
+			err = ext3_journal_get_write_access(handle, bh);
+			if (err)
+				return err;
 			if (pde)
 				pde->rec_len =
 					cpu_to_le16(le16_to_cpu(pde->rec_len) +
Index: linux-2.6.9-full/fs/ext3/inode.c
===================================================================
--- linux-2.6.9-full.orig/fs/ext3/inode.c	2006-06-02 23:37:38.000000000 +0400
+++ linux-2.6.9-full/fs/ext3/inode.c	2006-08-22 12:34:28.000000000 +0400
@@ -1807,8 +1812,18 @@ ext3_clear_blocks(handle_t *handle, stru
 		ext3_mark_inode_dirty(handle, inode);
 		ext3_journal_test_restart(handle, inode);
 		if (bh) {
+			int err;
 			BUFFER_TRACE(bh, "retaking write access");
-			ext3_journal_get_write_access(handle, bh);
+			err = ext3_journal_get_write_access(handle, bh);
+			if (err) {
+				struct super_block *sb = inode->i_sb;
+				struct ext3_super_block *es = EXT3_SB(sb)->s_es;
+				printk(KERN_CRIT "EXT3-fs: can't continue truncate\n");
+				EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
+				es->s_state |= cpu_to_le16(EXT3_ERROR_FS);
+				ext3_commit_super(sb, es, 1);
+				return;
+			}
 		}
 	}
 
Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
