From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH 2/3] e2fsck: 3 level hash tree directory optimisation
Date: Tue, 24 Jan 2017 21:08:20 +0300
Message-ID: <CAO3qy=GsANKJADH3NO=n9wpjmZGPVcjhJXrEX+Q7dJWSPuPU6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:44012 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750795AbdAXSIY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Jan 2017 13:08:24 -0500
Received: from pps.filterd (m0075550.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0OI3vZ6028134
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jan 2017 13:08:23 -0500
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com [209.85.216.197])
        by mx0a-00003501.pphosted.com with ESMTP id 2867sws79r-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jan 2017 13:08:23 -0500
Received: by mail-qt0-f197.google.com with SMTP id k15so161511747qtg.5
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jan 2017 10:08:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck fixed for partitions with 3 level hash directries.
Additional level is added to e2fsck -D codepath.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 debugfs/htree.c                          |    3 +-
 e2fsck/e2fsck.h                          |    1 +
 e2fsck/pass2.c                           |   72 +++++++++++++-----
 e2fsck/rehash.c                          |  124 ++++++++++++++++++++++++------
 tests/d_fallocate_blkmap/expect          |    4 +-
 tests/d_inline_dump/expect               |   12 ++--
 tests/f_convert_bmap/expect.1            |    2 +-
 tests/f_convert_bmap_and_extent/expect.1 |    2 +-
 tests/f_create_symlinks/expect           |    8 +-
 9 files changed, 170 insertions(+), 58 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 54e55e2..8c18666 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -287,7 +287,8 @@ void do_htree_dump(int argc, char *argv[])
     fprintf(pager, "\t Indirect levels: %d\n", rootnode->indirect_levels);
     fprintf(pager, "\t Flags: %d\n", rootnode->unused_flags);

-    ent = (struct ext2_dx_entry *) (buf + 24 + rootnode->info_length);
+    ent = (struct ext2_dx_entry *)
+        ((char *)rootnode + rootnode->info_length);

     htree_dump_int_node(current_fs, ino, &inode, rootnode, ent,
                 buf + current_fs->blocksize,
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index f356810..a4efbdf 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -122,6 +122,7 @@ struct dx_dirblock_info {
     blk64_t        phys;
     int        flags;
     blk64_t        parent;
+    blk64_t        previous;
     ext2_dirhash_t    min_hash;
     ext2_dirhash_t    max_hash;
     ext2_dirhash_t    node_min_hash;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7ded7bb..9f5cd1b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -85,6 +85,40 @@ struct check_dir_struct {
     unsigned long long next_ra_off;
 };

+static void update_parents(struct dx_dir_info *dx_dir, int type)
+{
+    struct dx_dirblock_info *dx_db, *dx_parent, *dx_previous;
+    int b;
+
+    for (b = 0, dx_db = dx_dir->dx_block;
+         b < dx_dir->numblocks;
+         b++, dx_db++) {
+        dx_parent = &dx_dir->dx_block[dx_db->parent];
+        if (dx_db->type != type ||
+            !(dx_db->flags & (DX_FLAG_FIRST | DX_FLAG_LAST)))
+            continue;
+
+        /*
+         * XXX Make sure dx_parent->min_hash > dx_db->min_hash
+        */
+        if (dx_db->flags & DX_FLAG_FIRST) {
+            dx_parent->min_hash = dx_db->min_hash;
+            if (dx_parent->previous) {
+                dx_previous =
+                    &dx_dir->dx_block[dx_parent->previous];
+                dx_previous->node_max_hash =
+                    dx_parent->min_hash;
+            }
+        }
+        /*
+         * XXX Make sure dx_parent->max_hash < dx_db->max_hash
+         */
+        if (dx_db->flags & DX_FLAG_LAST) {
+            dx_parent->max_hash = dx_db->max_hash;
+        }
+    }
+}
+
 void e2fsck_pass2(e2fsck_t ctx)
 {
     struct ext2_super_block *sb = ctx->fs->super;
@@ -182,24 +216,11 @@ void e2fsck_pass2(e2fsck_t ctx)
          * Find all of the first and last leaf blocks, and
          * update their parent's min and max hash values
          */
-        for (b=0, dx_db = dx_dir->dx_block;
-             b < dx_dir->numblocks;
-             b++, dx_db++) {
-            if ((dx_db->type != DX_DIRBLOCK_LEAF) ||
-                !(dx_db->flags & (DX_FLAG_FIRST | DX_FLAG_LAST)))
-                continue;
-            dx_parent = &dx_dir->dx_block[dx_db->parent];
-            /*
-             * XXX Make sure dx_parent->min_hash > dx_db->min_hash
-             */
-            if (dx_db->flags & DX_FLAG_FIRST)
-                dx_parent->min_hash = dx_db->min_hash;
-            /*
-             * XXX Make sure dx_parent->max_hash < dx_db->max_hash
-             */
-            if (dx_db->flags & DX_FLAG_LAST)
-                dx_parent->max_hash = dx_db->max_hash;
-        }
+        update_parents(dx_dir, DX_DIRBLOCK_LEAF);
+
+        /* for 3 level htree: update 2 level parent's min
+         * and max hash values */
+        update_parents(dx_dir, DX_DIRBLOCK_NODE);

         for (b=0, dx_db = dx_dir->dx_block;
              b < dx_dir->numblocks;
@@ -642,6 +663,10 @@ static void parse_int_node(ext2_filsys fs,
             dx_db->flags |= DX_FLAG_REFERENCED;
             dx_db->parent = db->blockcnt;
         }
+
+        dx_db->previous =
+            i ? ext2fs_le32_to_cpu(ent[i-1].block & 0x0ffffff) : 0;
+
         if (hash < min_hash)
             min_hash = hash;
         if (hash > max_hash)
@@ -949,6 +974,17 @@ static int check_dir_block(ext2_filsys fs,
             return DIRENT_ABORT;
     }

+    /* This will allow (at some point in the future) to punch out empty
+     * directory blocks and reduce the space used by a directory that grows
+     * very large and then the files are deleted. For now, all that is
+     * needed is to avoid e2fsck filling in these holes as part of
+     * feature flag. */
+    if (db->blk == 0 &&
+        EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+                      EXT4_FEATURE_INCOMPAT_LARGEDIR)) {
+        return 0;
+    }
+
     if (db->blk == 0 && !inline_data_size) {
         if (allocate_dir_block(ctx, db, buf, &cd->pctx))
             return 0;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 22a58f3..6d7e3df 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -603,6 +603,42 @@ static struct ext2_dx_entry
*set_int_node(ext2_filsys fs, char *buf)
     return (struct ext2_dx_entry *) limits;
 }

+static int alloc_blocks(ext2_filsys fs,
+            struct ext2_dx_countlimit **limit,
+            struct ext2_dx_entry **prev_ent,
+            struct ext2_dx_entry **next_ent,
+            int *prev_offset, int *next_offset,
+            struct out_dir *outdir, int i,
+            int *prev_count, int *next_count)
+{
+    errcode_t    retval;
+    char        *block_start;
+
+    if (*limit)
+        (*limit)->limit = (*limit)->count =
+            ext2fs_cpu_to_le16((*limit)->limit);
+    *prev_ent = (struct ext2_dx_entry *) (outdir->buf + *prev_offset);
+    (*prev_ent)->block = ext2fs_cpu_to_le32(outdir->num);
+
+    if (i != 1)
+        (*prev_ent)->hash =
+            ext2fs_cpu_to_le32(outdir->hashes[i]);
+
+    retval = get_next_block(fs, outdir, &block_start);
+    if (retval)
+        return retval;
+
+    *next_ent = set_int_node(fs, block_start);
+    *limit = (struct ext2_dx_countlimit *)(*next_ent);
+    if (next_offset)
+        *next_offset = ((char *) *next_ent - outdir->buf);
+
+    *next_count = (*limit)->limit;
+    (*prev_offset) += sizeof(struct ext2_dx_entry);
+    (*prev_count)--;
+return 0;
+}
+
 /*
  * This function takes the leaf nodes which have been written in
  * outdir, and populates the root node and any necessary interior nodes.
@@ -612,13 +648,13 @@ static errcode_t calculate_tree(ext2_filsys fs,
                 ext2_ino_t ino,
                 ext2_ino_t parent)
 {
-    struct ext2_dx_root_info      *root_info;
-    struct ext2_dx_entry         *root, *dx_ent = 0;
-    struct ext2_dx_countlimit    *root_limit, *limit;
+    struct ext2_dx_root_info    *root_info;
+    struct ext2_dx_entry        *root, *int_ent, *dx_ent = 0;
+    struct ext2_dx_countlimit    *root_limit, *int_limit, *limit;
     errcode_t            retval;
     char                * block_start;
-    int                i, c1, c2, nblks;
-    int                limit_offset, root_offset;
+    int                i, c1, c2, c3, nblks;
+    int                limit_offset, int_offset, root_offset;

     root_info = set_root_node(fs, outdir->buf, ino, parent);
     root_offset = limit_offset = ((char *) root_info - outdir->buf) +
@@ -628,7 +664,7 @@ static errcode_t calculate_tree(ext2_filsys fs,
     nblks = outdir->num;

     /* Write out the pointer blocks */
-    if (nblks-1 <= c1) {
+    if (nblks - 1 <= c1) {
         /* Just write out the root block, and we're done */
         root = (struct ext2_dx_entry *) (outdir->buf + root_offset);
         for (i=1; i < nblks; i++) {
@@ -639,31 +675,24 @@ static errcode_t calculate_tree(ext2_filsys fs,
             root++;
             c1--;
         }
-    } else {
+    } else if (nblks - 1 <= (c1 * ((fs->blocksize - 8) /
+                 sizeof(*root)))) {
         c2 = 0;
-        limit = 0;
+        limit = NULL;
         root_info->indirect_levels = 1;
         for (i=1; i < nblks; i++) {
-            if (c1 == 0)
+            if (c2 == 0 && c1 == 0)
                 return ENOSPC;
             if (c2 == 0) {
-                if (limit)
-                    limit->limit = limit->count =
-        ext2fs_cpu_to_le16(limit->limit);
-                root = (struct ext2_dx_entry *)
-                    (outdir->buf + root_offset);
-                root->block = ext2fs_cpu_to_le32(outdir->num);
-                if (i != 1)
-                    root->hash =
-            ext2fs_cpu_to_le32(outdir->hashes[i]);
-                if ((retval =  get_next_block(fs, outdir,
-                                  &block_start)))
+                retval = alloc_blocks(fs, &limit,
+                             &root,
+                             &dx_ent,
+                             &root_offset,
+                             NULL,
+                             outdir, i,
+                             &c1, &c2);
+                if (retval)
                     return retval;
-                dx_ent = set_int_node(fs, block_start);
-                limit = (struct ext2_dx_countlimit *) dx_ent;
-                c2 = limit->limit;
-                root_offset += sizeof(struct ext2_dx_entry);
-                c1--;
             }
             dx_ent->block = ext2fs_cpu_to_le32(i);
             if (c2 != limit->limit)
@@ -674,6 +703,51 @@ static errcode_t calculate_tree(ext2_filsys fs,
         }
         limit->count = ext2fs_cpu_to_le16(limit->limit - c2);
         limit->limit = ext2fs_cpu_to_le16(limit->limit);
+    } else {
+        c2 = 0;
+        c3 = 0;
+        limit = NULL;
+        int_limit = 0;
+        root_info->indirect_levels = 2;
+        for (i = 1; i < nblks; i++) {
+            if (c3 == 0 && c2 == 0 && c1 == 0)
+                return ENOSPC;
+            if (c3 == 0 && c2 == 0) {
+                retval = alloc_blocks(fs, &int_limit,
+                             &root,
+                             &int_ent,
+                             &root_offset,
+                             &int_offset,
+                             outdir, i,
+                             &c1, &c2);
+                if (retval)
+                    return retval;
+            }
+            if (c3 == 0) {
+                retval = alloc_blocks(fs, &limit,
+                             &int_ent,
+                             &dx_ent,
+                             &int_offset,
+                             NULL,
+                             outdir, i,
+                             &c2, &c3);
+                if (retval)
+                    return retval;
+
+            }
+            dx_ent->block = ext2fs_cpu_to_le32(i);
+            if (c3 != limit->limit)
+                dx_ent->hash =
+                    ext2fs_cpu_to_le32(outdir->hashes[i]);
+            dx_ent++;
+            c3--;
+        }
+        int_limit->count = ext2fs_cpu_to_le16(limit->limit - c2);
+        int_limit->limit = ext2fs_cpu_to_le16(limit->limit);
+
+        limit->count = ext2fs_cpu_to_le16(limit->limit - c3);
+        limit->limit = ext2fs_cpu_to_le16(limit->limit);
+
     }
     root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
     root_limit->count = ext2fs_cpu_to_le16(root_limit->limit - c1);
diff --git a/tests/d_fallocate_blkmap/expect b/tests/d_fallocate_blkmap/expect
index 8ce79ff..f588511 100644
--- a/tests/d_fallocate_blkmap/expect
+++ b/tests/d_fallocate_blkmap/expect
@@ -18,7 +18,7 @@ debugfs: stat /a
 Inode: 12   Type: regular    Mode:  0666   Flags: 0x0
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Project:     0   Size: 40960
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 82
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 32
@@ -30,7 +30,7 @@ debugfs: stat /b
 Inode: 13   Type: regular    Mode:  0666   Flags: 0x0
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Project:     0   Size: 10240000
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 20082
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 32
diff --git a/tests/d_inline_dump/expect b/tests/d_inline_dump/expect
index c84f64d..f0ba471 100644
--- a/tests/d_inline_dump/expect
+++ b/tests/d_inline_dump/expect
@@ -2,7 +2,7 @@
 Inode: 13   Type: regular    Mode:  0644   Flags: 0x10000000
 Generation: 3289262644    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 80
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x53cec6b4:c72e3c00 -- Tue Jul 22 20:16:52 2014
@@ -18,7 +18,7 @@ Size of inline data: 80
 Inode: 18   Type: regular    Mode:  0644   Flags: 0x10000000
 Generation: 3842229473    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 20
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x53cec6b4:cafecc00 -- Tue Jul 22 20:16:52 2014
@@ -35,7 +35,7 @@ Size of inline data: 60
 Inode: 16   Type: directory    Mode:  0755   Flags: 0x10000000
 Generation: 3842229469    Version: 0x00000000:00000004
 User:     0   Group:     0   Size: 132
-File ACL: 7    Directory ACL: 0
+File ACL: 7
 Links: 2   Blockcount: 8
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x53cec6e3:27eac000 -- Tue Jul 22 20:17:39 2014
@@ -51,7 +51,7 @@ Size of inline data: 132
 Inode: 20   Type: directory    Mode:  0755   Flags: 0x10000000
 Generation: 3710818931    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 60
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 2   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x53cec6b4:ca0aa800 -- Tue Jul 22 20:16:52 2014
@@ -68,7 +68,7 @@ Size of inline data: 60
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x10000000
 Generation: 3289262643    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 80
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x53cec47f:724db800 -- Tue Jul 22 20:07:27 2014
@@ -83,7 +83,7 @@ Fast link dest:
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 Inode: 19   Type: symlink    Mode:  0777   Flags: 0x0
 Generation: 3842229474    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 20
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x53cec44c:a1fcc000 -- Tue Jul 22 20:06:36 2014
diff --git a/tests/f_convert_bmap/expect.1 b/tests/f_convert_bmap/expect.1
index 7d2ca86..0291f94 100644
--- a/tests/f_convert_bmap/expect.1
+++ b/tests/f_convert_bmap/expect.1
@@ -2,7 +2,7 @@ debugfs: stat /a
 Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
 Generation: 1573716129    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 524288
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 1030
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
diff --git a/tests/f_convert_bmap_and_extent/expect.1
b/tests/f_convert_bmap_and_extent/expect.1
index 7af91aa..eb55db7 100644
--- a/tests/f_convert_bmap_and_extent/expect.1
+++ b/tests/f_convert_bmap_and_extent/expect.1
@@ -2,7 +2,7 @@ debugfs: stat /a
 Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
 Generation: 1573716129    Version: 0x00000000:00000001
 User:     0   Group:     0   Size: 524288
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 1030
 Fragment:  Address: 0    Number: 0    Size: 0
  ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
index dca6e92..4409385 100644
--- a/tests/f_create_symlinks/expect
+++ b/tests/f_create_symlinks/expect
@@ -20,7 +20,7 @@ debugfs -R "stat /l_30" test.img
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Project:     0   Size: 31
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 32
@@ -29,7 +29,7 @@ debugfs -R "stat /l_70" test.img
 Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Project:     0   Size: 71
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 32
@@ -40,7 +40,7 @@ debugfs -R "stat /l_500" test.img
 Inode: 14   Type: symlink    Mode:  0777   Flags: 0x80000
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Project:     0   Size: 501
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 32
@@ -50,7 +50,7 @@ debugfs -R "stat /l_1023" test.img
 Inode: 15   Type: symlink    Mode:  0777   Flags: 0x80000
 Generation: 0    Version: 0x00000000:00000000
 User:     0   Group:     0   Project:     0   Size: 1024
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
 Size of extra inode fields: 32
--
