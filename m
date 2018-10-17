Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50182 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeJREyJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 00:54:09 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 19/23] ext4: Reserve superblock fields for encoding information
Date: Wed, 17 Oct 2018 16:55:20 -0400
Message-Id: <20181017205524.23360-20-krisman@collabora.co.uk>
In-Reply-To: <20181017205524.23360-1-krisman@collabora.co.uk>
References: <20181017205524.23360-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The s_encoding field stores a magic number indicating the encoding
format and version used globally by file and directory names in the
filesystem.

The s_encoding_flags defines policies for using the charset encoding,
like how to handle invalid sequences and what kind of normalization to
use.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/ext4.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 12f90d48ba61..358ccf06fade 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1320,7 +1320,9 @@ struct ext4_super_block {
 	__u8	s_first_error_time_hi;
 	__u8	s_last_error_time_hi;
 	__u8	s_pad[2];
-	__le32	s_reserved[96];		/* Padding to the end of the block */
+	__le16  s_encoding;		/* Filename charset encoding */
+	__le16  s_encoding_flags;	/* Filename charset encoding flags */
+	__le32	s_reserved[95];		/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1670,6 +1672,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_FNAME_ENCODING	0x20000
 
 #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline bool ext4_has_feature_##name(struct super_block *sb) \
@@ -1758,6 +1761,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
+EXT4_FEATURE_INCOMPAT_FUNCS(fname_encoding,	FNAME_ENCODING)
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1785,6 +1789,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
 					 EXT4_FEATURE_INCOMPAT_MMP | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
+					 EXT4_FEATURE_INCOMPAT_FNAME_ENCODING | \
 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
 					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
-- 
2.19.1
