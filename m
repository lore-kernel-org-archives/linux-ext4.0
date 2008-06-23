From: akpm@linux-foundation.org
Subject: + ext3-handle-corrupted-orphan-list-at-mount.patch added to -mm tree
Date: Mon, 23 Jun 2008 16:43:07 -0700
Message-ID: <200806232343.m5NNh9dJ022374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: handle corrupted orphan list at mount
has been added to the -mm tree.  Its filename is
     ext3-handle-corrupted-orphan-list-at-mount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: handle corrupted orphan list at mount
From: "Duane Griffin" <duaneg@dghda.com>

If the orphan node list includes valid, untruncatable nodes with nlink > 0
the ext3_orphan_cleanup loop which attempts to delete them will not do so,
causing it to loop forever. Fix by checking for such nodes in the
ext3_orphan_get function.

This patch fixes the second case (image hdb.20000009.softlockup.gz)
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |    9 +++++++++
 fs/ext3/inode.c         |   15 +++++++++------
 include/linux/ext3_fs.h |    1 +
 3 files changed, 19 insertions(+), 6 deletions(-)

diff -puN fs/ext3/ialloc.c~ext3-handle-corrupted-orphan-list-at-mount fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-handle-corrupted-orphan-list-at-mount
+++ a/fs/ext3/ialloc.c
@@ -669,6 +669,14 @@ struct inode *ext3_orphan_get(struct sup
 	if (IS_ERR(inode))
 		goto iget_failed;
 
+	/*
+	 * If the orphans has i_nlinks > 0 then it should be able to be
+	 * truncated, otherwise it won't be removed from the orphan list
+	 * during processing and an infinite loop will result.
+	 */
+	if (inode->i_nlink && !ext3_can_truncate(inode))
+		goto bad_orphan;
+
 	if (NEXT_ORPHAN(inode) > max_ino)
 		goto bad_orphan;
 	brelse(bitmap_bh);
@@ -690,6 +698,7 @@ bad_orphan:
 		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
 		       NEXT_ORPHAN(inode));
 		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
+		printk(KERN_NOTICE "i_nlink=%lu\n", inode->i_nlink);
 		/* Avoid freeing blocks if we got a bad deleted inode */
 		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
diff -puN fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount
+++ a/fs/ext3/inode.c
@@ -2256,6 +2256,14 @@ static void ext3_free_branches(handle_t 
 	}
 }
 
+int ext3_can_truncate(struct inode *inode)
+{
+	return (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+		S_ISLNK(inode->i_mode)) &&
+		!ext3_inode_is_fast_symlink(inode) &&
+		!(IS_APPEND(inode) || IS_IMMUTABLE(inode));
+}
+
 /*
  * ext3_truncate()
  *
@@ -2300,12 +2308,7 @@ void ext3_truncate(struct inode *inode)
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	struct page *page;
 
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode)))
-		return;
-	if (ext3_inode_is_fast_symlink(inode))
-		return;
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+	if (!ext3_can_truncate(inode))
 		return;
 
 	/*
diff -puN include/linux/ext3_fs.h~ext3-handle-corrupted-orphan-list-at-mount include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-handle-corrupted-orphan-list-at-mount
+++ a/include/linux/ext3_fs.h
@@ -832,6 +832,7 @@ extern void ext3_discard_reservation (st
 extern void ext3_dirty_inode(struct inode *);
 extern int ext3_change_inode_journal_flag(struct inode *, int);
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
+extern int ext3_can_truncate(struct inode *inode);
 extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch

