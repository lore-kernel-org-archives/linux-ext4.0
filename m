From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH] ext4: fix warning in ext4_da_update_reserve_space()
Date: Thu,  8 Jan 2015 15:48:28 -0500
Message-ID: <1420750108-11512-1-git-send-email-johunt@akamai.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	Josh Hunt <johunt@akamai.com>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:44547 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbbAHUs3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2015 15:48:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

    Please add the patch below and referenced dependency (0e95c22) to stable
    3.10.y. The original 7d73453 did not apply cleanly to my 3.10.y so I've
    backported it here. Its dependency can be cherry-picked.

    I've gotten approval to submit these to 3.10 stable from Jan and Ted, also
    cc'd.
    http://marc.info/?l=linux-ext4&m=142070334408249&w=2

    Thanks
    Josh

    -----

    commit 7d7345322d60edb0fa49a64a89b31360f01d09cb upstream

    reaim workfile.dbase test easily triggers warning in
    ext4_da_update_reserve_space():

    EXT4-fs warning (device ram0): ext4_da_update_reserve_space:365:
    ino 12, allocated 1 with only 0 reserved metadata blocks (releasing 1
    blocks with reserved 9 data blocks)

    The problem is that (one of) tests creates file and then randomly writes
    to it with O_SYNC. That results in writing back pages of the file in
    random order so we create extents for written blocks say 0, 2, 4, 6, 8
    - this last allocation also allocates new block for extents. Then we
    writeout block 1 so we have extents 0-2, 4, 6, 8 and we release
    indirect extent block because extents fit in the inode again. Then we
    writeout block 10 and we need to allocate indirect extent block again
    which triggers the warning because we don't have the reservation
    anymore.

    Fix the problem by giving back freed metadata blocks resulting from
    extent merging into inode's reservation pool.

    Cc: <stable@vger.kernel.org> # 3.10.x: 0e95c22: quota: provide interface for readding allocated space into reserved space
    Cc: <stable@vger.kernel.org> # 3.10.x
    Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |    3 ++-
 fs/ext4/mballoc.c |   21 +++++++++++++++++----
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e4c4ac0..1a487fb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -589,6 +589,7 @@ enum {
 #define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
 #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
 #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
+#define EXT4_FREE_BLOCKS_RESERVE               0x0040
 
 /*
  * Flags used by ext4_discard_partial_page_buffers
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 84d817b..7fbd1c5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1722,7 +1722,8 @@ static void ext4_ext_try_to_merge_up(handle_t *handle,
 
 	brelse(path[1].p_bh);
 	ext4_free_blocks(handle, inode, NULL, blk, 1,
-			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET |
+			 EXT4_FREE_BLOCKS_RESERVE);
 }
 
 /*
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 162b80d..df5050f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4610,6 +4610,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	struct buffer_head *gd_bh;
 	ext4_group_t block_group;
 	struct ext4_sb_info *sbi;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_buddy e4b;
 	unsigned int count_clusters;
 	int err = 0;
@@ -4808,7 +4809,6 @@ do_more:
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
-	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
@@ -4816,10 +4816,23 @@ do_more:
 			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
-	ext4_mb_unload_buddy(&e4b);
