From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: Replace use of iget() with iget_locked()
Date: Sat, 02 Feb 2008 10:55:24 -0500
Message-ID: <E1JLKiC-0002et-Tr@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35242 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757492AbYBBPz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 10:55:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


In the mm tree is a patch queued up to nuke iget().  So replace use of
iget() with iget_locked().  I will be pushing this to Linus shortly.

     	  		    	    	    - Ted


commit 46ea772acbda42780ae014e608f51e71083be46b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Feb 2 10:52:41 2008 -0500

    ext4: Replace use of iget() with iget_locked()
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 575b521..d45fcaa 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -805,9 +805,17 @@ struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
 	 * inodes that were being truncated, so we can't check i_nlink==0.
 	 */
-	if (!ext4_test_bit(bit, bitmap_bh->b_data) ||
-			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
-			NEXT_ORPHAN(inode) > max_ino) {
+	if (!ext4_test_bit(bit, bitmap_bh->b_data))
+		goto bad_orphan_inode;
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		goto bad_orphan_inode;
+	if (inode->i_state & I_NEW) {
+		sb->s_op->read_inode(inode);
+		unlock_new_inode(inode);
+	}
+	if (is_bad_inode(inode) || NEXT_ORPHAN(inode) > max_ino) {
+	bad_orphan_inode:
 		ext4_warning(sb, __FUNCTION__,
 			     "bad orphan inode %lu!  e2fsck was run?", ino);
 		printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 055a0cd..1ef0359 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -777,9 +777,13 @@ static struct inode *ext4_nfs_get_inode(struct super_block *sb,
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = iget(sb, ino);
+	inode = iget_locked(sb, ino);
 	if (inode == NULL)
 		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		sb->s_op->read_inode(inode);
+		unlock_new_inode(inode);
+	}
 	if (is_bad_inode(inode) ||
 	    (generation && inode->i_generation != generation)) {
 		iput(inode);
@@ -2243,7 +2247,15 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = iget(sb, EXT4_ROOT_INO);
+	root = iget_locked(sb, EXT4_ROOT_INO);
+	if (!root) {
+		printk(KERN_ERR "EXT4-fs: iget_locked for root inode failed\n");
+		goto failed_mount4;
+	}
+	if (root->i_state & I_NEW) {
+		sb->s_op->read_inode(root);
+		unlock_new_inode(root);
+	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		printk(KERN_ERR "EXT4-fs: get root inode failed\n");
@@ -2372,11 +2384,15 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
 
-	journal_inode = iget(sb, journal_inum);
+	journal_inode = iget_locked(sb, journal_inum);
 	if (!journal_inode) {
-		printk(KERN_ERR "EXT4-fs: no journal found.\n");
+		printk(KERN_ERR "EXT4-fs: iget_locked for journal inode failed.\n");
 		return NULL;
 	}
+	if (journal_inode->i_state & I_NEW) {
+		sb->s_op->read_inode(journal_inode);
+		unlock_new_inode(journal_inode);
+	}
 	if (!journal_inode->i_nlink) {
 		make_bad_inode(journal_inode);
 		iput(journal_inode);
