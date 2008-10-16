From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: let the block device know when unused blocks can be discarded
Date: Thu, 16 Oct 2008 09:49:11 -0400
Message-ID: <1224164951-10719-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	David Woodhouse <David.Woodhouse@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54548 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752187AbYJPNtP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 09:49:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let the block device know when unused blocks can be discarded, using
the new sb_issue_discard() interface.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---

This patch depends on the use-rbtree patch by Aneesh which is in the
ext4 patch queue.  I'm using systemtap and a trace marker to test this
patch because my test system uses LVM, and device mapper isn't passing
BARRIER_DISCARD, so I can't use blktrace.

 fs/ext4/mballoc.c |    7 +++++++
 fs/ext4/mballoc.h |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c22b904..e86f88b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2653,6 +2653,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err, count = 0, count2 = 0;
 	struct ext4_free_data *entry;
+	ext4_fsblk_t discard_block;
 
 	if (list_empty(&sbi->s_committed_transaction))
 		return;
@@ -2696,6 +2697,12 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 			page_cache_release(e4b.bd_bitmap_page);
 		}
 		ext4_unlock_group(sb, entry->group);
+		discard_block = (ext4_fsblk_t) entry->group * EXT4_BLOCKS_PER_GROUP(sb)
+			+ entry->start_blk
+			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
+		trace_mark(ext4_discard_blocks, "dev %s blk %llu count %u", sb->s_id,
+			   (unsigned long long) discard_block, entry->count);
+		sb_issue_discard(sb, discard_block, entry->count);
 
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 9e815c4..94cb7b9 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -18,6 +18,8 @@
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/version.h>
+#include <linux/blkdev.h>
+#include <linux/marker.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include "group.h"
-- 
1.5.6.1.205.ge2c7.dirty

