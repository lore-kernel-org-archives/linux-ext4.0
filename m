From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH V5  4/5] QUOTA cleanup: Use inode->i_blkbits to get block
	bits
Date: Mon, 05 Jan 2009 20:41:14 -0800
Message-ID: <1231216874.9267.29.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:60921 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZAFElT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 23:41:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

quota: Use inode->i_blkbits to get block bits

From: Mingming Cao <cmm@us.ibm.com>

Andrew has suggested to use inode->i_blkbits to get the block bits info,
rather than use super block's blockbits. That should be faster and emit
less code.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 include/linux/quotaops.h |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

Index: linux-2.6.28-git7/include/linux/quotaops.h
===================================================================
--- linux-2.6.28-git7.orig/include/linux/quotaops.h	2009-01-05 20:06:37.000000000 -0800
+++ linux-2.6.28-git7/include/linux/quotaops.h	2009-01-05 20:06:52.000000000 -0800
@@ -412,39 +412,32 @@ static inline void vfs_dq_free_space(str
 
 static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_prealloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_prealloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
- 	return vfs_dq_alloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
-
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_alloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_alloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_reserve_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_reserve_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_claim_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_claim_space(inode, nr << inode->i_blkbits);
 }
 
 static inline
@@ -455,12 +448,12 @@ void vfs_dq_release_reservation_block(st
 
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline void vfs_dq_free_block(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space(inode, nr << inode->i_blkbits);
 }
 
 /*


