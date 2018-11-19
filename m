Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f176.google.com ([209.85.166.176]:55275 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbeKSTkj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2018 14:40:39 -0500
Received: by mail-it1-f176.google.com with SMTP id a205-v6so7124617itd.4
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 01:17:37 -0800 (PST)
From: alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: [PATCH 3/3] add support to check a journal checksum v1 while journal dump.
Date: Mon, 19 Nov 2018 12:16:50 +0300
Message-Id: <20181119091650.81803-4-alexey.lyashkov@gmail.com>
In-Reply-To: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------2.18.0"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Lyashkov <alexey.lyashkov@gmail.com>

This is a multi-part message in MIME format.
--------------2.18.0
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


journal checksum v1 cover an all blocks in journal descriptor.
This checksum stored into commit block and check with commit
block reading.

Signed-off-by: Alexey Lyashkov <alexey.lyashkov@gmail.com>
---
 debugfs/logdump.c | 69 ++++++++++++++++++++++++++++++++++++++---------
 e2fsck/jfs_user.h |  5 ++++
 2 files changed, 62 insertions(+), 12 deletions(-)


--------------2.18.0
Content-Type: text/x-patch; name="0003-add-support-to-check-a-journal-checksum-v1-while-jou.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0003-add-support-to-check-a-journal-checksum-v1-while-jou.patch"

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index c88f6f9c..3dd04789 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -55,7 +55,7 @@ static void dump_journal(char *, FILE *, struct journal_source *);
 
 static void dump_descriptor_block(FILE *, struct journal_source *,
 				  char *, journal_superblock_t *,
-				  unsigned int *, int, tid_t);
+				  unsigned int *, int, tid_t, __u32 *);
 
 static void dump_revoke_block(FILE *, char *, journal_superblock_t *,
 				  blk64_t, int, tid_t);
@@ -63,10 +63,14 @@ static void dump_revoke_block(FILE *, char *, journal_superblock_t *,
 static void dump_metadata_block(FILE *, struct journal_source *,
 				journal_superblock_t*,
 				unsigned int, blk64_t, unsigned int,
-				int, tid_t);
+				int, tid_t, __u32 *);
 
 static void do_hexdump (FILE *, char *, int);
 
+static void jbd2_check_commit_cksum(FILE *, struct journal_source *,
+				  journal_superblock_t *,
+				  unsigned int , int , __u32);
+
 #define WRAP(jsb, blocknr)					\
 	if (blocknr >= be32_to_cpu((jsb)->s_maxlen))		\
 		blocknr -= (be32_to_cpu((jsb)->s_maxlen) -	\
@@ -353,6 +357,7 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	journal_header_t	*header;
 	tid_t			transaction;
 	unsigned int		blocknr = 0;
+	__u32			crc32_sum = ~0;
 
 	/* First, check to see if there's an ext2 superblock header */
 	retval = read_journal_block(cmdname, source, 0, buf, 2048);
@@ -453,12 +458,16 @@ static void dump_journal(char *cmdname, FILE *out_file,
 		case JFS_DESCRIPTOR_BLOCK:
 			dump_descriptor_block(out_file, source, buf, jsb,
 					      &blocknr, blocksize,
-					      transaction);
+					      transaction, &crc32_sum);
 			continue;
 
 		case JFS_COMMIT_BLOCK:
+			jbd2_check_commit_cksum(out_file, source,
+						jsb, blocknr, blocksize,
+						crc32_sum);
 			transaction++;
 			blocknr++;
+			crc32_sum = ~0;
 			WRAP(jsb, blocknr);
 			continue;
 
@@ -511,7 +520,7 @@ static void dump_descriptor_block(FILE *out_file,
 				  char *buf,
 				  journal_superblock_t *jsb,
 				  unsigned int *blockp, int blocksize,
-				  tid_t transaction)
+				  tid_t transaction, __u32 *crc32_sum)
 {
 	int			offset, tag_size, csum_size = 0;
 	char			*tagp;
@@ -535,6 +544,9 @@ static void dump_descriptor_block(FILE *out_file,
 	++blocknr;
 	WRAP(jsb, blocknr);
 
+	if (JSB_HAS_COMPAT_FEATURE(jsb, JFS_FEATURE_COMPAT_CHECKSUM))
+		*crc32_sum = ext2fs_crc32_be(*crc32_sum, buf, blocksize);
+
 	do {
 		/* Work out the location of the current tag, and skip to
 		 * the next one... */
@@ -555,7 +567,7 @@ static void dump_descriptor_block(FILE *out_file,
 
 		dump_metadata_block(out_file, source, jsb,
 				    blocknr, tag_block, tag_flags, blocksize,
-				    transaction);
+				    transaction, crc32_sum);
 
 		++blocknr;
 		WRAP(jsb, blocknr);
@@ -630,7 +642,7 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 				blk64_t fs_blocknr,
 				unsigned int log_tag_flags,
 				int blocksize,
-				tid_t transaction)
+				tid_t transaction, __u32 *crc32_sum)
 {
 	int		retval;
 	char 		buf[8192];
@@ -659,18 +671,21 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 	 * structure symbolically.
 	 */
 
-	if (!(dump_contents && dump_all)
-	    && fs_blocknr != block_to_dump
-	    && fs_blocknr != bitmap_to_dump
-	    && fs_blocknr != inode_block_to_dump)
-		return;
-
 	retval = read_journal_block("logdump", source,
 				    ((ext2_loff_t) log_blocknr) * blocksize,
 				    buf, blocksize);
 	if (retval)
 		return;
 
+	if (JSB_HAS_COMPAT_FEATURE(jsb, JFS_FEATURE_COMPAT_CHECKSUM))
+		*crc32_sum = ext2fs_crc32_be(*crc32_sum, buf, blocksize);
+
+	if (!(dump_contents && dump_all)
+	    && fs_blocknr != block_to_dump
+	    && fs_blocknr != bitmap_to_dump
+	    && fs_blocknr != inode_block_to_dump)
+		return;
+
 	if (fs_blocknr == bitmap_to_dump) {
 		struct ext2_super_block *super;
 		int offset;
@@ -751,3 +766,33 @@ static void do_hexdump (FILE *out_file, char *buf, int blocksize)
 	}
 }
 
+static void jbd2_check_commit_cksum(FILE *out_file, struct journal_source *source,
+				  journal_superblock_t *jsb,
+				  unsigned int blocknr, int blocksize,
+				  __u32 crc32_sum)
+{
+	char 		buf[8192];
+	struct commit_header *h = (void *)&buf[0];
+	int retval;
+
+	if (!dump_all)
+		return;
+
+	retval = read_journal_block("logdump", source,
+				    ((ext2_loff_t) blocknr) * blocksize,
+				    buf, blocksize);
+	if (retval)
+		return;
+
+	if (JSB_HAS_COMPAT_FEATURE(jsb, JFS_FEATURE_COMPAT_CHECKSUM)) {
+		if (h->h_chksum_type != JBD2_CRC32_CHKSUM)
+			fprintf(out_file, "Unknow commit checksum %u\n",
+				h->h_chksum);
+		if (h->h_chksum_size != JBD2_CRC32_CHKSUM_SIZE)
+			fprintf(out_file, "Unknown checksum size %u\n",
+				h->h_chksum_size);
+		if (h->h_chksum[0] != cpu_to_be32(crc32_sum))
+			fprintf(out_file, "Wrong checksum %u <> %u\n",
+				h->h_chksum[0], cpu_to_be32(crc32_sum));
+	}
+}
diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index a1c6951c..6e42a2a6 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -204,6 +204,11 @@ void wait_on_buffer(struct buffer_head *bh);
 #define JSB_HAS_INCOMPAT_FEATURE(jsb, mask)				\
 	((jsb)->s_header.h_blocktype == ext2fs_cpu_to_be32(JFS_SUPERBLOCK_V2) &&	\
 	 ((jsb)->s_feature_incompat & ext2fs_cpu_to_be32((mask))))
+
+#define JSB_HAS_COMPAT_FEATURE(jsb, mask)				\
+	((jsb)->s_header.h_blocktype == ext2fs_cpu_to_be32(JFS_SUPERBLOCK_V2) &&	\
+	 ((jsb)->s_feature_compat & ext2fs_cpu_to_be32((mask))))
+
 #else  /* !DEBUGFS */
 
 extern e2fsck_t e2fsck_global_ctx;  /* Try your very best not to use this! */

--------------2.18.0--
