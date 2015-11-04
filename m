From: yalin wang <yalin.wang2010@gmail.com>
Subject: [RFC] ext4: fix a BUG in ext4_mpage_readpages()
Date: Wed,  4 Nov 2015 15:58:34 +0800
Message-ID: <1446623914-9367-1-git-send-email-yalin.wang2010@gmail.com>
Cc: yalin wang <yalin.wang2010@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The last block should be the total read pages last block,
need adjust the block number when caculate every page.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
---
 fs/ext4/readpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 5dc5e95..d20c39d 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -174,7 +174,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			goto confused;
 
 		block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
-		last_block = block_in_file + nr_pages * blocks_per_page;
+		last_block = block_in_file + (nr_pages - page_idx) * blocks_per_page;
 		last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
 		if (last_block > last_block_in_file)
 			last_block = last_block_in_file;
-- 
1.9.1
