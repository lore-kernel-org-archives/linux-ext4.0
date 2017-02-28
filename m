From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: lock the the xattr block before calculating its checksum
Date: Tue, 28 Feb 2017 08:56:50 -0500
Message-ID: <20170228135650.28045-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41960 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752402AbdB1Ogc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 28 Feb 2017 09:36:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We must lock the xattr block in order to avoid spurious checksum
failures.

https://bugzilla.kernel.org/show_bug.cgi?id=193661

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/xattr.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 67636acf7624..3247057ef5ff 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -131,30 +131,27 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
 }
 
 static int ext4_xattr_block_csum_verify(struct inode *inode,
-					sector_t block_nr,
-					struct ext4_xattr_header *hdr)
+					struct buffer_head *bh)
 {
-	if (ext4_has_metadata_csum(inode->i_sb) &&
-	    (hdr->h_checksum != ext4_xattr_block_csum(inode, block_nr, hdr)))
-		return 0;
-	return 1;
-}
-
-static void ext4_xattr_block_csum_set(struct inode *inode,
-				      sector_t block_nr,
-				      struct ext4_xattr_header *hdr)
-{
-	if (!ext4_has_metadata_csum(inode->i_sb))
-		return;
+	struct ext4_xattr_header *hdr = BHDR(bh);
+	int ret = 1;
 
-	hdr->h_checksum = ext4_xattr_block_csum(inode, block_nr, hdr);
+	if (ext4_has_metadata_csum(inode->i_sb)) {
+		lock_buffer(bh);
+		ret = hdr->h_checksum == ext4_xattr_block_csum(inode,
+							bh->b_blocknr, hdr);
+		unlock_buffer(bh);
+	}
+	return ret;
 }
 
 static inline int ext4_handle_dirty_xattr_block(handle_t *handle,
 						struct inode *inode,
 						struct buffer_head *bh)
 {
-	ext4_xattr_block_csum_set(inode, bh->b_blocknr, BHDR(bh));
+	if (ext4_has_metadata_csum(inode->i_sb))
+		BHDR(bh)->h_checksum = ext4_xattr_block_csum(inode,
+						bh->b_blocknr, BHDR(bh));
 	return ext4_handle_dirty_metadata(handle, inode, bh);
 }
 
@@ -233,7 +230,7 @@ ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1))
 		return -EFSCORRUPTED;
-	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
+	if (!ext4_xattr_block_csum_verify(inode, bh))
 		return -EFSBADCRC;
 	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
 				       bh->b_data);
-- 
2.11.0.rc0.7.gbe5a750
