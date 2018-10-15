Return-Path: <SRS0=/GAa=M3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37484 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeJPE7a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2018 00:59:30 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH e2fsprogs 2/9] e2fsprogs: Reserve feature bit and SB field bit for filename encoding
Date: Mon, 15 Oct 2018 17:12:13 -0400
Message-Id: <20181015211220.27370-3-krisman@collabora.co.uk>
In-Reply-To: <20181015211220.27370-1-krisman@collabora.co.uk>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The s_encoding field in the superblock stores a magic number indicating
the encoding format and version used globally by file and directory
names in the filesystem.

The s_encoding_flags defines policies for using the charset encoding,
like how to handle invalid sequences and what kind of normalization to
use.

A feature flag is also allocated to indicate whether this filesystem has
encoding awareness enabled.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 lib/e2p/feature.c    | 2 ++
 lib/ext2fs/ext2_fs.h | 6 +++++-
 lib/ext2fs/ext2fs.h  | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index e3b0dab83c81..294a56a40b52 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -109,6 +109,8 @@ static struct feature feature_list[] = {
 			"inline_data"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT,
 			"encrypt"},
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FNAME_ENCODING,
+			"encoding"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index ab2595486d21..f1c405b76339 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -755,7 +755,9 @@ struct ext2_super_block {
 	__u8	s_first_error_time_hi;
 	__u8	s_last_error_time_hi;
 	__u8	s_pad[2];
-	__le32	s_reserved[96];		/* Padding to the end of the block */
+/*27c*/ __le16	s_encoding;		/* Filename charset encoding */
+	__le16	s_encoding_flags;	/* Filename charset encoding flags */
+	__le32	s_reserved[95];		/* Padding to the end of the block */
 /*3fc*/	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -846,6 +848,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_FNAME_ENCODING	0x20000
 
 #define EXT4_FEATURE_COMPAT_FUNCS(name, ver, flagname) \
 static inline int ext2fs_has_feature_##name(struct ext2_super_block *sb) \
@@ -939,6 +942,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		4, CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		4, LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	4, INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
+EXT4_FEATURE_INCOMPAT_FUNCS(fname_encoding,	4, FNAME_ENCODING)
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 185be5df511f..64c5b8758a40 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -616,6 +616,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_64BIT|\
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT|\
+					 EXT4_FEATURE_INCOMPAT_FNAME_ENCODING|\
 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED|\
 					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
 
-- 
2.19.1
