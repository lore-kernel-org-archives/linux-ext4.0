From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Only zero partial blocks in ext4_zero_partial_blocks()
Date: Thu, 20 Jun 2013 11:14:33 +0200
Message-ID: <1371719673-3033-1-git-send-email-lczerner@redhat.com>
References: <20130619234243.GE24587@thunk.org>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817Ab3FTJOk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 05:14:40 -0400
In-Reply-To: <20130619234243.GE24587@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently if we pass range into ext4_zero_partial_blocks() which covers
entire block we would attempt to zero it even though we should only zero
unaligned part of the block.

Fix this by checking whether the range covers the whole block skip
zeroing if so.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3acf353..ce9f926 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3698,33 +3698,36 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 {
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
-	unsigned partial = lstart & (sb->s_blocksize - 1);
+	unsigned partial_start, partial_end;
 	ext4_fsblk_t start, end;
 	loff_t byte_end = (lstart + length - 1);
 	int err = 0;
 
+	partial_start = lstart & (sb->s_blocksize - 1);
+	partial_end = byte_end & (sb->s_blocksize - 1);
+
 	start = lstart >> sb->s_blocksize_bits;
 	end = byte_end >> sb->s_blocksize_bits;
 
 	/* Handle partial zero within the single block */
-	if (start == end) {
+	if (start == end &&
+	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
 		err = ext4_block_zero_page_range(handle, mapping,
 						 lstart, length);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
-	if (partial) {
+	if (partial_start) {
 		err = ext4_block_zero_page_range(handle, mapping,
 						 lstart, sb->s_blocksize);
 		if (err)
 			return err;
 	}
 	/* Handle partial zero out on the end of the range */
-	partial = byte_end & (sb->s_blocksize - 1);
-	if (partial != sb->s_blocksize - 1)
+	if (partial_end != sb->s_blocksize - 1)
 		err = ext4_block_zero_page_range(handle, mapping,
-						 byte_end - partial,
-						 partial + 1);
+						 byte_end - partial_end,
+						 partial_end + 1);
 	return err;
 }
 
-- 
1.8.2.1

