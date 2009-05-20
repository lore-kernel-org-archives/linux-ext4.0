From: number9652 <number9652@yahoo.com>
Subject: Re: [PATCH] e2fsprogs: add ext2fs_extent_open2
Date: Wed, 20 May 2009 13:45:33 -0700 (PDT)
Message-ID: <464818.77761.qm@web43508.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n56.bullet.mail.sp1.yahoo.com ([98.136.44.52]:26635 "HELO
	n56.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755541AbZETUpc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 16:45:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--- On Tue, 5/19/09, Theodore Tso wrote:
> Thanks, this patch looks good.  Can I get a
> "Signed-off-by:" from you?

I felt like I was forgetting something, just couldn't figure out what.  I included a copy of the patch to make sure it is clear.

Signed-off-by: Nic Case <number9652@yahoo.com>
---

diff --git a/e2fsprogs-1.41.5-orig/e2fsck/pass1.c b/e2fsprogs-1.41.5/e2fsck/pass1.c
index 3b05cf2..2968a3e 100644
--- a/e2fsprogs-1.41.5-orig/e2fsck/pass1.c
+++ b/e2fsprogs-1.41.5/e2fsck/pass1.c
@@ -180,7 +180,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
    if (inode->i_flags & EXT4_EXTENTS_FL) {
        if (inode->i_size > fs->blocksize)
            return 0;
-        if (ext2fs_extent_open(fs, ino, &handle))
+        if (ext2fs_extent_open2(fs, ino, inode, &handle))
            return 0;
        i = 0;
        if (ext2fs_extent_get_info(handle, &info) ||
@@ -1769,7 +1769,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
    ext2_ino_t        ino = pctx->ino;
    errcode_t        retval;

-    pctx->errcode = ext2fs_extent_open(fs, ino, &ehandle);
+    pctx->errcode = ext2fs_extent_open2(fs, ino, inode, &ehandle);
    if (pctx->errcode &&
        fix_problem(ctx, PR_1_READ_EXTENT, pctx)) {
        e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks_extents");
diff --git a/e2fsprogs-1.41.5-orig/lib/ext2fs/block.c b/e2fsprogs-1.41.5/lib/ext2fs/block.c
index 6ac9379..de5342d 100644
--- a/e2fsprogs-1.41.5-orig/lib/ext2fs/block.c
+++ b/e2fsprogs-1.41.5/lib/ext2fs/block.c
@@ -367,7 +367,7 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
        int            uninit;
        unsigned int        j;

-        ctx.errcode = ext2fs_extent_open(fs, ino, &handle);
+        ctx.errcode = ext2fs_extent_open2(fs, ino, &inode, &handle);
        if (ctx.errcode)
            goto abort_exit;

diff --git a/e2fsprogs-1.41.5-orig/lib/ext2fs/bmap.c b/e2fsprogs-1.41.5/lib/ext2fs/bmap.c
index 4edf425..2a86439 100644
--- a/e2fsprogs-1.41.5-orig/lib/ext2fs/bmap.c
+++ b/e2fsprogs-1.41.5/lib/ext2fs/bmap.c
@@ -160,7 +160,7 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
        struct ext2fs_extent    extent;
        unsigned int        offset;

-        retval = ext2fs_extent_open(fs, ino, &handle);
+        retval = ext2fs_extent_open2(fs, ino, inode, &handle);
        if (retval)
            goto done;
        if (bmap_flags & BMAP_SET) {
diff --git a/e2fsprogs-1.41.5-orig/lib/ext2fs/ext2fs.h b/e2fsprogs-1.41.5/lib/ext2fs/ext2fs.h
index d5026bc..08bfa03 100644
--- a/e2fsprogs-1.41.5-orig/lib/ext2fs/ext2fs.h
+++ b/e2fsprogs-1.41.5/lib/ext2fs/ext2fs.h
@@ -839,6 +839,9 @@ extern errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
extern errcode_t ext2fs_extent_open(ext2_filsys fs, ext2_ino_t ino,
                    ext2_extent_handle_t *handle);
+extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
+                    struct ext2_inode *inode,
+                    ext2_extent_handle_t *ret_handle);
extern void ext2fs_extent_free(ext2_extent_handle_t handle);
extern errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
                   int flags, struct ext2fs_extent *extent);
diff --git a/e2fsprogs-1.41.5-orig/lib/ext2fs/extent.c b/e2fsprogs-1.41.5/lib/ext2fs/extent.c
index 143929e..37cd932 100644
--- a/e2fsprogs-1.41.5-orig/lib/ext2fs/extent.c
+++ b/e2fsprogs-1.41.5/lib/ext2fs/extent.c
@@ -180,32 +180,44 @@ extern void ext2fs_extent_free(ext2_extent_handle_t handle)
extern errcode_t ext2fs_extent_open(ext2_filsys fs, ext2_ino_t ino,
                    ext2_extent_handle_t *ret_handle)
{
+    return ext2fs_extent_open2(fs, ino, NULL, ret_handle);
+}
+
+extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
+                    struct ext2_inode *inode,
+                    ext2_extent_handle_t *ret_handle)
+{
    struct ext2_extent_handle    *handle;
    errcode_t            retval;
-    int                isize = EXT2_INODE_SIZE(fs->super);
    int                i;
    struct ext3_extent_header    *eh;

    EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

-    if ((ino == 0) || (ino > fs->super->s_inodes_count))
-        return EXT2_ET_BAD_INODE_NUM;
+    if (!inode)
+        if ((ino == 0) || (ino > fs->super->s_inodes_count))
+            return EXT2_ET_BAD_INODE_NUM;

    retval = ext2fs_get_mem(sizeof(struct ext2_extent_handle), &handle);
    if (retval)
        return retval;
    memset(handle, 0, sizeof(struct ext2_extent_handle));

-    retval = ext2fs_get_mem(isize, &handle->inode);
+    retval = ext2fs_get_mem(sizeof(struct ext2_inode), &handle->inode);
    if (retval)
        goto errout;

    handle->ino = ino;
    handle->fs = fs;

-    retval = ext2fs_read_inode_full(fs, ino, handle->inode, isize);
-    if (retval)
-        goto errout;
+    if (inode) {
+        memcpy(handle->inode, inode, sizeof(struct ext2_inode));
+    }
+    else {
+        retval = ext2fs_read_inode(fs, ino, handle->inode);
+        if (retval)
+            goto errout;
+    }

    eh = (struct ext3_extent_header *) &handle->inode->i_block[0];



      

