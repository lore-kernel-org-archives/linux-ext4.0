From: dhowells@redhat.com
Subject: (unknown)
Date: Mon, 1 Oct 2007 12:00:14 -0400
Message-ID: <200710011600.l91G0EaG027518@pobox.devel.redhat.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbXJAQAR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 12:00:17 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l91G0F7m016850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 12:00:15 -0400
Received: from pobox.devel.redhat.com (pobox.devel.redhat.com [10.11.255.8])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l91G0EdT018620
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 12:00:15 -0400
Received: from warthog.cambridge.redhat.com (devserv.devel.redhat.com [10.10.36.72])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id l91G0EaG027518
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 12:00:14 -0400
Received: from [127.0.0.1] (helo=redhat.com)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.66 #1 (Red Hat Linux))
	id 1IcNgs-0004vm-KA
	for linux-ext4@vger.kernel.org; Mon, 01 Oct 2007 17:00:14 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>From dhowells  Mon Oct  1 14: 10:20 2007
Return-Path: <dhowells@redhat.com>
Received: from localhost.localdomain [127.0.0.1]
	by warthog.procyon.org.uk with IMAP (fetchmail-6.3.7)
	for <dhowells@localhost> (single-drop); Mon, 01 Oct 2007 14:10:20 +0100 (BST)
Received: from pobox.devel.redhat.com ([unix socket])
	 by pobox.devel.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-8.1.RHEL4) with LMTPA;
	 Mon, 01 Oct 2007 09:10:18 -0400
X-Sieve: CMU Sieve 2.2
Received: from warthog.cambridge.redhat.com (devserv.devel.redhat.com [10.10.36.72])
	by pobox.devel.redhat.com (8.13.1/8.13.1) with ESMTP id l91DAHV9031008;
	Mon, 1 Oct 2007 09:10:18 -0400
Received: from [127.0.0.1] (helo=warthog.procyon.org.uk)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.66 #1 (Red Hat Linux))
	id 1IcL2Q-0007fB-Eh; Mon, 01 Oct 2007 14:10:18 +0100
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/30] IGET: Stop EXT2 from using iget() and read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org,
    akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:10:18 +0100
Message-ID: <20071001131018.29339.40931.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Resent-To: linux-ext4@vger.kernel.org
Resent-Date: Mon, 01 Oct 2007 17:00:14 +0100
Resent-Message-ID: <18957.1191254414@redhat.com>
Resent-From: David Howells <dhowells@redhat.com>

Stop the EXT2 filesystem from using iget() and read_inode().  Replace
ext2_read_inode() with ext2_iget(), and call that instead of iget().
ext2_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext2_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext2/ext2.h  |    2 +-
 fs/ext2/inode.c |   26 +++++++++++++++++++-------
 fs/ext2/namei.c |   12 ++++++------
 fs/ext2/super.c |   32 ++++++++++++++++++--------------
 4 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 9fd0ec5..85ca3de 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -123,7 +123,7 @@ extern void ext2_check_inodes_bitmap (struct super_block *);
 extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 
 /* inode.c */
-extern void ext2_read_inode (struct inode *);
+extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, int);
 extern void ext2_put_inode (struct inode *);
 extern void ext2_delete_inode (struct inode *);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 0079b2c..d8fb795 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1074,18 +1074,28 @@ void ext2_get_inode_flags(struct ext2_inode_info *ei)
 		ei->i_flags |= EXT2_DIRSYNC_FL;
 }
 
-void ext2_read_inode (struct inode * inode)
+struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 {
-	struct ext2_inode_info *ei = EXT2_I(inode);
-	ino_t ino = inode->i_ino;
+	struct ext2_inode_info *ei;
 	struct buffer_head * bh;
-	struct ext2_inode * raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
+	struct ext2_inode * raw_inode;
+	struct inode *inode;
+	long ret = -EIO;
 	int n;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ei = EXT2_I(inode);
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
+
+	raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
 	if (IS_ERR(raw_inode))
  		goto bad_inode;
 
@@ -1111,6 +1121,7 @@ void ext2_read_inode (struct inode * inode)
 	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ei->i_dtime)) {
 		/* this inode is deleted */
 		brelse (bh);
+		ret = -ESTALE;
 		goto bad_inode;
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
@@ -1180,11 +1191,12 @@ void ext2_read_inode (struct inode * inode)
 	}
 	brelse (bh);
 	ext2_set_inode_flags(inode);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 	
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 static int ext2_update_inode(struct inode * inode, int do_sync)
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index e69beed..2dfdeaa 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -63,9 +63,9 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	ino = ext2_inode_by_name(dir, dentry);
 	inode = NULL;
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = ext2_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_PTR(PTR_ERR(inode));
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -83,10 +83,10 @@ struct dentry *ext2_get_parent(struct dentry *child)
 	ino = ext2_inode_by_name(child->d_inode, &dotdot);
 	if (!ino)
 		return ERR_PTR(-ENOENT);
-	inode = iget(child->d_inode->i_sb, ino);
+	inode = ext2_iget(child->d_inode->i_sb, ino);
 
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 639a32c..78641e3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -232,7 +232,6 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *da
 static const struct super_operations ext2_sops = {
 	.alloc_inode	= ext2_alloc_inode,
 	.destroy_inode	= ext2_destroy_inode,
-	.read_inode	= ext2_read_inode,
 	.write_inode	= ext2_write_inode,
 	.put_inode	= ext2_put_inode,
 	.delete_inode	= ext2_delete_inode,
@@ -266,11 +265,10 @@ static struct dentry *ext2_get_dentry(struct super_block *sb, void *vobjp)
 	 * it might be "neater" to call ext2_get_inode first and check
 	 * if the inode is valid.....
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext2_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
+	if (generation && inode->i_generation != generation) {
 		/* we didn't find the right inode.. */
 		iput(inode);
 		return ERR_PTR(-ESTALE);
@@ -649,6 +647,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long logic_sb_block;
 	unsigned long offset = 0;
 	unsigned long def_mount_opts;
+	long ret = -EINVAL;
 	int blocksize = BLOCK_SIZE;
 	int db_count;
 	int i, j;
@@ -918,19 +917,24 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_op = &ext2_sops;
 	sb->s_export_op = &ext2_export_ops;
 	sb->s_xattr = ext2_xattr_handlers;
-	root = iget(sb, EXT2_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
-		iput(root);
-		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
+	root = ext2_iget(sb, EXT2_ROOT_INO);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
 		goto failed_mount3;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT2-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount3;
 	}
+
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
+		ret = -ENOMEM;
+		goto failed_mount3;
+	}
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_warning(sb, __FUNCTION__,
 			"mounting ext3 filesystem as ext2");
@@ -957,7 +961,7 @@ failed_mount:
 failed_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static void ext2_commit_super (struct super_block * sb,
