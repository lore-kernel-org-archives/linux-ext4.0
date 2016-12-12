From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/6] ext2: Return BH_New buffers for zeroed blocks
Date: Mon, 12 Dec 2016 17:47:03 +0100
Message-ID: <20161212164708.23244-2-jack@suse.cz>
References: <20161212164708.23244-1-jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	<linux-mm@kvack.org>,
	<linux-ext4@vger.kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161212164708.23244-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

So far we did not return BH_New buffers from ext2_get_blocks() when we
allocated and zeroed-out a block for DAX inode to avoid racy zeroing in
DAX code. This zeroing is gone these days so we can remove the
workaround.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 046b642f3585..e626fe892c01 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -754,9 +754,8 @@ static int ext2_get_blocks(struct inode *inode,
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
 		}
-	} else {
-		*new = true;
 	}
+	*new = true;
 
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
-- 
2.10.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
