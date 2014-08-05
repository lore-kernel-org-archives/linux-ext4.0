From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/21] e2fsck: don't try to iterate blocks of an inline_data
 inode when deallocating it
Date: Mon, 04 Aug 2014 18:06:22 -0700
Message-ID: <20140805010622.2611.77018.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44379 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaHEBG3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:06:29 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inodes with inline_data set do not have iterable blocks, so don't try
to iterate the blocks, because that will just fail, causing e2fsck to
abort.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 38bf37a..d56b4c8 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1441,6 +1441,10 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 		goto clear_inode;
 
+	/* Inline data inodes don't have blocks to iterate */
+	if (inode.i_flags & EXT4_INLINE_DATA_FL)
+		goto clear_inode;
+
 	if (LINUX_S_ISREG(inode.i_mode) &&
 	    ext2fs_needs_large_file_feature(EXT2_I_SIZE(&inode)))
 		ctx->large_files--;

