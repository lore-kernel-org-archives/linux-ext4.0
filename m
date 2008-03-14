From: akpm@linux-foundation.org
Subject: + ext4-fix-wrong-gfp-type-under-transaction.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:36:55 -0700
Message-ID: <200803142036.m2EKato2018216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jbacik@redhat.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix wrong gfp type under transaction
has been added to the -mm tree.  Its filename is
     ext4-fix-wrong-gfp-type-under-transaction.patch

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
Subject: ext4: fix wrong gfp type under transaction
From: Josef Bacik <jbacik@redhat.com>

This fixes the allocations with GFP_KERNEL while under a transaction problems
in ext4.  This patch is the same as its ext3 counterpart, just switches these
to GFP_NOFS.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/acl.c     |    8 ++++----
 fs/ext4/extents.c |    2 +-
 fs/ext4/resize.c  |    4 ++--
 fs/ext4/xattr.c   |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ext4/acl.c~ext4-fix-wrong-gfp-type-under-transaction fs/ext4/acl.c
--- a/fs/ext4/acl.c~ext4-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext4/acl.c
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
diff -puN fs/ext4/extents.c~ext4-fix-wrong-gfp-type-under-transaction fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext4/extents.c
@@ -2010,7 +2010,7 @@ int ext4_ext_remove_space(struct inode *
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
-	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_KERNEL);
+	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
 		return -ENOMEM;
diff -puN fs/ext4/resize.c~ext4-fix-wrong-gfp-type-under-transaction fs/ext4/resize.c
--- a/fs/ext4/resize.c~ext4-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext4/resize.c
@@ -469,7 +469,7 @@ static int add_new_gdb(handle_t *handle,
 		goto exit_dindj;
 
 	n_group_desc = kmalloc((gdb_num + 1) * sizeof(struct buffer_head *),
-			GFP_KERNEL);
+			GFP_NOFS);
 	if (!n_group_desc) {
 		err = -ENOMEM;
 		ext4_warning (sb, __FUNCTION__,
@@ -552,7 +552,7 @@ static int reserve_backup_gdb(handle_t *
 	int res, i;
 	int err;
 
-	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_KERNEL);
+	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_NOFS);
 	if (!primary)
 		return -ENOMEM;
 
diff -puN fs/ext4/xattr.c~ext4-fix-wrong-gfp-type-under-transaction fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~ext4-fix-wrong-gfp-type-under-transaction
+++ a/fs/ext4/xattr.c
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
_

Patches currently in -mm which might be from jbacik@redhat.com are

ext3-fix-wrong-gfp-type-under-transaction.patch
jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
jbd-fix-possible-journal-overflow-issues.patch
ext4-fix-wrong-gfp-type-under-transaction.patch

