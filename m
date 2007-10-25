From: "Abhishek Rai" <abhishekrai@google.com>
Subject: [PATCH] Clustering indirect blocks in Ext2
Date: Thu, 25 Oct 2007 03:21:46 -0700
Message-ID: <d9885f0f0710250321l5f7b05e0q8990e8e3419c8f4@mail.gmail.com>
References: <d9885f0f0710250320u2af6dd3eq730f460c4ba538fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbXJYKV4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 06:21:56 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id l9PALnEL016379
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 11:21:49 +0100
Received: from rv-out-0910.google.com (rvbk20.prod.google.com [10.140.87.20])
	by zps75.corp.google.com with ESMTP id l9PALlZs003259
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 03:21:48 -0700
Received: by rv-out-0910.google.com with SMTP id k20so518999rvb
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 03:21:47 -0700 (PDT)
In-Reply-To: <d9885f0f0710250320u2af6dd3eq730f460c4ba538fd@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch modifies the block allocation strategy in ext2 in order to
improve fsck performance.

Most of Ext2 metadata is clustered on disk. For example, Ext2
partitions the block space into block groups and stores the metadata
for each block group (inode table, block bitmap, inode bitmap) at the
beginning of the block group. Clustering related metadata together not
only helps ext2 I/O performance by keeping data and related metadata
close together, but also helps fsck since it is able to find all the
metadata in one place. However, indirect blocks are an exception.
Indirect blocks are allocated on-demand and are spread out along with
the data. This layout enables good I/O performance due to the close
proximity between an indirect block and its data blocks but it makes
things difficult for fsck which must now rotate almost the entire disk
in order to read all indirect blocks.

One workaround to this problem implemented in this patch is to cluster
indirect blocks together on a per group basis, similar to how inodes
and bitmaps are clustered. Indirect block clusters (metaclusters) help
fsck performance by enabling fsck to fetch all indirect blocks by
reading from a few locations on the disk instead of rotating through
the entire disk. Unfortunately, a naive clustering scheme for indirect
blocks can hurt I/O performance, as it separates out indirect blocks
and corresponding direct blocks on the disk. So an I/O to a direct
block whose indirect block is not in the page cache now needs to incur
a longer seek+rotational delay in moving the disk head from the
indirect block to the direct block.

So our goal then is to implement metaclustering without having any
impact (<0.1%) on I/O performance. Fortunately, current ext2 I/O
algorithm is not the most efficient, improving it can camouflage the
performance hit we suffer due to metaclustering. In fact,
metaclustering automatically enables one such optimization. When doing
sequential read from a file and reading an indirect block for it, we
readahead several indirect blocks of the file from the same
metacluster. Moreover, when possible we do this asynchronously. This
reduces the seek+rotational latency associated with seeking between
data and indirect blocks during a (long) sequential read.

There is one more design choice that affect the performance of this
patch: location and number of metaclusters per block group. Currently
we have one metacluster per block group and it is located at the
center of the block group. We adopted this scheme after evaluating
three possible locations of metaclusters: beginning, middle, and end
of block group. We did not evaluate configurations with >1 metacluster
per block group. In our experiments, the middle configuration did not
cause any performance degradation for sequential and random reads.
Whereas putting the metacluster at the beginning of the block group
yields best performance for sequential reads (write performance is
unaffected by this change), putting it in the middle helps random
reads. Since the "middle path" maintains status quo, we adopted that
in our change.

Performance evaluation results:
Configuration: Originally evaluated on Linux 2.6.18, dual core system
using a 400GB SATA hard disk.
There is statistically no performance impact on sequential read,
random read, and sequential write configurations with the metacluster
placed in the middle of the block group. Random write configuration
was not tested.

Note:
- This patch does not affect ext2 on-disk layout compatibility in any
way. Existing disks continue to work with new code, and disks modified
by new code continue to work with existing machines.
- Metaclustering is a mount time option (-o metacluster). This option
only affects the write path, when this option is specified indirect
blocks are allocated in clusters, when it is not specified they are
allocated alongside data blocks. The read path is unaffected by the
option, read behavior depends on the data layout on disk - if read
discovers metaclusters on disk it will do prefetching otherwise it
will not.

Signed-off-by: Abhishek Rai <abhishekrai@google.com>

==================================================
checkpatch.pl output:

WARNING: do not add new typedefs
#417: FILE: fs/ext2/inode.c:43:
+typedef struct {

WARNING: kfree(NULL) is safe this check is probabally not required
#1018: FILE: fs/ext2/inode.c:1798:
+       if (read_info)
+               kfree(read_info);

WARNING: line over 80 characters
#1261: FILE: include/linux/ext2_fs.h:322:
+#define EXT2_MOUNT_METACLUSTER         0x100000  /* Indirect block
clustering */

==================================================

diff -uprdN linux-2.6.23mm1-clean/fs/ext2/balloc.c
linux-2.6.23mm1-ext2mc/fs/ext2/balloc.c
--- linux-2.6.23mm1-clean/fs/ext2/balloc.c      2007-10-17
18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext2mc/fs/ext2/balloc.c     2007-10-25
02:42:42.000000000 -0700
@@ -562,6 +562,7 @@ bitmap_search_next_usable_block(ext2_grp
 {
        ext2_grpblk_t next;

+       BUG_ON(start > maxblocks);
        next = ext2_find_next_zero_bit(bh->b_data, maxblocks, start);
        if (next >= maxblocks)
                return -1;
@@ -650,6 +651,7 @@ ext2_try_to_allocate(struct super_block
 {
        ext2_fsblk_t group_first_block;
                ext2_grpblk_t start, end;
+       ext2_grpblk_t mc_start, mc_end, start2 = -1, end2 = -1;
        unsigned long num = 0;

        /* we do allocation within the reservation window if we have a window */
@@ -677,12 +679,43 @@ ext2_try_to_allocate(struct super_block
        }

        BUG_ON(start > EXT2_BLOCKS_PER_GROUP(sb));
+       /* start must have been set to grp_goal if one still exists. */
+       BUG_ON(grp_goal >= 0 && start != grp_goal);
+
+       ext2_get_metacluster_range(sb, &mc_start, &mc_end);
+
+       /*
+        * If there is an overlap with metacluster range, adjust our range to
+        * remove overlap, splitting our range into two if needed.
+        */
+       if (mc_start <= start)
+               start = max_t(ext2_grpblk_t, start, mc_end + 1);
+       else if (mc_end >= end - 1)
+               end = mc_start;
+       else {
+               start2 = mc_end + 1;
+               end2 = end;
+               end = mc_start;
+       }
+
+       if (start >= end)
+               goto fail_access;
+
+       if (grp_goal > 0)
+               grp_goal = start;

 repeat:
        if (grp_goal < 0) {
                grp_goal = find_next_usable_block(start, bitmap_bh, end);
-               if (grp_goal < 0)
+               if (grp_goal < 0) {
+                       if (start2 >= 0) {
+                               start = start2;
+                               end = end2;
+                               start2 = -1;
+                               goto repeat;
+                       }
                        goto fail_access;
+               }
                if (!my_rsv) {
                        int i;

@@ -703,8 +736,15 @@ repeat:
                 */
                start++;
                grp_goal++;
-               if (start >= end)
-                       goto fail_access;
+               if (start >= end) {
+                       if (start2 < 0)
+                               goto fail_access;
+
+                       start = start2;
+                       end = end2;
+                       start2 = -1;
+                       grp_goal = -1;
+               }
                goto repeat;
        }
        num++;
@@ -888,6 +928,7 @@ static int alloc_new_reservation(struct
        unsigned long size;
        int ret;
        spinlock_t *rsv_lock = &EXT2_SB(sb)->s_rsv_window_lock;
+       ext2_grpblk_t mc_start, mc_end;

        group_first_block = ext2_group_first_block_no(sb, group);
        group_end_block = group_first_block + (EXT2_BLOCKS_PER_GROUP(sb) - 1);
@@ -947,6 +988,7 @@ static int alloc_new_reservation(struct
         * To make sure the reservation window has a free bit inside it, we
         * need to check the bitmap after we found a reservable window.
         */
+       ext2_get_metacluster_range(sb, &mc_start, &mc_end);
 retry:
        ret = find_next_reservable_window(search_head, my_rsv, sb,
                                                start_block, group_end_block);
@@ -972,6 +1014,11 @@ retry:
                        my_rsv->rsv_start - group_first_block,
                        bitmap_bh, group_end_block - group_first_block + 1);

+       if (first_free_block >= mc_start && first_free_block <= mc_end) {
+               start_block = mc_end + 1;
+               goto next;
+       }
+
        if (first_free_block < 0) {
                /*
                 * no free block left on the bitmap, no point
@@ -997,6 +1044,7 @@ retry:
         * start from where the free block is,
         * we also shift the list head to where we stopped last time
         */
+next:
        search_head = my_rsv;
        spin_lock(rsv_lock);
        goto retry;
@@ -1025,12 +1073,18 @@ static void try_to_extend_reservation(st
        struct ext2_reserve_window_node *next_rsv;
        struct rb_node *next;
        spinlock_t *rsv_lock = &EXT2_SB(sb)->s_rsv_window_lock;
+       ext2_grpblk_t mc_start, mc_end;

        if (!spin_trylock(rsv_lock))
                return;

        next = rb_next(&my_rsv->rsv_node);

+       ext2_get_metacluster_range(sb, &mc_start, &mc_end);
+
+       if (my_rsv->rsv_end >= mc_start && my_rsv->rsv_end <= mc_end)
+               size += mc_end - my_rsv->rsv_end;
+
        if (!next)
                my_rsv->rsv_end += size;
        else {
@@ -1215,6 +1269,7 @@ ext2_fsblk_t ext2_new_blocks(struct inod
        sb = inode->i_sb;
        if (!sb) {
                printk("ext2_new_blocks: nonexistent device");
+               *errp = -ENODEV;
                return 0;
        }

@@ -1229,6 +1284,11 @@ ext2_fsblk_t ext2_new_blocks(struct inod
        sbi = EXT2_SB(sb);
        es = EXT2_SB(sb)->s_es;
        ext2_debug("goal=%lu.\n", goal);
+
+       /* Caller should ensure this. */
+       BUG_ON(goal < le32_to_cpu(es->s_first_data_block) ||
+              goal >= le32_to_cpu(es->s_blocks_count));
+
        /*
         * Allocate a block from reservation only when
         * filesystem is mounted with reservation(default,-o reservation), and
@@ -1252,9 +1312,6 @@ ext2_fsblk_t ext2_new_blocks(struct inod
        /*
         * First, test whether the goal block is free.
         */
-       if (goal < le32_to_cpu(es->s_first_data_block) ||
-           goal >= le32_to_cpu(es->s_blocks_count))
-               goal = le32_to_cpu(es->s_first_data_block);
        group_no = (goal - le32_to_cpu(es->s_first_data_block)) /
                        EXT2_BLOCKS_PER_GROUP(sb);
        goal_group = group_no;
@@ -1391,6 +1448,118 @@ out:
        return 0;
 }

+/*
+ * ext2_new_indirect_blocks() -- allocate indirect blocks for inode.
+ * @inode:             file inode
+ * @count:             target number of indirect blocks to allocate
+ * @new_blocks[]:       used for returning block numbers allocated
+ *
+ * return: 0 on success, appropriate error code otherwise. Upon return, *count
+ * contains the number of blocks successfully allocated which is non-zero only
+ * in the success case.
+ *
+ * Allocate maximum of *count indirect blocks from the indirect block metadata
+ * area of inode's group and store the block numbers in new_blocksp[]. Since
+ * the allocation is in a predetermined region of the block group, caller just
+ * needs to pass a group number here which is where the goal and/or the
+ * reservation window may fall.
+ */
+int ext2_new_indirect_blocks(struct inode *inode, unsigned long group_no,
+                        unsigned long *count, ext2_fsblk_t new_blocks[])
+{
+       struct super_block *sb;
+       struct buffer_head *bitmap_bh = NULL;
+       struct buffer_head *gdp_bh;
+       struct ext2_group_desc *gdp;
+       ext2_grpblk_t group_first_block;      /* first block in the group */
+       ext2_grpblk_t free_blocks;      /* number of free blocks in the group */
+       ext2_grpblk_t mc_start, mc_end;
+       int blk, alloc, range, done = 0;
+       int err = 0;
+
+       BUG_ON(*count > 3);
+
+       sb = inode->i_sb;
+       if (!sb) {
+               printk(KERN_INFO "ext2_new_indirect_blocks: "
+                       "nonexistent device");
+               return -ENODEV;
+       }
+
+       if (DQUOT_ALLOC_BLOCK(inode, *count))
+               return -EDQUOT;
+
+       gdp = ext2_get_group_desc(sb, group_no, &gdp_bh);
+       if (!gdp) {
+               err = -EIO;
+               goto out;
+       }
+
+       free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+       if (free_blocks == 0) {
+               err = -ENOSPC;
+               goto out;
+       }
+
+       bitmap_bh = read_block_bitmap(sb, group_no);
+       if (!bitmap_bh) {
+               err = -EIO;
+               goto out;
+       }
+
+       /*
+        * try to allocate indirect block in the metacluster region. Consider
+        * maximum 8 blocks at a time when searching.
+        */
+       err = -ENOSPC;
+       group_first_block = ext2_group_first_block_no(sb, group_no);
+       ext2_get_metacluster_range(sb, &mc_start, &mc_end);
+       blk = mc_start;
+       while (done < *count && blk <= mc_end) {
+               if (likely(mc_end - blk >= 7))
+                       range = 8;
+               else
+                       range = mc_end - blk + 1;
+
+               if ((bitmap_bh->b_data[blk/8] != '\255') &&
+                   (alloc = bitmap_search_next_usable_block(blk, bitmap_bh,
+                                               blk + range)) >= 0) {
+                       if (likely(!ext2_set_bit_atomic(
+                               sb_bgl_lock(EXT2_SB(sb), group_no),
+                               alloc, bitmap_bh->b_data))) {
+                               new_blocks[done++] = group_first_block + alloc;
+                       } else {
+                               cpu_relax();
+                       }
+                       continue;
+               }
+               blk += range;
+       }
+
+       if (done) {
+               group_adjust_blocks(sb, group_no, gdp, gdp_bh, -done);
+               percpu_counter_sub(&EXT2_SB(sb)->s_freeblocks_counter, done);
+
+               mark_buffer_dirty(bitmap_bh);
+               if (sb->s_flags & MS_SYNCHRONOUS)
+                       sync_dirty_buffer(bitmap_bh);
+
+               err = 0;
+       }
+
+out:
+       if (bitmap_bh)
+               brelse(bitmap_bh);
+
+       DQUOT_FREE_BLOCK(inode, *count - done);
+       *count = done;
+
+       if (err && err != -ENOSPC)
+               printk("ext2_new_indirect_blocks: error %d", err);
+
+       return err;
+}
+
 ext2_fsblk_t ext2_new_block(struct inode *inode, unsigned long goal, int *errp)
 {
        unsigned long count = 1;
diff -uprdN linux-2.6.23mm1-clean/fs/ext2/ext2.h
linux-2.6.23mm1-ext2mc/fs/ext2/ext2.h
--- linux-2.6.23mm1-clean/fs/ext2/ext2.h        2007-10-17
18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext2mc/fs/ext2/ext2.h       2007-10-25
02:41:39.000000000 -0700
@@ -1,5 +1,6 @@
 #include <linux/fs.h>
 #include <linux/ext2_fs.h>
+#include <linux/buffer_head.h>

 /*
  * ext2 mount options
@@ -69,11 +70,32 @@ struct ext2_inode_info {
  */
 #define EXT2_STATE_NEW                 0x00000001 /* inode is newly created */

+enum ext2_bh_state_bits {
+       EXT2_BH_PREFETCH = BH_PrivateStart,
+};

 /*
  * Function prototypes
  */

+static inline void
+ext2_set_buffer_prefetch(struct buffer_head *bh)
+{
+       set_bit(EXT2_BH_PREFETCH, &bh->b_state);
+}
+
+static inline void
+ext2_clear_buffer_prefetch(struct buffer_head *bh)
+{
+       clear_bit(EXT2_BH_PREFETCH, &bh->b_state);
+}
+
+static inline int
+ext2_buffer_prefetch(struct buffer_head *bh)
+{
+       return test_bit(EXT2_BH_PREFETCH, &bh->b_state);
+}
+
 /*
  * Ok, these declarations are also in <linux/kernel.h> but none of the
  * ext2 source programs needs to include it so they are duplicated here.
@@ -88,6 +110,8 @@ static inline struct ext2_inode_info *EX
 extern int ext2_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext2_bg_num_gdb(struct super_block *sb, int group);
 extern ext2_fsblk_t ext2_new_block(struct inode *, unsigned long, int *);
+extern int ext2_new_indirect_blocks(struct inode *, unsigned long group_no,
+                               unsigned long *, ext2_fsblk_t new_blocks[]);
 extern ext2_fsblk_t ext2_new_blocks(struct inode *, unsigned long,
                                unsigned long *, int *);
 extern void ext2_free_blocks (struct inode *, unsigned long,
diff -uprdN linux-2.6.23mm1-clean/fs/ext2/inode.c
linux-2.6.23mm1-ext2mc/fs/ext2/inode.c
--- linux-2.6.23mm1-clean/fs/ext2/inode.c       2007-10-17
18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext2mc/fs/ext2/inode.c      2007-10-25
02:42:23.000000000 -0700
@@ -31,6 +31,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
+#include <linux/bio.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
@@ -39,7 +40,32 @@ MODULE_AUTHOR("Remy Card and others");
 MODULE_DESCRIPTION("Second Extended Filesystem");
 MODULE_LICENSE("GPL");

+typedef struct {
+       __le32  *p;
+       __le32  key;
+       struct buffer_head *bh;
+} Indirect;
+
+struct ext2_ind_read_info {
+       int                     count;
+       int                     seq_prefetch;
+       long                    size;
+       struct buffer_head      *bh[0];
+};
+
+# define EXT2_IND_READ_INFO_SIZE(_c)        \
+       (sizeof(struct ext2_ind_read_info) + \
+        sizeof(struct buffer_head *) * (_c))
+
+# define EXT2_IND_READ_MAX             (32)
+
 static int ext2_update_inode(struct inode * inode, int do_sync);
+static Indirect *ext2_read_indblocks(struct inode *inode,
+                                    int iblock,
+                                    int depth,
+                                    int offsets[4],
+                                    Indirect chain[4],
+                                    int *err);

 /*
  * Test whether an inode is a fast symlink.
@@ -76,12 +102,6 @@ no_delete:
        clear_inode(inode);     /* We must guarantee clearing of inode... */
 }

-typedef struct {
-       __le32  *p;
-       __le32  key;
-       struct buffer_head *bh;
-} Indirect;
-
 static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 {
        p->key = *(p->p = v);
@@ -198,18 +218,22 @@ static Indirect *ext2_get_branch(struct
                                 int depth,
                                 int *offsets,
                                 Indirect chain[4],
+                                int ind_readahead,
                                 int *err)
 {
        struct super_block *sb = inode->i_sb;
        Indirect *p = chain;
        struct buffer_head *bh;
+       int index;

        *err = 0;
        /* i_data is not going away, no lock needed */
        add_chain (chain, NULL, EXT2_I(inode)->i_data + *offsets);
        if (!p->key)
                goto no_block;
-       while (--depth) {
+       for (index = 0; index < depth - 1; index++) {
+               if (ind_readahead && depth > 2 && index == depth - 2)
+                       break;
                bh = sb_bread(sb, le32_to_cpu(p->key));
                if (!bh)
                        goto failure;
@@ -243,7 +267,15 @@ no_block:
  *     It is used when heuristic for sequential allocation fails.
  *     Rules are:
  *       + if there is a block to the left of our position - allocate near it.
- *       + if pointer will live in indirect block - allocate near that block.
+ *       + If METACLUSTER options is not specified, allocate the data
+ *       block close to the metadata block. Otherwise, if pointer will live in
+ *       indirect block, we cannot allocate near the indirect block since
+ *       indirect blocks are allocated in a reserved area. Even if we allocate
+ *       this block right after the preceding logical file block, we'll still
+ *       have to incur extra seek due to the indirect block (unless we
+ *       prefetch the indirect block separately). So for now (until
+ *       prefetching is turned on), it's OK not to return a sequential goal -
+ *       just put in the same cylinder group as the inode.
  *       + if pointer will live in inode - allocate in the same cylinder group.
  *
  * In the latter case we colour the starting block by the callers PID to
@@ -254,7 +286,7 @@ no_block:
  *     Caller must make sure that @ind is valid and will stay that way.
  */

-static unsigned long ext2_find_near(struct inode *inode, Indirect *ind)
+static inline unsigned long ext2_find_near(struct inode *inode, Indirect *ind)
 {
        struct ext2_inode_info *ei = EXT2_I(inode);
        __le32 *start = ind->bh ? (__le32 *) ind->bh->b_data : ei->i_data;
@@ -267,16 +299,17 @@ static unsigned long ext2_find_near(stru
                if (*p)
                        return le32_to_cpu(*p);

-       /* No such thing, so let's try location of indirect block */
-       if (ind->bh)
-               return ind->bh->b_blocknr;
+       if (!test_opt(inode->i_sb, METACLUSTER)) {
+               /* No such thing, so let's try location of indirect block */
+               if (ind->bh)
+                       return ind->bh->b_blocknr;
+       }

        /*
         * It is going to be refered from inode itself? OK, just put it into
         * the same cylinder group then.
         */
-       bg_start = (ei->i_block_group * EXT2_BLOCKS_PER_GROUP(inode->i_sb)) +
-               le32_to_cpu(EXT2_SB(inode->i_sb)->s_es->s_first_data_block);
+       bg_start = ext2_group_first_block_no(inode->i_sb, ei->i_block_group);
        colour = (current->pid % 16) *
                        (EXT2_BLOCKS_PER_GROUP(inode->i_sb) / 16);
        return bg_start + colour;
@@ -322,8 +355,7 @@ static inline int ext2_find_goal(struct
  *     @blks: number of data blocks to be mapped.
  *     @blocks_to_boundary:  the offset in the indirect block
  *
- *     return the total number of blocks to be allocate, including the
- *     direct and indirect blocks.
+ *     return the total number of direct blocks to be allocated.
  */
 static int
 ext2_blks_to_allocate(Indirect * branch, int k, unsigned long blks,
@@ -336,7 +368,7 @@ ext2_blks_to_allocate(Indirect * branch,
         * then it's clear blocks on that path have not allocated
         */
        if (k > 0) {
-               /* right now don't hanel cross boundary allocation */
+               /* right now don't handle cross boundary allocation */
                if (blks < blocks_to_boundary + 1)
                        count += blks;
                else
@@ -356,22 +388,39 @@ ext2_blks_to_allocate(Indirect * branch,
  *     ext2_alloc_blocks: multiple allocate blocks needed for a branch
  *     @indirect_blks: the number of blocks need to allocate for indirect
  *                     blocks
- *
+ *     @blks: the number of direct blocks to be allocated
  *     @new_blocks: on return it will store the new block numbers for
  *     the indirect blocks(if needed) and the first direct block,
- *     @blks:  on return it will store the total number of allocated
- *             direct blocks
+ *
+ *     returns the number of direct blocks allocated, error via *err, and
+ *     new block numbers via new_blocks[]
  */
 static int ext2_alloc_blocks(struct inode *inode,
                        ext2_fsblk_t goal, int indirect_blks, int blks,
                        ext2_fsblk_t new_blocks[4], int *err)
 {
+       struct super_block *sb;
+       struct ext2_super_block *es;
        int target, i;
-       unsigned long count = 0;
+       unsigned long count = 0, goal_group;
        int index = 0;
        ext2_fsblk_t current_block = 0;
        int ret = 0;

+       BUG_ON(blks <= 0);
+
+       sb = inode->i_sb;
+       if (!sb) {
+               printk(KERN_INFO "ext2_alloc_blocks: nonexistent device");
+               *err = -ENODEV;
+               return 0;
+       }
+       es = EXT2_SB(sb)->s_es;
+
+       if (goal < le32_to_cpu(es->s_first_data_block) ||
+           goal >= le32_to_cpu(es->s_blocks_count))
+               goal = le32_to_cpu(es->s_first_data_block);
+
        /*
         * Here we try to allocate the requested multiple blocks at once,
         * on a best-effort basis.
@@ -382,6 +431,41 @@ static int ext2_alloc_blocks(struct inod
         */
        target = blks + indirect_blks;

+       /*
+        * Try to allocate indirect blocks in the metacluster region of block
+        * group in which goal falls. This should not only give us clustered
+        * metablock allocation, but also allocate new metablocks close to the
+        * corresponding data blocks (by putting them in the same block group).
+        * Note that allocation of indirect blocks is only guided by goal and
+        * not by reservation window since the goal mostly falls within the
+        * reservation window for sequential allocation.
+        * If the indirect blocks could not be allocated in this block group,
+        * we fall back to sequential allocation of indirect block alongside
+        * the data block instead of trying other block groups as that can
+        * separate indirect and data blocks too far out.
+        */
+       if (test_opt(sb, METACLUSTER) && indirect_blks) {
+               count = indirect_blks;
+               goal_group = (goal - le32_to_cpu(es->s_first_data_block)) /
+                               EXT2_BLOCKS_PER_GROUP(sb);
+               *err = ext2_new_indirect_blocks(inode, goal_group,
+                                               &count, new_blocks + index);
+               if (*err && *err != -ENOSPC) {
+                       printk(KERN_ERR "ext2_alloc_blocks failed to allocate "
+                               "indirect blocks: %d", *err);
+                       goto failed_out;
+               } else if (*err == 0) {
+                       BUG_ON(count == 0);
+               }
+               *err = 0;
+
+               if (count > 0) {
+                       index += count;
+                       target -= count;
+                       BUG_ON(index > indirect_blks);
+               }
+       }
+
        while (1) {
                count = target;
                /* allocating blocks for indirect blocks and direct blocks */
@@ -390,7 +474,7 @@ static int ext2_alloc_blocks(struct inod
                        goto failed_out;

                target -= count;
-               /* allocate blocks for indirect blocks */
+               /* store indirect block numbers we just allocated */
                while (index < indirect_blks && count) {
                        new_blocks[index++] = current_block++;
                        count--;
@@ -410,17 +494,23 @@ static int ext2_alloc_blocks(struct inod
 failed_out:
        for (i = 0; i <index; i++)
                ext2_free_blocks(inode, new_blocks[i], 1);
+
        return ret;
 }

 /**
  *     ext2_alloc_branch - allocate and set up a chain of blocks.
  *     @inode: owner
- *     @num: depth of the chain (number of blocks to allocate)
+ *     @indirect_blks: number of indirect blocks to allocate
+ *     @blks: number of direct blocks to allocate
+ *     @goal: goal for allocation
  *     @offsets: offsets (in the blocks) to store the pointers to next.
  *     @branch: place to store the chain in.
  *
- *     This function allocates @num blocks, zeroes out all but the last one,
+ *     returns error and number of direct blocks allocated via *blks
+ *
+ *     This function allocates indirect_blks + *blks, zeroes out all
+ *     indirect blocks,
  *     links them into chain and (if we are synchronous) writes them to disk.
  *     In other words, it prepares a branch that can be spliced onto the
  *     inode. It stores the information about that chain in the branch[], in
@@ -588,15 +678,24 @@ static int ext2_get_blocks(struct inode
        int blocks_to_boundary = 0;
        int depth;
        struct ext2_inode_info *ei = EXT2_I(inode);
-       int count = 0;
+       int count = 0, ind_readahead;
        ext2_fsblk_t first_block = 0;

+       BUG_ON(!create &&
+               iblock >= (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+                                       inode->i_sb->s_blocksize_bits);
+
        depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);

        if (depth == 0)
                return (err);
 reread:
-       partial = ext2_get_branch(inode, depth, offsets, chain, &err);
+       ind_readahead = !create && depth > 2;
+       partial = ext2_get_branch(inode, depth, offsets, chain,
+                                 ind_readahead, &err);
+       if (!partial && ind_readahead)
+               partial = ext2_read_indblocks(inode, iblock, depth,
+                                             offsets, chain, &err);

        /* Simplest case - block found, no allocation needed */
        if (!partial) {
@@ -627,7 +726,7 @@ reread:
        }

        /* Next simple case - plain lookup or failed read of indirect block */
-       if (!create || err == -EIO)
+       if (!create || (err && err != -EAGAIN))
                goto cleanup;

        mutex_lock(&ei->truncate_mutex);
@@ -860,7 +959,7 @@ static Indirect *ext2_find_shared(struct
        *top = 0;
        for (k = depth; k > 1 && !offsets[k-1]; k--)
                ;
-       partial = ext2_get_branch(inode, k, offsets, chain, &err);
+       partial = ext2_get_branch(inode, k, offsets, chain, 0, &err);
        if (!partial)
                partial = chain + k-1;
        /*
@@ -1419,3 +1518,512 @@ int ext2_setattr(struct dentry *dentry,
                error = ext2_acl_chmod(inode);
        return error;
 }
+
+/*
+ * ext2_ind_read_end_bio --
+ *
+ *     bio callback for read IO issued from ext2_read_indblocks.
+ *     Will be called only once, when all I/O has completed.
+ *     Frees read_info and bio.
+ */
+static void ext2_ind_read_end_bio(struct bio *bio, int err)
+{
+       struct ext2_ind_read_info *read_info = bio->bi_private;
+       struct buffer_head *bh;
+       int uptodate = !err && test_bit(BIO_UPTODATE, &bio->bi_flags);
+       int i;
+
+        BUG_ON(read_info->count <= 0);
+
+       if (err == -EOPNOTSUPP)
+               set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+
+       for (i = 0; i < read_info->count; i++) {
+               bh = read_info->bh[i];
+                BUG_ON(bh == NULL);
+
+               if (err == -EOPNOTSUPP) {
+                       set_bit(BH_Eopnotsupp, &bh->b_state);
+               }
+               if (uptodate) {
+                       BUG_ON(buffer_uptodate(bh));
+                       BUG_ON(ext2_buffer_prefetch(bh));
+                       set_buffer_uptodate(bh);
+                       if (read_info->seq_prefetch)
+                               ext2_set_buffer_prefetch(bh);
+               }
+
+               unlock_buffer(bh);
+               brelse(bh);
+       }
+
+       kfree(read_info);
+       bio_put(bio);
+}
+
+/*
+ * ext2_get_max_read --
+ *     @inode: inode of file.
+ *     @block: block number in file (starting from zero).
+ *     @offset_in_dind_block: offset of the indirect block inside it's
+ *     parent doubly-indirect block.
+ *
+ *      Compute the maximum no. of indirect blocks that can be read
+ *      satisfying following constraints:
+ *              - Don't read indirect blocks beyond the end of current
+ *              doubly-indirect block.
+ *              - Don't read beyond eof.
+ */
+static inline unsigned long ext2_get_max_read(const struct inode *inode,
+                                                 int block,
+                                                 int offset_in_dind_block)
+{
+       const struct super_block *sb = inode->i_sb;
+       unsigned long max_read;
+       unsigned long ptrs = EXT2_ADDR_PER_BLOCK(inode->i_sb);
+       unsigned long ptrs_bits = EXT2_ADDR_PER_BLOCK_BITS(inode->i_sb);
+       unsigned long blocks_in_file =
+               (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+       unsigned long remaining_ind_blks_in_dind =
+               (ptrs >= offset_in_dind_block) ? (ptrs - offset_in_dind_block)
+                                              : 0;
+       unsigned long remaining_ind_blks_before_eof =
+               ((blocks_in_file - EXT2_NDIR_BLOCKS + ptrs - 1) >> ptrs_bits) -
+               ((block - EXT2_NDIR_BLOCKS) >> ptrs_bits);
+
+       BUG_ON(block >= blocks_in_file);
+
+       max_read = min_t(unsigned long, remaining_ind_blks_in_dind,
+                        remaining_ind_blks_before_eof);
+
+       BUG_ON(max_read < 1);
+
+       return max_read;
+}
+
+static void ext2_read_indblocks_submit(struct bio **pbio,
+                                       struct ext2_ind_read_info **pread_info,
+                                       int *read_cnt, int seq_prefetch)
+{
+       struct bio *bio = *pbio;
+       struct ext2_ind_read_info *read_info = *pread_info;
+
+       BUG_ON(*read_cnt < 1);
+
+       read_info->seq_prefetch = seq_prefetch;
+       read_info->count = *read_cnt;
+       read_info->size = bio->bi_size;
+       bio->bi_private = read_info;
+       bio->bi_end_io = ext2_ind_read_end_bio;
+       submit_bio(READ, bio);
+
+       *pbio = NULL;
+       *pread_info = NULL;
+       *read_cnt = 0;
+}
+
+/*
+ * ext2_read_indblocks_async --
+ *      @sb:            super block
+ *      @ind_blocks[]:  array of indirect block numbers on disk
+ *      @count:         maximum number of indirect blocks to read
+ *      @first_bh:      buffer_head for indirect block ind_blocks[0], may be
+ *                      NULL
+ *      @seq_prefetch:  if this is part of a sequential prefetch and buffers'
+ *                      prefetch bit must be set.
+ *      @blocks_done:   number of blocks considered for prefetching.
+ *
+ *      Issue a single bio request to read upto count buffers identified in
+ *      ind_blocks[]. Fewer than count buffers may be read in some cases:
+ *      - If a buffer is found to be uptodate and it's prefetch bit is set, we
+ *      don't look at any more buffers as they will most likely be in
the cache.
+ *      - We skip buffers we cannot lock without blocking (except for first_bh
+ *                     read_info->seq_prefetch = seq_prefetch;
+                       read_info->count = read_cnt;
+                       read_info->size = bio->bi_size;
+                       bio->bi_private = read_info;
+                       bio->bi_end_io = ext2_ind_read_end_bio;
+                       submit_bio(READ, bio);
+      if specified).
+ *      - We skip buffers beyond a certain range on disk.
+ *
+ *      This function must issue read on first_bh if specified unless of course
+ *      it's already uptodate.
+ */
+static int ext2_read_indblocks_async(struct super_block *sb,
+                                    __le32 ind_blocks[], int count,
+                                    struct buffer_head *first_bh,
+                                    int seq_prefetch,
+                                    unsigned long *blocks_done)
+{
+       struct buffer_head *bh;
+       struct bio *bio = NULL;
+       struct ext2_ind_read_info *read_info = NULL;
+       int read_cnt = 0, blk;
+       ext2_fsblk_t prev_blk = 0, io_start_blk = 0, curr;
+       int err = 0;
+
+       BUG_ON(count < 1);
+       /* Don't move this to ext2_get_max_read() since callers often need to
+        * trim the count returned by that function. So this bound must only
+        * be imposed at the last moment. */
+       count = min_t(unsigned long, count, EXT2_IND_READ_MAX);
+       *blocks_done = 0UL;
+
+       if (count == 1 && first_bh) {
+               lock_buffer(first_bh);
+               get_bh(first_bh);
+               first_bh->b_end_io = end_buffer_read_sync;
+               submit_bh(READ, first_bh);
+               *blocks_done = 1UL;
+               return 0;
+       }
+
+       for (blk = 0; blk < count; blk++) {
+               curr = le32_to_cpu(ind_blocks[blk]);
+
+               if (!curr)
+                       continue;
+
+               if (io_start_blk > 0) {
+                       if (max(io_start_blk, curr) - min(io_start_blk, curr) >=
+                                       EXT2_IND_READ_MAX)
+                               continue;
+               }
+
+               if (prev_blk > 0 && curr != prev_blk + 1) {
+                       ext2_read_indblocks_submit(&bio, &read_info,
+                                               &read_cnt, seq_prefetch);
+                       prev_blk = 0;
+                       break;
+               }
+
+               if (blk == 0 && first_bh) {
+                       bh = first_bh;
+                       get_bh(first_bh);
+               } else {
+                       bh = sb_getblk(sb, curr);
+                       if (unlikely(!bh)) {
+                               err = -ENOMEM;
+                               goto failure;
+                       }
+               }
+
+               if (buffer_uptodate(bh)) {
+                       if (ext2_buffer_prefetch(bh)) {
+                               brelse(bh);
+                               break;
+                       }
+                       brelse(bh);
+                       continue;
+               }
+
+               /* Lock the buffer without blocking, skipping any buffers
+                * which would require us to block. first_bh when specified is
+                * an exception as caller typically wants it to be read for
+                * sure (e.g., ext2_read_indblocks_sync).
+                */
+               if (bh == first_bh) {
+                       lock_buffer(bh);
+               } else if (test_set_buffer_locked(bh)) {
+                       brelse(bh);
+                       continue;
+               }
+
+               /* Check again with the buffer locked. */
+               if (buffer_uptodate(bh)) {
+                       if (ext2_buffer_prefetch(bh)) {
+                               unlock_buffer(bh);
+                               brelse(bh);
+                               break;
+                       }
+                       unlock_buffer(bh);
+                       brelse(bh);
+                       continue;
+               }
+
+               if (read_cnt == 0) {
+                       /* read_info freed in ext2_ind_read_end_bio(). */
+                       read_info = kmalloc(EXT2_IND_READ_INFO_SIZE(count),
+                                           GFP_KERNEL);
+                       if (unlikely(!read_info)) {
+                               err = -ENOMEM;
+                               goto failure;
+                       }
+
+                       bio = bio_alloc(GFP_KERNEL, count);
+                       if (unlikely(!bio)) {
+                               err = -ENOMEM;
+                               goto failure;
+                       }
+                       bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+                       bio->bi_bdev = bh->b_bdev;
+               }
+
+               if (bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh))
+                               < bh->b_size) {
+                       brelse(bh);
+                       if (read_cnt == 0)
+                               goto failure;
+
+                       break;
+               }
+
+               read_info->bh[read_cnt++] = bh;
+
+               prev_blk = curr;
+               if (io_start_blk == 0)
+                       io_start_blk = curr;
+       }
+
+       if (read_cnt == 0)
+               goto done;
+
+       ext2_read_indblocks_submit(&bio, &read_info, &read_cnt, seq_prefetch);
+
+       *blocks_done = blk;
+       return 0;
+
+failure:
+       while (--read_cnt >= 0) {
+               unlock_buffer(read_info->bh[read_cnt]);
+               brelse(read_info->bh[read_cnt]);
+       }
+
+done:
+       if (read_info)
+               kfree(read_info);
+
+       if (bio)
+               bio_put(bio);
+
+       return err;
+}
+
+/*
+ * ext2_read_indblocks_async --
+ *      @sb:            super block
+ *      @ind_blocks[]:  array of indirect block numbers on disk
+ *      @count:         maximum number of indirect blocks to read
+ *      @first_bh:      buffer_head for indirect block ind_blocks[0], must be
+ *                      non-NULL.
+ *      @seq_prefetch:  set prefetch bit of buffers, used when this is part of
+ *                      a sequential prefetch.
+ *      @blocks_done:   number of blocks considered for prefetching.
+ *
+ *      Synchronously read at most count indirect blocks listed in
+ *      ind_blocks[]. This function calls ext2_read_indblocks_async() to do all
+ *      the hard work. It waits for read to complete on first_bh before
+ *      returning.
+ */
+
+static int ext2_read_indblocks_sync(struct super_block *sb,
+                                   __le32 ind_blocks[], int count,
+                                   struct buffer_head *first_bh,
+                                   int seq_prefetch,
+                                   unsigned long *blocks_done)
+{
+       int err;
+
+       BUG_ON(count < 1);
+       BUG_ON(!first_bh);
+
+       err = ext2_read_indblocks_async(sb, ind_blocks, count, first_bh,
+                                       seq_prefetch, blocks_done);
+       if (err)
+               return err;
+
+       wait_on_buffer(first_bh);
+       if (!buffer_uptodate(first_bh))
+               err = -EIO;
+
+       /* if seq_prefetch != 0, ext2_read_indblocks_async() sets prefetch bit
+        * for all buffers, but the first buffer for sync IO is never a prefetch
+        * buffer since it's needed presently so mark it so.
+        */
+       if (seq_prefetch)
+               ext2_clear_buffer_prefetch(first_bh);
+
+       BUG_ON(ext2_buffer_prefetch(first_bh));
+
+       return err;
+}
+
+/*
+ * ext2_read_indblocks --
+ *
+ *     @inode: inode of file
+ *     @iblock: block number inside file (starting from 0).
+ *     @depth: depth of path from inode to data block.
+ *     @offsets: array of offsets within blocks identified in 'chain'.
+ *     @chain: array of Indirect with info about all levels of blocks until
+ *     the data block.
+ *     @err: error pointer.
+ *
+ *     This function is called after reading all metablocks leading to 'iblock'
+ *     except the (singly) indirect block. It reads the indirect block if not
+ *     already in the cache and may also prefetch next few indirect blocks.
+ *     It uses a combination of synchronous and asynchronous requests to
+ *     accomplish this. We do prefetching even for random reads by reading
+ *     ahead one indirect block since reads of size >=512KB have at least 12%
+ *     chance of spanning two indirect blocks.
+ */
+
+static Indirect *ext2_read_indblocks(struct inode *inode,
+                                    int iblock,
+                                    int depth,
+                                    int offsets[4],
+                                    Indirect chain[4],
+                                    int *err)
+{
+       struct super_block *sb = inode->i_sb;
+       struct buffer_head *first_bh, *prev_bh;
+       unsigned long max_read, blocks_done = 0;
+       __le32 *ind_blocks;
+
+       /* Must have doubly indirect block for prefetching indirect blocks. */
+       BUG_ON(depth <= 2);
+       BUG_ON(!chain[depth-2].key);
+
+       *err = 0;
+
+       /* Handle first block */
+       ind_blocks = chain[depth-2].p;
+       first_bh = sb_getblk(sb, le32_to_cpu(ind_blocks[0]));
+       if (unlikely(!first_bh)) {
+               printk(KERN_ERR "Failed to get block %u for sb %p\n",
+                      le32_to_cpu(ind_blocks[0]), sb);
+               goto failure;
+       }
+
+       BUG_ON(first_bh->b_size != sb->s_blocksize);
+
+       if (buffer_uptodate(first_bh)) {
+               /* Found the buffer in cache, either it was accessed recently or
+                * it was prefetched while reading previous indirect block(s).
+                * We need to figure out if we need to prefetch the following
+                * indirect blocks.
+                */
+               if (!ext2_buffer_prefetch(first_bh)) {
+                       /* Either we've seen this indirect block before while
+                        * accessing another data block, or this is a random
+                        * read. In the former case, we must have done the
+                        * needful the first time we had a cache hit on this
+                        * indirect block, in the latter case we obviously
+                        * don't need to do any prefetching.
+                        */
+                       goto done;
+               }
+
+               max_read = ext2_get_max_read(inode, iblock,
+                                            offsets[depth-2]);
+
+               /* This indirect block is in the cache due to prefetching and
+                * this is its first cache hit, clear the prefetch bit and
+                * make sure the following blocks are also prefetched.
+                */
+               ext2_clear_buffer_prefetch(first_bh);
+
+               if (max_read >= 2) {
+                       /* ext2_read_indblocks_async() stops at the first
+                        * indirect block which has the prefetch bit set which
+                        * will most likely be the very next indirect block.
+                        */
+                       ext2_read_indblocks_async(sb, &ind_blocks[1],
+                                                 max_read - 1,
+                                                 NULL, 1, &blocks_done);
+               }
+
+       } else {
+               /* Buffer is not in memory, we need to read it. If we are
+                * reading sequentially from the previous indirect block, we
+                * have just detected a sequential read and we must prefetch
+                * some indirect blocks for future.
+                */
+
+               max_read = ext2_get_max_read(inode, iblock,
+                                            offsets[depth-2]);
+
+               if ((ind_blocks - (__le32 *)chain[depth-2].bh->b_data) >= 1) {
+                       prev_bh = sb_getblk(sb, le32_to_cpu(ind_blocks[-1]));
+                       if (buffer_uptodate(prev_bh) &&
+                           !ext2_buffer_prefetch(prev_bh)) {
+                               /* Detected sequential read. */
+                               brelse(prev_bh);
+
+                               /* Sync read indirect block, also read the next
+                                * few indirect blocks.
+                                */
+                               *err = ext2_read_indblocks_sync(sb, ind_blocks,
+                                                        max_read, first_bh, 1,
+                                                        &blocks_done);
+
+                               if (*err)
+                                       goto out;
+
+                               /* In case the very next indirect block is
+                                * discontiguous by a non-trivial amount,
+                                * ext2_read_indblocks_sync() above won't
+                                * prefetch it (indicated by blocks_done < 2).
+                                * So to help sequential read, schedule an
+                                * async request for reading the next
+                                * contiguous indirect block range (which
+                                * in metaclustering case would be the next
+                                * metacluster, without metaclustering it
+                                * would be the next indirect block). This is
+                                * expected to benefit the non-metaclustering
+                                * case.
+                                */
+                               if (max_read >= 2 && blocks_done < 2)
+                                       ext2_read_indblocks_async(sb,
+                                                       &ind_blocks[1],
+                                                       max_read - 1,
+                                                       NULL, 1, &blocks_done);
+
+                               goto done;
+                       }
+                       brelse(prev_bh);
+               }
+
+               /* Either random read, or sequential detection failed above.
+                * We always prefetch the next indirect block in this case
+                * whenever possible.
+                * This is because for random reads of size ~512KB, there is
+                * >12% chance that a read will span two indirect blocks.
+                */
+               *err = ext2_read_indblocks_sync(sb, ind_blocks,
+                                               (max_read >= 2) ? 2 : 1,
+                                               first_bh, 0, &blocks_done);
+               if (*err)
+                       goto out;
+       }
+
+done:
+       read_lock(&EXT2_I(inode)->i_meta_lock);
+       if (!verify_chain(chain, &chain[depth - 2])) {
+               brelse(first_bh);
+               goto changed;
+       }
+       add_chain(&chain[depth - 1], first_bh,
+                 (__le32*)first_bh->b_data + offsets[depth - 1]);
+       read_unlock(&EXT2_I(inode)->i_meta_lock);
+       if (!chain[depth - 1].key)
+               goto out;
+
+       BUG_ON(!buffer_uptodate(first_bh));
+       return NULL;
+
+changed:
+       read_unlock(&EXT2_I(inode)->i_meta_lock);
+       *err = -EAGAIN;
+       goto out;
+failure:
+       *err = -EIO;
+out:
+       if (*err) {
+               ext2_debug("Error %d reading indirect blocks\n", *err);
+               return &chain[depth - 2];
+       } else
+               return &chain[depth - 1];
+}
+
diff -uprdN linux-2.6.23mm1-clean/fs/ext2/super.c
linux-2.6.23mm1-ext2mc/fs/ext2/super.c
--- linux-2.6.23mm1-clean/fs/ext2/super.c       2007-10-17
18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext2mc/fs/ext2/super.c      2007-10-25
03:05:30.000000000 -0700
@@ -285,6 +285,9 @@ static int ext2_show_options(struct seq_
                seq_puts(seq, ",xip");
 #endif

+       if (sbi->s_mount_opt & EXT2_MOUNT_METACLUSTER)
+               seq_puts(seq, ",metacluster");
+
        return 0;
 }

@@ -389,7 +392,8 @@ enum {
        Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
        Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
        Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
-       Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
+       Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
+       Opt_metacluster
 };

 static match_table_t tokens = {
@@ -423,6 +427,7 @@ static match_table_t tokens = {
        {Opt_usrquota, "usrquota"},
        {Opt_reservation, "reservation"},
        {Opt_noreservation, "noreservation"},
+       {Opt_metacluster, "metacluster"},
        {Opt_err, NULL}
 };

@@ -563,6 +568,10 @@ static int parse_options (char * options
                        clear_opt(sbi->s_mount_opt, RESERVATION);
                        printk("reservations OFF\n");
                        break;
+               case Opt_metacluster:
+                       set_opt(sbi->s_mount_opt, METACLUSTER);
+                       printk("metacluster ON\n");
+                       break;
                case Opt_ignore:
                        break;
                default:
diff -uprdN linux-2.6.23mm1-clean/include/linux/ext2_fs.h
linux-2.6.23mm1-ext2mc/include/linux/ext2_fs.h
--- linux-2.6.23mm1-clean/include/linux/ext2_fs.h       2007-10-17
18:31:43.000000000 -0700
+++ linux-2.6.23mm1-ext2mc/include/linux/ext2_fs.h      2007-10-25
02:41:39.000000000 -0700
@@ -323,6 +323,7 @@ struct ext2_inode {
 #define EXT2_MOUNT_USRQUOTA            0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA            0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION         0x080000  /* Preallocation */
+#define EXT2_MOUNT_METACLUSTER         0x100000  /* Indirect block
clustering */


 #define clear_opt(o, opt)              o &= ~EXT2_MOUNT_##opt
@@ -569,4 +570,24 @@ ext2_group_first_block_no(struct super_b
                le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
 }

+/*
+ * ext2_get_metacluster_range:
+ *
+ *     Determines metacluster block range for all block groups of the file
+ *     system. Number of metacluster blocks:
+ *     = 2 * (blocks_per_group / block_pointers_per_metablock)
+ *     = 2 * (blocks_per_group / (block_size / 4))
+ *     = (8 * blocks_per_group) / block_size
+ */
+static inline void
+ext2_get_metacluster_range(struct super_block *sb,
+                               ext2_grpblk_t *mc_start,
+                               ext2_grpblk_t *mc_end)
+{
+       *mc_start = EXT2_BLOCKS_PER_GROUP(sb) / 2;
+       *mc_end = *mc_start +
+               ((EXT2_BLOCKS_PER_GROUP(sb) << 3) >> EXT2_BLOCK_SIZE_BITS(sb))
+               - 1;
+}
+
 #endif /* _LINUX_EXT2_FS_H */
