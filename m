From: dhowells@redhat.com
Subject: (unknown)
Date: Mon, 1 Oct 2007 12:00:19 -0400
Message-ID: <200710011600.l91G0JVI027529@pobox.devel.redhat.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbXJAQA0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 12:00:26 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l91G0PqV016886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 12:00:25 -0400
Received: from pobox.devel.redhat.com (pobox.devel.redhat.com [10.11.255.8])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l91G0JSS018684
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 12:00:19 -0400
Received: from warthog.cambridge.redhat.com (devserv.devel.redhat.com [10.10.36.72])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id l91G0JVI027529
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 12:00:19 -0400
Received: from [127.0.0.1] (helo=redhat.com)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.66 #1 (Red Hat Linux))
	id 1IcNgx-0004w0-GS
	for linux-ext4@vger.kernel.org; Mon, 01 Oct 2007 17:00:19 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>From dhowells  Mon Oct  1 14: 10:57 2007
Return-Path: <dhowells@redhat.com>
Received: from localhost.localdomain [127.0.0.1]
	by warthog.procyon.org.uk with IMAP (fetchmail-6.3.7)
	for <dhowells@localhost> (single-drop); Mon, 01 Oct 2007 14:10:57 +0100 (BST)
Received: from pobox.devel.redhat.com ([unix socket])
	 by pobox.devel.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-8.1.RHEL4) with LMTPA;
	 Mon, 01 Oct 2007 09:10:23 -0400
X-Sieve: CMU Sieve 2.2
Received: from warthog.cambridge.redhat.com (devserv.devel.redhat.com [10.10.36.72])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id l91DANse031015;
	Mon, 1 Oct 2007 09:10:23 -0400
Received: from [127.0.0.1] (helo=warthog.procyon.org.uk)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.66 #1 (Red Hat Linux))
	id 1IcL2V-0007fN-Hr; Mon, 01 Oct 2007 14:10:23 +0100
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/30] IGET: Stop EXT3 from using iget() and read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org,
    akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:10:23 +0100
Message-ID: <20071001131023.29339.51838.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Resent-To: linux-ext4@vger.kernel.org
Resent-Date: Mon, 01 Oct 2007 17:00:19 +0100
Resent-Message-ID: <18971.1191254419@redhat.com>
Resent-From: David Howells <dhowells@redhat.com>

Stop the EXT3 filesystem from using iget() and read_inode().  Replace
ext3_read_inode() with ext3_iget(), and call that instead of iget().
ext3_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext3_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/ialloc.c        |   15 ++++++++++-----
 fs/ext3/inode.c         |   25 +++++++++++++++++++------
 fs/ext3/namei.c         |   25 +++++++------------------
 fs/ext3/resize.c        |    7 +++----
 fs/ext3/super.c         |   41 +++++++++++++++++++++++------------------
 include/linux/ext3_fs.h |    2 +-
 6 files changed, 63 insertions(+), 52 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index e45dbd6..c2f0a0d 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -646,7 +646,7 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 	unsigned long block_group;
 	int bit;
 	struct buffer_head *bitmap_bh = NULL;
-	struct inode *inode = NULL;
+	struct inode *inode = ERR_PTR(-EIO);
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
@@ -668,9 +668,14 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
 	 * inodes that were being truncated, so we can't check i_nlink==0.
 	 */
-	if (!ext3_test_bit(bit, bitmap_bh->b_data) ||
-			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
-			NEXT_ORPHAN(inode) > max_ino) {
+	if (ext3_test_bit(bit, bitmap_bh->b_data))
+		goto out;
+
+	inode = ext3_iget(sb, ino);
+	if (IS_ERR(inode))
+		goto out;
+
+	if (NEXT_ORPHAN(inode) > max_ino) {
 		ext3_warning(sb, __FUNCTION__,
 			     "bad orphan inode %lu!  e2fsck was run?", ino);
 		printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
@@ -688,7 +693,7 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
 		if (inode && inode->i_nlink == 0)
 			inode->i_blocks = 0;
 		iput(inode);
-		inode = NULL;
+		inode = ERR_PTR(-EIO);
 	}
 out:
 	brelse(bitmap_bh);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index de4e316..6c74622 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2591,21 +2591,31 @@ void ext3_get_inode_flags(struct ext3_inode_info *ei)
 		ei->i_flags |= EXT3_DIRSYNC_FL;
 }
 
-void ext3_read_inode(struct inode * inode)
+struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext3_iloc iloc;
 	struct ext3_inode *raw_inode;
-	struct ext3_inode_info *ei = EXT3_I(inode);
+	struct ext3_inode_info *ei;
 	struct buffer_head *bh;
+	struct inode *inode;
+	long ret;
 	int block;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ei = EXT3_I(inode);
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
 	ei->i_acl = EXT3_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT3_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
 
-	if (__ext3_get_inode_loc(inode, &iloc, 0))
+	ret = __ext3_get_inode_loc(inode, &iloc, 0);
+	if (ret < 0)
 		goto bad_inode;
 	bh = iloc.bh;
 	raw_inode = ext3_raw_inode(&iloc);
@@ -2636,6 +2646,7 @@ void ext3_read_inode(struct inode * inode)
 		    !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) {
 			/* this inode is deleted */
 			brelse (bh);
+			ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
@@ -2679,6 +2690,7 @@ void ext3_read_inode(struct inode * inode)
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT3_INODE_SIZE(inode->i_sb)) {
 			brelse (bh);
+			ret = -EIO;
 			goto bad_inode;
 		}
 		if (ei->i_extra_isize == 0) {
@@ -2720,11 +2732,12 @@ void ext3_read_inode(struct inode * inode)
 	}
 	brelse (iloc.bh);
 	ext3_set_inode_flags(inode);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 /*
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index c1fa190..78bfab5 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1046,17 +1046,11 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 		if (!ext3_valid_inum(dir->i_sb, ino)) {
 			ext3_error(dir->i_sb, "ext3_lookup",
 				   "bad inode number: %lu", ino);
-			inode = NULL;
-		} else
-			inode = iget(dir->i_sb, ino);
-
-		if (!inode)
 			return ERR_PTR(-EACCES);
-
-		if (is_bad_inode(inode)) {
-			iput(inode);
-			return ERR_PTR(-ENOENT);
 		}
+		inode = ext3_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_PTR(PTR_ERR(inode));
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -1085,18 +1079,13 @@ struct dentry *ext3_get_parent(struct dentry *child)
 	if (!ext3_valid_inum(child->d_inode->i_sb, ino)) {
 		ext3_error(child->d_inode->i_sb, "ext3_get_parent",
 			   "bad inode number: %lu", ino);
-		inode = NULL;
-	} else
-		inode = iget(child->d_inode->i_sb, ino);
-
-	if (!inode)
 		return ERR_PTR(-EACCES);
-
-	if (is_bad_inode(inode)) {
-		iput(inode);
-		return ERR_PTR(-ENOENT);
 	}
 
+	inode = ext3_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
+
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 2c97e09..60b6530 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -748,12 +748,11 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
-		inode = iget(sb, EXT3_RESIZE_INO);
-		if (!inode || is_bad_inode(inode)) {
+		inode = ext3_iget(sb, EXT3_RESIZE_INO);
+		if (IS_ERR(inode)) {
 			ext3_warning(sb, __FUNCTION__,
 				     "Error opening resize inode");
-			iput(inode);
-			return -ENOENT;
+			return PTR_ERR(inode);
 		}
 	}
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9537316..e06bfac 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -583,11 +583,10 @@ static struct dentry *ext3_get_dentry(struct super_block *sb, void *vobjp)
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext3_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -649,7 +648,6 @@ static struct quotactl_ops ext3_qctl_operations = {
 static const struct super_operations ext3_sops = {
 	.alloc_inode	= ext3_alloc_inode,
 	.destroy_inode	= ext3_destroy_inode,
-	.read_inode	= ext3_read_inode,
 	.write_inode	= ext3_write_inode,
 	.dirty_inode	= ext3_dirty_inode,
 	.delete_inode	= ext3_delete_inode,
@@ -1309,8 +1307,8 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 	while (es->s_last_orphan) {
 		struct inode *inode;
 
-		if (!(inode =
-		      ext3_orphan_get(sb, le32_to_cpu(es->s_last_orphan)))) {
+		inode = ext3_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
+		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
 			break;
 		}
@@ -1415,6 +1413,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	int db_count;
 	int i;
 	int needs_recovery;
+	int ret = -EINVAL;
 	__le32 features;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
@@ -1770,19 +1769,25 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = iget(sb, EXT3_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
+	root = ext3_iget(sb, EXT3_ROOT_INO);
+	if (IS_ERR(root)) {
 		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
-		iput(root);
+		if (PTR_ERR(root) == -ENOMEM)
+			ret = -ENOMEM;
 		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount4;
 	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		printk(KERN_ERR "EXT3-fs: get root dentry failed\n");
+		iput(root);
+		ret = -ENOMEM;
+		goto failed_mount4;
+	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	/*
@@ -1834,7 +1839,7 @@ out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	lock_kernel();
-	return -EINVAL;
+	return ret;
 }
 
 /*
@@ -1870,8 +1875,8 @@ static journal_t *ext3_get_journal(struct super_block *sb,
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
 
-	journal_inode = iget(sb, journal_inum);
-	if (!journal_inode) {
+	journal_inode = ext3_iget(sb, journal_inum);
+	if (IS_ERR(journal_inode)) {
 		printk(KERN_ERR "EXT3-fs: no journal found.\n");
 		return NULL;
 	}
@@ -1884,7 +1889,7 @@ static journal_t *ext3_get_journal(struct super_block *sb,
 
 	jbd_debug(2, "Journal inode found at %p: %Ld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (is_bad_inode(journal_inode) || !S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode)) {
 		printk(KERN_ERR "EXT3-fs: invalid journal inode.\n");
 		iput(journal_inode);
 		return NULL;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index ece49a8..a5ccfea 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -813,7 +813,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
 	int create, int extend_disksize);
 
-extern void ext3_read_inode (struct inode *);
+extern struct inode *ext3_iget (struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, int);
 extern int  ext3_setattr (struct dentry *, struct iattr *);
 extern void ext3_delete_inode (struct inode *);
