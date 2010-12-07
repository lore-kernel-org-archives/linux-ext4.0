From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len functions
Date: Tue, 07 Dec 2010 11:51:05 -0600
Message-ID: <4CFE7409.9090609@redhat.com>
References: <4CFE7347.8030807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab0LGRvM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Dec 2010 12:51:12 -0500
In-Reply-To: <4CFE7347.8030807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The addition of 64k block capability in the rec_len_from_disk
and rec_len_to_disk functions added a bit of math overhead which
slows down file create workloads needlessly when the architecture
cannot even support 64k blocks, thanks to page size limits.

The directory entry checking can also be optimized a bit
by sprinkling in some unlikely() conditions to move the
error handling out of line.

bonnie++ sequential file creates on a 512MB ramdisk speeds up
from about 2200/s to about 2500/s, about a 14% improvement.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2709b34..47cda41 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -28,21 +28,30 @@
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
+/*
+ * Tests against MAX_REC_LEN etc were put in place for 64k block
+ * sizes; if that is not possible on this arch, we can skip
+ * those tests and speed things up.
+ */
 static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == EXT2_MAX_REC_LEN)
 		return 1 << 16;
+#endif
 	return len;
 }
 
 static inline __le16 ext2_rec_len_to_disk(unsigned len)
 {
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == (1 << 16))
 		return cpu_to_le16(EXT2_MAX_REC_LEN);
 	else
 		BUG_ON(len > (1 << 16));
+#endif
 	return cpu_to_le16(len);
 }
 
@@ -129,15 +138,15 @@ static void ext2_check_page(struct page *page, int quiet)
 		p = (ext2_dirent *)(kaddr + offs);
 		rec_len = ext2_rec_len_from_disk(p->rec_len);
 
-		if (rec_len < EXT2_DIR_REC_LEN(1))
+		if (unlikely(rec_len < EXT2_DIR_REC_LEN(1)))
 			goto Eshort;
-		if (rec_len & 3)
+		if (unlikely(rec_len & 3))
 			goto Ealign;
-		if (rec_len < EXT2_DIR_REC_LEN(p->name_len))
+		if (unlikely(rec_len < EXT2_DIR_REC_LEN(p->name_len)))
 			goto Enamelen;
-		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
+		if (unlikely(((offs + rec_len - 1) ^ offs) & ~(chunk_size-1)))
 			goto Espan;
-		if (le32_to_cpu(p->inode) > max_inumber)
+		if (unlikely(le32_to_cpu(p->inode) > max_inumber))
 			goto Einumber;
 	}
 	if (offs != limit)

