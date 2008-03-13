From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix ext3/4 allocation problems
Date: Thu, 13 Mar 2008 16:48:08 -0400
Message-ID: <20080313204808.GA20444@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbYCMUtx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 16:49:53 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2DKnq6L013649
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 16:49:52 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DKnmBD023916
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 16:49:48 -0400
Received: from unused (unused [10.11.231.15] (may be forged))
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DKnqlT020145
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 16:49:52 -0400
Received: from unused (localhost.localdomain [127.0.0.1])
	by unused (8.14.1/8.14.1) with ESMTP id m2DKm8uC021111
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 16:48:09 -0400
Received: (from jwhiter@localhost)
	by unused (8.14.1/8.14.1/Submit) id m2DKm8aB021110
	for linux-ext4@vger.kernel.org; Thu, 13 Mar 2008 16:48:08 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Seems theres a few places where we make allocations with GFP_KERNEL while in a
transaction, which can be dangerous under memory pressure as we can re-enter the
fs stuff trying to free up memory.  This patch just goes through and changes the
GFP_KERNEL allocations that occur under a transaction to GFP_NOFS to keep this
problem from happening.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: linux-2.6/fs/ext3/acl.c
===================================================================
--- linux-2.6.orig/fs/ext3/acl.c
+++ linux-2.6/fs/ext3/acl.c
@@ -37,7 +37,7 @@ ext3_acl_from_disk(const void *value, si
 		return ERR_PTR(-EINVAL);
 	if (count == 0)
 		return NULL;
-	acl = posix_acl_alloc(count, GFP_KERNEL);
+	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 	for (n=0; n < count; n++) {
@@ -91,7 +91,7 @@ ext3_acl_to_disk(const struct posix_acl 
 
 	*size = ext3_acl_size(acl->a_count);
 	ext_acl = kmalloc(sizeof(ext3_acl_header) + acl->a_count *
-			sizeof(ext3_acl_entry), GFP_KERNEL);
+			sizeof(ext3_acl_entry), GFP_NOFS);
 	if (!ext_acl)
 		return ERR_PTR(-ENOMEM);
 	ext_acl->a_version = cpu_to_le32(EXT3_ACL_VERSION);
@@ -187,7 +187,7 @@ ext3_get_acl(struct inode *inode, int ty
 	}
 	retval = ext3_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
-		value = kmalloc(retval, GFP_KERNEL);
+		value = kmalloc(retval, GFP_NOFS);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		retval = ext3_xattr_get(inode, name_index, "", value, retval);
@@ -335,7 +335,7 @@ ext3_init_acl(handle_t *handle, struct i
 			if (error)
 				goto cleanup;
 		}
-		clone = posix_acl_clone(acl, GFP_KERNEL);
+		clone = posix_acl_clone(acl, GFP_NOFS);
 		error = -ENOMEM;
 		if (!clone)
 			goto cleanup;
Index: linux-2.6/fs/ext3/resize.c
===================================================================
--- linux-2.6.orig/fs/ext3/resize.c
+++ linux-2.6/fs/ext3/resize.c
@@ -485,7 +485,7 @@ static int add_new_gdb(handle_t *handle,
 		goto exit_dindj;
 
 	n_group_desc = kmalloc((gdb_num + 1) * sizeof(struct buffer_head *),
-			GFP_KERNEL);
+			GFP_NOFS);
 	if (!n_group_desc) {
 		err = -ENOMEM;
 		ext3_warning (sb, __FUNCTION__,
@@ -568,7 +568,7 @@ static int reserve_backup_gdb(handle_t *
 	int res, i;
 	int err;
 
-	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_KERNEL);
+	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_NOFS);
 	if (!primary)
 		return -ENOMEM;
 
Index: linux-2.6/fs/ext3/xattr.c
===================================================================
--- linux-2.6.orig/fs/ext3/xattr.c
+++ linux-2.6/fs/ext3/xattr.c
@@ -728,7 +728,7 @@ ext3_xattr_block_set(handle_t *handle, s
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_KERNEL);
+			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
 			error = -ENOMEM;
 			if (s->base == NULL)
 				goto cleanup;
@@ -740,7 +740,7 @@ ext3_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_NOFS);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
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
