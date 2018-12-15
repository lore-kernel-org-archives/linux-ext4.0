Return-Path: <SRS0=7LHW=OY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44074 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729245AbeLOFwb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Dec 2018 00:52:31 -0500
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Liu Bo <bo.liu@linux.alibaba.com>
Subject: [PATCH v2 2/2] ext4: fix slow writeback under dioread_nolock and nodelalloc
Date: Sat, 15 Dec 2018 13:48:40 +0800
Message-Id: <20181215054840.5960-2-xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
References: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
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
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/ext4/extents.c | 6 +++++-
 fs/ext4/inode.c   | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 444c739470a5..de73b0152892 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4038,9 +4038,13 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	/*
 	 * repeat fallocate creation request
 	 * we already have an unwritten extent
+	 *
+	 * With nodelalloc + dioread_nolock, write can also come here,
+	 * so make sure map is set with new to avoid exposing stale
+	 * data to reads.
 	 */
 	if (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) {
-		map->m_flags |= EXT4_MAP_UNWRITTEN;
+		map->m_flags |= EXT4_MAP_UNWRITTEN | EXT4_MAP_NEW;
 		goto map_out;
 	}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba557a731081..4dbb43ab9d6e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -822,7 +822,7 @@ int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 	ext4_debug("ext4_get_block_unwritten: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
 	return _ext4_get_block(inode, iblock, bh_result,
-			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
+			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
 }
 
 /* Maximum number of blocks we map for direct IO at once. */
-- 
2.17.2
