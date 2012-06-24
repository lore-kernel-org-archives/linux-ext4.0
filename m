From: Tao Ma <tm@tao.ma>
Subject: [PATCH] e2fsprogs/csum: Use fs.csum_seed for xattr block csum calculation.
Date: Sun, 24 Jun 2012 22:22:36 +0800
Message-ID: <1340547756-2932-1-git-send-email-tm@tao.ma>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:50019 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753383Ab2FXOWu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jun 2012 10:22:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

As I mentioned in the kernel part patch with the subject
"ext4: Use s_csum_seed instead of i_csum_seed for xattr block csum",
it is not easy for the kernel to use the proper inode csum seed.
So always use the fs.csum_seed for the xattr block csum calculation.

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 lib/ext2fs/csum.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a7096d2..5ccbc1c 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -119,21 +119,9 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 	struct ext2_inode inode;
 
 	hdr->h_checksum = 0;
-	if (ext2fs_le32_to_cpu(hdr->h_refcount) != 1) {
-		block = ext2fs_cpu_to_le64(block);
-		*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&block,
-					sizeof(block));
-	} else {
-		retval = ext2fs_read_inode(fs, inum, &inode);
-		if (retval)
-			return retval;
-		inum = ext2fs_cpu_to_le32(inum);
-		gen = ext2fs_cpu_to_le32(inode.i_generation);
-		*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&inum,
-					sizeof(inum));
-		*crc = ext2fs_crc32c_le(*crc, (unsigned char *)&gen,
-					sizeof(gen));
-	}
+	block = ext2fs_cpu_to_le64(block);
+	*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&block,
+				sizeof(block));
 	*crc = ext2fs_crc32c_le(*crc, (unsigned char *)buf, fs->blocksize);
 	hdr->h_checksum = old_crc;
 
-- 
1.7.1

