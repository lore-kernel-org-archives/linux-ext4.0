From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] ext4: Properly initialize the buffer_head state
Date: Tue, 12 May 2009 18:45:25 -0400
Message-ID: <1242168327-31127-5-git-send-email-tytso@mit.edu>
References: <1242168327-31127-1-git-send-email-tytso@mit.edu>
 <1242168327-31127-2-git-send-email-tytso@mit.edu>
 <1242168327-31127-3-git-send-email-tytso@mit.edu>
 <1242168327-31127-4-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44250 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZELWpb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:45:31 -0400
In-Reply-To: <1242168327-31127-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

These struct buffer_heads are allocated on the stack (and hence are
initialized with stack garbage).  They are only used to call a
get_blocks() function, so that's mostly OK, but b_state must be
initialized to be 0 so we don't have any unexpected BH_* flags set by
accident, such as BH_Unwritten or BH_Delay.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    2 +-
 fs/mpage.c        |    6 ++++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 172656c..910e198 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3143,6 +3143,7 @@ retry:
 			ret = PTR_ERR(handle);
 			break;
 		}
+		map_bh.b_state = 0;
 		ret = ext4_get_blocks_wrap(handle, inode, block,
 					  max_blocks, &map_bh,
 					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d0ff73..475c3dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2049,7 +2049,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if ((mpd->b_state  & (1 << BH_Mapped)) &&
 	    !(mpd->b_state & (1 << BH_Delay)))
 		return 0;
-	new.b_state = mpd->b_state;
+	new.b_state = 0;
 	new.b_blocknr = 0;
 	new.b_size = mpd->b_size;
 	next = mpd->b_blocknr;
diff --git a/fs/mpage.c b/fs/mpage.c
index 680ba60..42381bd 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -379,7 +379,8 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
-	clear_buffer_mapped(&map_bh);
+	map_bh.b_state = 0;
+	map_bh.b_size = 0;
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
@@ -412,7 +413,8 @@ int mpage_readpage(struct page *page, get_block_t get_block)
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
-	clear_buffer_mapped(&map_bh);
+	map_bh.b_state = 0;
+	map_bh.b_size = 0;
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
 			&map_bh, &first_logical_block, get_block);
 	if (bio)
-- 
1.6.3.rc4.1.g3e14.dirty

