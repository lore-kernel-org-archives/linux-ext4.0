From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] ext4: fix big-endian bug in metadata checksum calculations
Date: Wed, 10 Apr 2013 00:02:27 -0400
Message-ID: <1365566549-23325-2-git-send-email-tytso@mit.edu>
References: <20130410040151.GB4862@thunk.org>
 <1365566549-23325-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1365566549-23325-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/inode.c | 8 ++++----
 fs/ext4/mmp.c   | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 629d67b..62189c8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -55,21 +55,21 @@ static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 	__u16 csum_hi = 0;
 	__u32 csum;
 
-	csum_lo = raw->i_checksum_lo;
+	csum_lo = le16_to_cpu(raw->i_checksum_lo);
 	raw->i_checksum_lo = 0;
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
-		csum_hi = raw->i_checksum_hi;
+		csum_hi = le16_to_cpu(raw->i_checksum_hi);
 		raw->i_checksum_hi = 0;
 	}
 
 	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)raw,
 			   EXT4_INODE_SIZE(inode->i_sb));
 
-	raw->i_checksum_lo = csum_lo;
+	raw->i_checksum_lo = cpu_to_le16(csum_lo);
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
-		raw->i_checksum_hi = csum_hi;
+		raw->i_checksum_hi = cpu_to_le16(csum_hi);
 
 	return csum;
 }
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index f9b5515..b3b1f7d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -7,7 +7,7 @@
 #include "ext4.h"
 
 /* Checksumming functions */
-static __u32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int offset = offsetof(struct mmp_struct, mmp_checksum);
-- 
1.7.12.rc0.22.gcdd159b
