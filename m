From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2] ext3: Update ctime in ext3_splice_branch() only when needed
Date: Wed, 08 Feb 2012 16:34:29 +0900
Message-ID: <4F322585.3010407@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63040 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2BHHhO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Feb 2012 02:37:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext3 updates ctime in ext3_splice_branch() which is called whenever
we allocate one block. But it is wasteful because ext3 doesn't support
nanosecond timestamp. This leads to a performance loss.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext3/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2d0afec..3c7fd63 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -756,6 +756,7 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 	struct ext3_block_alloc_info *block_i;
 	ext3_fsblk_t current_block;
 	struct ext3_inode_info *ei = EXT3_I(inode);
+	struct timespec now;
 
 	block_i = ei->i_block_alloc_info;
 	/*
@@ -795,9 +796,11 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 	}
 
 	/* We are done with atomic stuff, now do the rest of housekeeping */
