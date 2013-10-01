From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/31] libext2fs: Allow callers to punch a single block
Date: Mon, 30 Sep 2013 18:27:46 -0700
Message-ID: <20131001012746.28415.15964.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22496 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3JAB1v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:51 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The range of blocks to punch is treated as an inclusive range on both ends,
i.e. if start=1 and end=2, both blocks 1 and 2 are punched out.  Thus, start ==
end means that the caller wishes to punch a single block.  Remove the check
that prevents us from punching a single block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h |    4 ++++
 lib/ext2fs/punch.c  |    5 +----
 2 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 311ceda..c37e00b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1385,6 +1385,10 @@ extern errcode_t ext2fs_check_mount_point(const char *device, int *mount_flags,
 					  char *mtpt, int mtlen);
 
 /* punch.c */
+/*
+ * NOTE: This function removes from an inode the blocks "start", "end", and
+ * every block in between.
+ */
 extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 			      struct ext2_inode *inode,
 			      char *block_buf, blk64_t start,
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 11c7668..aac1942 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -315,9 +315,6 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 	if (start > end)
 		return EINVAL;
 
-	if (start == end)
-		return 0;
