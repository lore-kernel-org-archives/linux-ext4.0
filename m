From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext3: speed up file creates by optimizing rec_len functions
Date: Tue, 07 Dec 2010 11:55:27 -0600
Message-ID: <4CFE750F.1080706@redhat.com>
References: <4CFE7347.8030807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LGR4D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Dec 2010 12:56:03 -0500
In-Reply-To: <4CFE7347.8030807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The addition of 64k block capability in the rec_len_from_disk
and rec_len_to_disk functions added a bit of math overhead which
slows down file create workloads needlessly when the architecture
cannot even support 64k blocks, thanks to page size limits.

Similar changes already exist in the ext4 codebase.

The directory entry checking can also be optimized a bit
by sprinkling in some unlikely() conditions to move the
error handling out of line.

bonnie++ sequential file creates on a 512MB ramdisk speeds up
from about 77,000/s to about 82,000/s, about a 6% improvement.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index e2e72c3..34f0a07 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -69,25 +69,26 @@ int ext3_check_dir_entry (const char * function, struct inode * dir,
 	const char * error_msg = NULL;
 	const int rlen = ext3_rec_len_from_disk(de->rec_len);
 
-	if (rlen < EXT3_DIR_REC_LEN(1))
+	if (unlikely(rlen < EXT3_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
-	else if (rlen % 4 != 0)
+	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (rlen < EXT3_DIR_REC_LEN(de->name_len))
+	else if (unlikely(rlen < EXT3_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
-	else if (((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)
+	else if (unlikely((((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)))
 		error_msg = "directory entry across blocks";
-	else if (le32_to_cpu(de->inode) >
-			le32_to_cpu(EXT3_SB(dir->i_sb)->s_es->s_inodes_count))
+	else if (unlikely(le32_to_cpu(de->inode) >
+			le32_to_cpu(EXT3_SB(dir->i_sb)->s_es->s_inodes_count)))
 		error_msg = "inode out of bounds";
 
-	if (error_msg != NULL)
+	if (unlikely(error_msg != NULL))
 		ext3_error (dir->i_sb, function,
 			"bad entry in directory #%lu: %s - "
 			"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error_msg, offset,
 			(unsigned long) le32_to_cpu(de->inode),
 			rlen, de->name_len);
+
 	return error_msg == NULL ? 1 : 0;
 }
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6ce1bca..e5ad445 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -724,21 +724,30 @@ struct ext3_dir_entry_2 {
 					 ~EXT3_DIR_ROUND)
 #define EXT3_MAX_REC_LEN		((1<<16)-1)
 
+/*
+ * Tests against MAX_REC_LEN etc were put in place for 64k block
+ * sizes; if that is not possible on this arch, we can skip
+ * those tests and speed things up.
+ */
 static inline unsigned ext3_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == EXT3_MAX_REC_LEN)
 		return 1 << 16;
+#endif
 	return len;
 }
 
 static inline __le16 ext3_rec_len_to_disk(unsigned len)
 {
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == (1 << 16))
 		return cpu_to_le16(EXT3_MAX_REC_LEN);
 	else if (len > (1 << 16))
 		BUG();
+#endif
 	return cpu_to_le16(len);
 }
 

