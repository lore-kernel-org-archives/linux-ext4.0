From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Convert ext4_extent.ee_start to ext4_extent.ee_start_lo
Date: Thu,  4 Oct 2007 01:50:57 -0400
Message-ID: <1191477059-5357-23-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
 <1191477059-5357-7-git-send-email-tytso@mit.edu>
 <1191477059-5357-8-git-send-email-tytso@mit.edu>
 <1191477059-5357-9-git-send-email-tytso@mit.edu>
 <1191477059-5357-10-git-send-email-tytso@mit.edu>
 <1191477059-5357-11-git-send-email-tytso@mit.edu>
 <1191477059-5357-12-git-send-email-tytso@mit.edu>
 <1191477059-5357-13-git-send-email-tytso@mit.edu>
 <1191477059-5357-14-git-send-email-tytso@mit.edu>
 <1191477059-5357-15-git-send-email-tytso@mit.edu>
 <1191477059-5357-16-git-send-email-tytso@mit.edu>
 <1191477059-5357-17-git-send-email-tytso@mit.edu>
 <1191477059-5357-18-git-send-email-tytso@mit.edu>
 <1191477059-5357-19-git-send-email-tytso@mit.edu>
 <1191477059-5357-20-git-send-email-tytso@mit.edu>
 <1191477059-5357-21-git-send-email-tytso@mit.edu>
 <1191477059-5357-22-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44825 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbXJDFvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:10 -0400
In-Reply-To: <1191477059-5357-22-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Convert ext4_extent.ee_start to ext4_extent.ee_start_lo
This helps in finding BUGs due to direct partial access of
these split 48 bit values

Also fix direct partial access in ext4 code

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |    8 +++-----
 include/linux/ext4_fs_extents.h |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2be404f..c03056a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -52,7 +52,7 @@ static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ex->ee_start);
+	block = le32_to_cpu(ex->ee_start_lo);
 	block |= ((ext4_fsblk_t) le16_to_cpu(ex->ee_start_hi) << 31) << 1;
 	return block;
 }
@@ -77,7 +77,7 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
  */
 static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
-	ex->ee_start = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ex->ee_start_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
@@ -1409,8 +1409,7 @@ has_space:
 	eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries)+1);
 	nearex = path[depth].p_ext;
 	nearex->ee_block = newext->ee_block;
-	nearex->ee_start = newext->ee_start;
-	nearex->ee_start_hi = newext->ee_start_hi;
+	ext4_ext_store_pblock(nearex, ext_pblock(newext));
 	nearex->ee_len = newext->ee_len;
 
 merge:
@@ -2177,7 +2176,6 @@ int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 	}
 	/* ex2: iblock to iblock + maxblocks-1 : initialised */
 	ex2->ee_block = cpu_to_le32(iblock);
-	ex2->ee_start = cpu_to_le32(newblock);
 	ext4_ext_store_pblock(ex2, newblock);
 	ex2->ee_len = cpu_to_le16(allocated);
 	if (ex2 != ex)
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 81406f3..cb2dfbb 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -74,7 +74,7 @@ struct ext4_extent {
 	__le32	ee_block;	/* first logical block extent covers */
 	__le16	ee_len;		/* number of blocks covered by extent */
 	__le16	ee_start_hi;	/* high 16 bits of physical block */
-	__le32	ee_start;	/* low 32 bits of physical block */
+	__le32	ee_start_lo;	/* low 32 bits of physical block */
 };
 
 /*
-- 
1.5.3.2.81.g17ed
