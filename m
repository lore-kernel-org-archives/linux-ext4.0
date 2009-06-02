From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 16/18] ext4: Use a fake block number for delayed new buffer_head
Date: Tue,  2 Jun 2009 08:07:57 -0400
Message-ID: <1243944479-20574-16-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
 <1243944479-20574-9-git-send-email-tytso@mit.edu>
 <1243944479-20574-10-git-send-email-tytso@mit.edu>
 <1243944479-20574-11-git-send-email-tytso@mit.edu>
 <1243944479-20574-12-git-send-email-tytso@mit.edu>
 <1243944479-20574-13-git-send-email-tytso@mit.edu>
 <1243944479-20574-14-git-send-email-tytso@mit.edu>
 <1243944479-20574-15-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33541 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZFBMIL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:11 -0400
In-Reply-To: <1243944479-20574-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Use a very large unsigned number (~0xffff) as as the fake block number
for the delayed new buffer. The VFS should never try to write out this
number, but if it does, this will make it obvious.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 33b9817e2ae097c7b8d256e3510ac6c54fc6d9d0)
---
 fs/ext4/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2caeda7..4ed5e92 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2220,6 +2220,10 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 				  struct buffer_head *bh_result, int create)
 {
 	int ret = 0;
+	sector_t invalid_block = ~((sector_t) 0xffff);
+
+	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
+		invalid_block = ~0;
 
 	BUG_ON(create == 0);
 	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
@@ -2241,7 +2245,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			/* not enough space to reserve */
 			return ret;
 
-		map_bh(bh_result, inode->i_sb, 0);
+		map_bh(bh_result, inode->i_sb, invalid_block);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
-- 
1.6.3.1.1.g75fc.dirty

