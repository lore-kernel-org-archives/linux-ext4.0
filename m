From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ext2: conditional removal of NFSD code
Date: Sat, 6 Jan 2007 22:58:31 +0300
Message-ID: <20070106195830.GA6711@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:6237 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbXAFT6g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Jan 2007 14:58:36 -0500
Received: by nf-out-0910.google.com with SMTP id o25so8872825nfa
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jan 2007 11:58:34 -0800 (PST)
To: akpm@osdl.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nor me nor my box is going to act as NFS server, so ifdef all
exporting code.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ext2/namei.c |    2 ++
 fs/ext2/super.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -70,6 +70,7 @@ static struct dentry *ext2_lookup(struct
 	return d_splice_alias(inode, dentry);
 }
 
+#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
 struct dentry *ext2_get_parent(struct dentry *child)
 {
 	unsigned long ino;
@@ -94,6 +95,7 @@ struct dentry *ext2_get_parent(struct de
 	}
 	return parent;
 } 
+#endif
 
 /*
  * By the time this is called, we already have created
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -250,6 +250,7 @@ #ifdef CONFIG_QUOTA
 #endif
 };
 
+#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
 static struct dentry *ext2_get_dentry(struct super_block *sb, void *vobjp)
 {
 	__u32 *objp = vobjp;
@@ -297,6 +298,7 @@ static struct export_operations ext2_exp
 	.get_parent = ext2_get_parent,
 	.get_dentry = ext2_get_dentry,
 };
+#endif
 
 static unsigned long get_sb_block(void **data)
 {
@@ -916,7 +918,9 @@ static int ext2_fill_super(struct super_
 	 * set up enough so that it can read an inode
 	 */
 	sb->s_op = &ext2_sops;
+#if defined(CONFIG_EXPORTFS) || defined(CONFIG_EXPORTFS_MODULE)
 	sb->s_export_op = &ext2_export_ops;
+#endif
 	sb->s_xattr = ext2_xattr_handlers;
 	root = iget(sb, EXT2_ROOT_INO);
 	sb->s_root = d_alloc_root(root);
