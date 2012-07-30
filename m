From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/7] libext2fs: enforce the block group descriptor size in ext2fs_open()
Date: Mon, 30 Jul 2012 17:47:42 -0400
Message-ID: <1343684862-13181-7-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42155 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab2G3Vzw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:55:52 -0400
In-Reply-To: <1343684862-13181-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since various parts of the library depend on the value of s_desc_size,
check to make sure it is the correct, expected value based on the file
system features.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2_err.et.in |  3 +++
 lib/ext2fs/openfs.c       | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index ccf1894..5987185 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -443,4 +443,7 @@ ec	EXT2_ET_MMP_CHANGE_ABORT,
 ec	EXT2_ET_MMP_OPEN_DIRECT,
 	"MMP: open with O_DIRECT failed"
 
+ec	EXT2_ET_BAD_DESC_SIZE,
+	"Block group descriptor size incorrect"
+
 	end
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 482e4ab..fbe9acd 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -263,6 +263,21 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
+
+	/* Enforce the block group descriptor size */
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) {
+		if (fs->super->s_desc_size != EXT2_MIN_DESC_SIZE_64BIT) {
+			retval = EXT2_ET_BAD_DESC_SIZE;
+			goto cleanup;
+		}
+	} else {
+		if (fs->super->s_desc_size &&
+		    fs->super->s_desc_size != EXT2_MIN_DESC_SIZE) {
+			retval = EXT2_ET_BAD_DESC_SIZE;
+			goto cleanup;
+		}
+	}
+
 	fs->cluster_ratio_bits = fs->super->s_log_cluster_size -
 		fs->super->s_log_block_size;
 	if (EXT2_BLOCKS_PER_GROUP(fs->super) !=
-- 
1.7.12.rc0.22.gcdd159b

