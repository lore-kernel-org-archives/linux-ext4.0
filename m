From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Fix data exposure after a crash
Date: Wed, 30 Mar 2016 18:19:24 +0200
Message-ID: <1459354767-8693-2-git-send-email-jack@suse.cz>
References: <1459354767-8693-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Weller.Huang@cn.bosch.com,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbcC3QTI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Mar 2016 12:19:08 -0400
In-Reply-To: <1459354767-8693-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Huang has reported that in his powerfail testing he is seeing stale
block contents in some of recently allocated blocks although he mounts
ext4 in data=ordered mode. After some investigation I have found out
that indeed when delayed allocation is used, we don't add inode to
transaction's list of inodes needing flushing before commit. Originally
we were doing that but commit f3b59291a69d removed the logic with a
flawed argument that it is not needed.

The problem is that although for delayed allocated blocks we write their
contents immediately after allocating them, there is no guarantee that
the IO scheduler or device doesn't reorder things and thus transaction
allocating blocks and attaching them to inode can reach stable storage
before actual block contents. Actually whenever we attach freshly
allocated blocks to inode using a written extent, we should add inode to
transaction's ordered inode list to make sure we properly wait for block
contents to be written before committing the transaction. So that is
what we do in this patch. This also handles other cases where stale data
exposure was possible - like filling hole via mmap in
data=ordered,nodelalloc mode.

The only exception to the above rule are extending direct IO writes where
blkdev_direct_IO() waits for IO to complete before increasing i_size and
thus stale data exposure is not possible. For now we don't complicate
the code with optimizing this special case since the overhead is pretty
low. In case this is observed to be a performance problem we can always
handle it using a special flag to ext4_map_blocks().

CC: stable@vger.kernel.org
Fixes: f3b59291a69d0b734be1fc8be489fef2dd846d3d
Reported-by: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Tested-by: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dab84a2530ff..747b0e64b9d2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -684,6 +684,20 @@ out_sem:
 		ret = check_block_validity(inode, map);
 		if (ret != 0)
 			return ret;
+
+		/*
+		 * Inodes with freshly allocated blocks where contents will be
+		 * visible after transaction commit must be on transaction's
+		 * ordered data list.
+		 */
+		if (map->m_flags & EXT4_MAP_NEW &&
+		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
+		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
+		    ext4_should_order_data(inode)) {
+			ret = ext4_jbd2_file_inode(handle, inode);
+			if (ret)
+				return ret;
+		}
 	}
 	return retval;
 }
@@ -1291,15 +1305,6 @@ static int ext4_write_end(struct file *file,
 	int i_size_changed = 0;
 
 	trace_ext4_write_end(inode, pos, len, copied);
-	if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE)) {
-		ret = ext4_jbd2_file_inode(handle, inode);
-		if (ret) {
-			unlock_page(page);
-			page_cache_release(page);
-			goto errout;
-		}
-	}
