From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/28] ext2: avoid bogus -Wmaybe-uninitialized warning
Date: Tue, 18 Oct 2016 00:05:34 +0200
Message-ID: <20161017220557.1688282-5-arnd@arndb.de>
References: <20161017220342.1627073-1-arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161017220342.1627073-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On ARM, we get this false-positive warning since the rework of
the ext2_get_blocks interface:

fs/ext2/inode.c: In function 'ext2_get_block':
include/linux/buffer_head.h:340:16: error: 'bno' may be used uninitialized in this function [-Werror=maybe-uninitialized]

The calling conventions for this function are rather complex, and it's
not surprising that the compiler gets this wrong, I spent a long time
trying to understand how it all fits together myself.

This change to avoid the warning makes sure the compiler sees that we
always set 'bno' pointer whenever we have a positive return code.
The transformation is correct because we always arrive at the 'got_it'
label with a positive count that gets used as the return value, while
any branch to the 'cleanup' label has a negative or zero 'err'.

Fixes: 6750ad71986d ("ext2: stop passing buffer_head to ext2_get_blocks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
---
 fs/ext2/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d831e24..41b8b44 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -622,7 +622,7 @@ static int ext2_get_blocks(struct inode *inode,
 			   u32 *bno, bool *new, bool *boundary,
 			   int create)
 {
-	int err = -EIO;
+	int err;
 	int offsets[4];
 	Indirect chain[4];
 	Indirect *partial;
@@ -639,7 +639,7 @@ static int ext2_get_blocks(struct inode *inode,
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
 	if (depth == 0)
-		return (err);
+		return -EIO;
 
 	partial = ext2_get_branch(inode, depth, offsets, chain, &err);
 	/* Simplest case - block found, no allocation needed */
@@ -761,7 +761,6 @@ static int ext2_get_blocks(struct inode *inode,
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
 got_it:
-	*bno = le32_to_cpu(chain[depth-1].key);
 	if (count > blocks_to_boundary)
 		*boundary = true;
 	err = count;
@@ -772,6 +771,8 @@ static int ext2_get_blocks(struct inode *inode,
 		brelse(partial->bh);
 		partial--;
 	}
+	if (err > 0)
+		*bno = le32_to_cpu(chain[depth-1].key);
 	return err;
 }
 
-- 
2.9.0
