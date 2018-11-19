Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f52.google.com ([209.85.166.52]:36083 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbeKSTkd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2018 14:40:33 -0500
Received: by mail-io1-f52.google.com with SMTP id m19so16035343ioh.3
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 01:17:31 -0800 (PST)
From: alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Alexey Lyashkov <alexey.lyashkov@seagate.com>
Subject: [PATCH 1/3] block number output fix.
Date: Mon, 19 Nov 2018 12:16:48 +0300
Message-Id: <20181119091650.81803-2-alexey.lyashkov@gmail.com>
In-Reply-To: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------2.18.0"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Lyashkov <alexey.lyashkov@seagate.com>

This is a multi-part message in MIME format.
--------------2.18.0
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


debugfs lack a support journal tag v3 and block numbers over 2^32
fix it.
---
 debugfs/logdump.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)


--------------2.18.0
Content-Type: text/x-patch; name="0001-block-number-output-fix.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0001-block-number-output-fix.patch"

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index e286ae83..84108a6e 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -58,11 +58,11 @@ static void dump_descriptor_block(FILE *, struct journal_source *,
 				  unsigned int *, int, tid_t);
 
 static void dump_revoke_block(FILE *, char *, journal_superblock_t *,
-				  unsigned int, int, tid_t);
+				  blk64_t, int, tid_t);
 
 static void dump_metadata_block(FILE *, struct journal_source *,
 				journal_superblock_t*,
-				unsigned int, unsigned int, unsigned int,
+				unsigned int, blk64_t, unsigned int,
 				int, tid_t);
 
 static void do_hexdump (FILE *, char *, int);
@@ -496,6 +496,16 @@ static inline size_t journal_super_tag_bytes(journal_superblock_t *jsb)
 	return sz - sizeof(__u32);
 }
 
+static blk64_t tag_blocknr(journal_superblock_t *jsb,
+			      journal_block_tag_t *tag)
+{
+	blk64_t block = be32_to_cpu(tag->t_blocknr);
+
+	if (JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_64BIT))
+		block |= (u64)be32_to_cpu(tag->t_blocknr_high) << 32;
+	return block;
+}
+
 static void dump_descriptor_block(FILE *out_file,
 				  struct journal_source *source,
 				  char *buf,
@@ -507,7 +517,7 @@ static void dump_descriptor_block(FILE *out_file,
 	char			*tagp;
 	journal_block_tag_t	*tag;
 	unsigned int		blocknr;
-	__u32			tag_block;
+	blk64_t			tag_block;
 	__u32			tag_flags;
 
 	tag_size = journal_super_tag_bytes(jsb);
@@ -537,7 +547,7 @@ static void dump_descriptor_block(FILE *out_file,
 		if (offset > blocksize - csum_size)
 			break;
 
-		tag_block = be32_to_cpu(tag->t_blocknr);
+		tag_block = tag_blocknr(jsb, tag);
 		tag_flags = be16_to_cpu(tag->t_flags);
 
 		if (!(tag_flags & JFS_FLAG_SAME_UUID))
@@ -558,7 +568,7 @@ static void dump_descriptor_block(FILE *out_file,
 
 static void dump_revoke_block(FILE *out_file, char *buf,
 			      journal_superblock_t *jsb EXT2FS_ATTR((unused)),
-			      unsigned int blocknr,
+			      blk64_t blocknr,
 			      int blocksize EXT2FS_ATTR((unused)),
 			      tid_t transaction)
 {
@@ -569,9 +579,9 @@ static void dump_revoke_block(FILE *out_file, char *buf,
 
 	if (dump_all)
 		fprintf(out_file, "Dumping revoke block, sequence %u, at "
-			"block %u:\n", transaction, blocknr);
+			"block %llu:\n", transaction, blocknr);
 
-	if (be32_to_cpu(jsb->s_feature_incompat) & JFS_FEATURE_INCOMPAT_64BIT)
+	if (JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_64BIT))
 		tag_size = sizeof(__u64);
 
 	header = (journal_revoke_header_t *) buf;
@@ -591,7 +601,7 @@ static void dump_revoke_block(FILE *out_file, char *buf,
 			if (dump_all)
 				fprintf(out_file, "\n");
 			else
-				fprintf(out_file," at block %u, sequence %u\n",
+				fprintf(out_file," at block %llu, sequence %u\n",
 					blocknr, transaction);
 		}
 		offset += tag_size;
@@ -617,7 +627,7 @@ static void show_indirect(FILE *out_file, const char *name, __u32 where)
 static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 				journal_superblock_t *jsb EXT2FS_ATTR((unused)),
 				unsigned int log_blocknr,
-				unsigned int fs_blocknr,
+				blk64_t fs_blocknr,
 				unsigned int log_tag_flags,
 				int blocksize,
 				tid_t transaction)
@@ -631,7 +641,7 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 	      || (fs_blocknr == bitmap_to_dump)))
 		return;
 
-	fprintf(out_file, "  FS block %u logged at ", fs_blocknr);
+	fprintf(out_file, "  FS block %llu logged at ", fs_blocknr);
 	if (!dump_all)
 		fprintf(out_file, "sequence %u, ", transaction);
 	fprintf(out_file, "journal block %u (flags 0x%x)\n", log_blocknr,

--------------2.18.0--
