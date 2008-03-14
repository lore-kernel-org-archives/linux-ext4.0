From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 2/2] ext4: fix wrong gfp type under transaction
Date: Fri, 14 Mar 2008 14:03:14 -0400
Message-ID: <20080314180314.GG20444@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbYCNSFm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 14:05:42 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This fixes the allocations with GFP_KERNEL while under a transaction problems in
ext4.  This patch is the same as its ext3 counterpart, just switches these to
GFP_NOFS.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: linux-2.6/fs/ext4/acl.c
===================================================================
--- linux-2.6.orig/fs/ext4/acl.c
+++ linux-2.6/fs/ext4/acl.c
@@ -37,7 +37,7 @@ ext4_acl_from_disk(const void *value, si
 		return ERR_PTR(-EINVAL);
 	if (count == 0)
 		return NULL;
-	acl = posix_acl_alloc(count, GFP_KERNEL);
+	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 	for (n=0; n < count; n++) {
@@ -91,7 +91,7 @@ ext4_acl_to_disk(const struct posix_acl 
 
 	*size = ext4_acl_size(acl->a_count);
 	ext_acl = kmalloc(sizeof(ext4_acl_header) + acl->a_count *
-			sizeof(ext4_acl_entry), GFP_KERNEL);
+			sizeof(ext4_acl_entry), GFP_NOFS);
 	if (!ext_acl)
 		return ERR_PTR(-ENOMEM);
 	ext_acl->a_version = cpu_to_le32(EXT4_ACL_VERSION);
@@ -187,7 +187,7 @@ ext4_get_acl(struct inode *inode, int ty
 	}
 	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
-		value = kmalloc(retval, GFP_KERNEL);
+		value = kmalloc(retval, GFP_NOFS);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		retval = ext4_xattr_get(inode, name_index, "", value, retval);
@@ -335,7 +335,7 @@ ext4_init_acl(handle_t *handle, struct i
 			if (error)
 				goto cleanup;
 		}
-		clone = posix_acl_clone(acl, GFP_KERNEL);
+		clone = posix_acl_clone(acl, GFP_NOFS);
 		error = -ENOMEM;
 		if (!clone)
 			goto cleanup;
Index: linux-2.6/fs/ext4/extents.c
===================================================================
--- linux-2.6.orig/fs/ext4/extents.c
+++ linux-2.6/fs/ext4/extents.c
@@ -2009,7 +2009,7 @@ int ext4_ext_remove_space(struct inode *
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
-	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_KERNEL);
+	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
 		return -ENOMEM;
Index: linux-2.6/fs/ext4/resize.c
===================================================================
--- linux-2.6.orig/fs/ext4/resize.c
+++ linux-2.6/fs/ext4/resize.c
@@ -469,7 +469,7 @@ static int add_new_gdb(handle_t *handle,
 		goto exit_dindj;
 
 	n_group_desc = kmalloc((gdb_num + 1) * sizeof(struct buffer_head *),
-			GFP_KERNEL);
+			GFP_NOFS);
 	if (!n_group_desc) {
 		err = -ENOMEM;
 		ext4_warning (sb, __func__,
@@ -552,7 +552,7 @@ static int reserve_backup_gdb(handle_t *
 	int res, i;
 	int err;
 
-	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_KERNEL);
+	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_NOFS);
 	if (!primary)
 		return -ENOMEM;
 
Index: linux-2.6/fs/ext4/xattr.c
===================================================================
--- linux-2.6.orig/fs/ext4/xattr.c
+++ linux-2.6/fs/ext4/xattr.c
@@ -739,7 +739,7 @@ ext4_xattr_block_set(handle_t *handle, s
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_KERNEL);
+			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
 			error = -ENOMEM;
 			if (s->base == NULL)
 				goto cleanup;
@@ -751,7 +751,7 @@ ext4_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_NOFS);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
