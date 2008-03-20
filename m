From: akpm@linux-foundation.org
Subject: [patch 14/35] ext3: fix wrong gfp type under transaction
Date: Wed, 19 Mar 2008 17:00:49 -0700
Message-ID: <200803200000.m2K00ndp011826@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jbacik@redhat.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934969AbYCTAMI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 20:12:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

There are several places where we make allocations with GFP_KERNEL while under
a transaction, which could lead to an assertion panic or lockup if under
memory pressure.  This patch switches these problem areas to use GFP_NOFS to
keep these problems from happening.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/acl.c    |    8 ++++----
 fs/ext3/resize.c |    4 ++--
 fs/ext3/xattr.c  |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext3/acl.c~ext3-fix-wrong-gfp-type-under-transaction fs/ext3/acl.c
--- a/fs/ext3/acl.c~ext3-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext3/acl.c
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
diff -puN fs/ext3/resize.c~ext3-fix-wrong-gfp-type-under-transaction fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext3/resize.c
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
 
diff -puN fs/ext3/xattr.c~ext3-fix-wrong-gfp-type-under-transaction fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext3/xattr.c
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
_
