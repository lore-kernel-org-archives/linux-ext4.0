From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/16] ext4: Create bitmap checksum helper functions
Date: Wed, 31 Aug 2011 17:31:19 -0700
Message-ID: <20110901003119.31048.40300.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

These helper functions will be used to calculate and verify the block and inode
bitmap checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/bitmap.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |    6 ++++++
 2 files changed, 50 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index fa3af81..5421152 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -9,6 +9,7 @@
 
 #include <linux/buffer_head.h>
 #include <linux/jbd2.h>
+#include <linux/crc32c.h>
 #include "ext4.h"
 
 #ifdef EXT4FS_DEBUG
@@ -29,3 +30,46 @@ unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 
 #endif  /*  EXT4FS_DEBUG  */
 
+__le32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
+			struct buffer_head *bh, int sz)
+{
+	__le32 crc;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT)
+		return 0;
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	group = cpu_to_le32(group);
+	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	crc = crc32c_le(crc, (__u8 *)&group, sizeof(group));
+	crc = crc32c_le(crc, (__u8 *)bh->b_data, sz);
+
+	return cpu_to_le32(crc);
+}
+
+int ext4_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
+			    __le32 provided, struct buffer_head *bh, int sz)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (sbi->s_desc_size >= EXT4_MIN_DESC_SIZE_64BIT &&
+	    EXT4_HAS_RO_COMPAT_FEATURE(sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (provided != ext4_bitmap_csum(sb, group, bh, sz)))
+		return 0;
+	return 1;
+}
+
+void ext4_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
+			  __le32 *csum, struct buffer_head *bh, int sz)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (sbi->s_desc_size >= EXT4_MIN_DESC_SIZE_64BIT &&
+	    EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		*csum = ext4_bitmap_csum(sb, group, bh, sz);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e2361cc..bc7ace1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1722,6 +1722,12 @@ struct mmpd_data {
 
 /* bitmap.c */
 extern unsigned int ext4_count_free(struct buffer_head *, unsigned);
+__le32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
+			struct buffer_head *bh, int sz);
+int ext4_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
+			    __le32 provided, struct buffer_head *bh, int sz);
+void ext4_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
+			  __le32 *csum, struct buffer_head *bh, int sz);
 
 /* balloc.c */
 extern unsigned int ext4_block_group(struct super_block *sb,
