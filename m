From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC 1/9] ext4: Adding itree feature and inode flags
Date: Sat,  4 May 2013 23:28:34 +0200
Message-ID: <1367702922-3236-2-git-send-email-rpazdera@redhat.com>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759251Ab3EDVeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:34:21 -0400
In-Reply-To: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds two new flags for the itree. A new read-only file
system feature flag:

    EXT4_FEATURE_RO_COMPAT_ITREE    0x1000

And an inode flag to indicate that a directory has itree:

    EXT4_ITREE_FL = 0x10000000
    EXT4_INODE_ITREE = 29

Also a macro for checking these flags on a directory was added.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/ext4.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3b83cd6..763f958 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -400,6 +400,7 @@ struct flex_groups {
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
+#define EXT4_ITREE_FL			0x20000000 /* Directory has itree */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
@@ -457,6 +458,7 @@ enum {
 	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
 	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
 	EXT4_INODE_INLINE_DATA	= 28,	/* Data in inode. */
+	EXT4_INODE_ITREE	= 29,	/* Directory has itree */
 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
 };
 
@@ -501,6 +503,7 @@ static inline void ext4_check_flag_values(void)
 	CHECK_FLAG_VALUE(EA_INODE);
 	CHECK_FLAG_VALUE(EOFBLOCKS);
 	CHECK_FLAG_VALUE(INLINE_DATA);
+	CHECK_FLAG_VALUE(ITREE);
 	CHECK_FLAG_VALUE(RESERVED);
 }
 
@@ -1481,6 +1484,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+#define EXT4_FEATURE_RO_COMPAT_ITREE		0x1000
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1530,7 +1534,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
+					 EXT4_FEATURE_RO_COMPAT_ITREE)
 
 /*
  * Default values for user and/or group using reserved blocks
@@ -1688,6 +1693,11 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
 #define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
 
+#define dx_itree(dir) (is_dx(dir) && \
+		       EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb, \
+					EXT4_FEATURE_RO_COMPAT_ITREE) && \
+		       ext4_test_inode_flag((dir), EXT4_INODE_ITREE))
+
 /* Legal values for the dx_root hash_version field: */
 
 #define DX_HASH_LEGACY		0
-- 
1.7.11.7

