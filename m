Return-Path: <SRS0=dvF+=N7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58163 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbeKTQjB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 20 Nov 2018 11:39:01 -0500
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-ext4@vger.kernel.org>
Cc: <tytso@mit.edu>
Subject: [PATCH] Ext4: fix slow writeback under dioread_nolock and nodelalloc
Date: Tue, 20 Nov 2018 14:11:10 +0800
Message-Id: <1542694270-47732-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With "nodelalloc", blocks are allocated at the time of writing, and with
"dioread_nolock", these allocated blocks are marked as unwritten as well,
so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.

Everything looks normal except with "dioread_nolock", all allocated
extents are with EXT4_GET_BLOCKS_PRE_IO, which doesn't allow merging
adjacent extents.

And when it comes to writepages, given the fact that bh marked as
BH_Unwritten, it has to hold a journal handle to process these extents,
but when writepages() prepared a bunch of pages in a mpd, it could only
find one block to map to and submit one page at a time, and loop to the
next page over and over again.

ext4_writepages
  ...
  # starting from the 1st dirty page
  ext4_journal_start_with_reserve
  mpage_prepare_extent_to_map
    # batch up to 2048 dirty pages
  mpage_map_and_submit_extent
    mpage_map_one_extent
      ext4_map_blocks #with EXT4_GET_BLOCKS_IO_CREATE_EXT
        ext4_ext_map_blocks
	  ext4_find_extent
	    # find an extent with only one block at the offset
	  ext4_ext_handle_unwritten_extents
	    # try to split due to EXT4_GET_BLOCKS_PRE_IO,
	    # but no need to in this case as there is
	    # only one block in this extent
    mpage_map_and_submit_buffers
      #submit io for only 1st page
  #start from the 2nd dirty page
  ...

---

Given this is for buffered writes, the nice thing we want from
"dioread_nolock" is that extents are converted from unwritten at endio, so
thus we really don't have to take PRE_IO which is desigend for direct IO
path originally.

With this, we do extent merging in case of "nodelalloc" and writeback
doesn't need to do those extra batching and looping, the performance
number is shown as follows:

mount -o dioread_nolock,nodelalloc /dev/loop0 /mnt/
xfs_io -f -c "pwrite -W 0 1G" $M/foobar

- w/o:
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 262144 ops; 0:02:27.00 (6.951 MiB/sec and 1779.3791 ops/sec)

- w/
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 262144 ops; 0:00:06.00 (161.915 MiB/sec and 41450.3184 ops/sec)

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/ext4/extents.c | 8 +++++++-
 fs/ext4/inode.c   | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6dea5441..2a95f55563ba 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1718,6 +1718,7 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 				struct ext4_extent *ex2)
 {
 	unsigned short ext1_ee_len, ext2_ee_len;
+	bool dioread_nolock = false;
 
 	if (ext4_ext_is_unwritten(ex1) != ext4_ext_is_unwritten(ex2))
 		return 0;
@@ -1741,10 +1742,15 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	 * increment i_unwritten / set EXT4_STATE_DIO_UNWRITTEN only after
 	 * dropping i_data_sem. But reserved blocks should save us in that
 	 * case.
+	 *
+	 * In case of dioread_nolock, we allow merging extent for buffered
+	 * writes as the split happens in ext4_writepages (where blocks have
+	 * been reserved for updating extent) instead of endio.
 	 */
+	dioread_nolock = ext4_should_dioread_nolock(inode);
 	if (ext4_ext_is_unwritten(ex1) &&
 	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
-	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
+	     (!dioread_nolock && atomic_read(&EXT4_I(inode)->i_unwritten)) ||
 	     (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))
 		return 0;
 #ifdef AGGRESSIVE_TEST
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6df9c6d60981..71fb3e1654f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -812,7 +812,7 @@ int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 	ext4_debug("ext4_get_block_unwritten: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
 	return _ext4_get_block(inode, iblock, bh_result,
-			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
+			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
 }
 
 /* Maximum number of blocks we map for direct IO at once. */
-- 
1.8.3.1
