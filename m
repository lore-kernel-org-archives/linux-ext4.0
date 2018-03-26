From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: don't allow r/w mounts if metadata blocks overlap the superblock
Date: Mon, 26 Mar 2018 00:49:06 -0400
Message-ID: <20180326044906.13286-2-tytso@mit.edu>
References: <20180326044906.13286-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180326044906.13286-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If some metadata block, such as an allocation bitmap, overlaps the
superblock, it's very likely that if the file system is mounted
read/write, the results will not be pretty.  So disallow r/w mounts
for file systems corrupted in this particular way.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7cd022c344d1..edcfe6956eba 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2335,6 +2335,8 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Block bitmap for group %u overlaps "
 				 "superblock", i);
+			if (!sb_rdonly(sb))
+				return 0;
 		}
 		if (block_bitmap < first_block || block_bitmap > last_block) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
@@ -2347,6 +2349,8 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Inode bitmap for group %u overlaps "
 				 "superblock", i);
+			if (!sb_rdonly(sb))
+				return 0;
 		}
 		if (inode_bitmap < first_block || inode_bitmap > last_block) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
@@ -2359,6 +2363,8 @@ static int ext4_check_descriptors(struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 				 "Inode table for group %u overlaps "
 				 "superblock", i);
+			if (!sb_rdonly(sb))
+				return 0;
 		}
 		if (inode_table < first_block ||
 		    inode_table + sbi->s_itb_per_group - 1 > last_block) {
-- 
2.16.1.72.g5be1f00a9a
