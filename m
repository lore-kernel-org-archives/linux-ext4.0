From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] misc: fix gcc -Wall nits
Date: Mon, 20 May 2013 09:59:03 -0400
Message-ID: <1369058343-1988-3-git-send-email-tytso@mit.edu>
References: <1369058343-1988-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49963 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab3ETN7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 09:59:09 -0400
In-Reply-To: <1369058343-1988-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[For 1.43 branch]

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/dumpe2fs.c |  2 +-
 misc/tune2fs.c  | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index e18843e..5369ffb 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -324,7 +324,7 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
 	ext2fs_badblocks_list_free(bb_list);
 }
 
-static char *journal_checksum_type_str(__u8 type)
+static const char *journal_checksum_type_str(__u8 type)
 {
 	switch (type) {
 	case JBD2_CRC32C_CHKSUM:
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4f8cedc..7d6520e 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -448,7 +448,7 @@ struct rewrite_dir_context {
 
 static int rewrite_dir_block(ext2_filsys fs,
 			     blk64_t	*blocknr,
-			     e2_blkcnt_t blockcnt,
+			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
 			     blk64_t	ref_block EXT2FS_ATTR((unused)),
 			     int	ref_offset EXT2FS_ATTR((unused)),
 			     void	*priv_data)
@@ -510,7 +510,7 @@ static int rewrite_dir_block(ext2_filsys fs,
 				ctx->errcode = EXT2_ET_DIR_CORRUPTED;
 			if (ctx->errcode)
 				return BLOCK_ABORT;
-			de = (struct ext2_dir_entry *)(((void *)de) + rec_len);
+			de = (struct ext2_dir_entry *)(((char *)de) + rec_len);
 		}
 		ctx->errcode = ext2fs_get_rec_len(fs, last_de, &rec_len);
 		if (ctx->errcode)
@@ -540,7 +540,7 @@ static int rewrite_dir_block(ext2_filsys fs,
 					penultimate_de);
 			changed = 1;
 		} else {
-			int csum_size = sizeof(struct ext2_dir_entry_tail);
+			unsigned csum_size = sizeof(struct ext2_dir_entry_tail);
 			struct ext2_dir_entry_tail *t;
 
 			/*
@@ -584,8 +584,8 @@ out:
 	return 0;
 }
 
-errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
-			    struct ext2_inode *inode)
+static errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
+				   struct ext2_inode *inode)
 {
 	errcode_t	retval;
 	struct rewrite_dir_context ctx;
-- 
1.7.12.rc0.22.gcdd159b

