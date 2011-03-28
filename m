From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Use s_inodes_per_block directly in __ext4_get_inode_loc.
Date: Mon, 28 Mar 2011 23:41:13 +0800
Message-ID: <1301326873-9551-2-git-send-email-tm@tao.ma>
References: <1301326873-9551-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:40638 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754588Ab1C1Plj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 11:41:39 -0400
Received: from [221.217.31.156] (helo=taoma-laptop2.localdomain6)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Q4EZV-0006CL-3t
	for linux-ext4@vger.kernel.org; Mon, 28 Mar 2011 09:41:38 -0600
In-Reply-To: <1301326873-9551-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In __ext4_get_inode_loc, we calculate inodes_per_block every time
by EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb). AFAICS, this function
is really a hot path for ext4, so we'd better use s_inodes_per_block
directly instead of calculating every time.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1a86282..326efd9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4605,7 +4605,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
-	inodes_per_block = (EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb));
+	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	inode_offset = ((inode->i_ino - 1) %
 			EXT4_INODES_PER_GROUP(sb));
 	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
-- 
1.7.4

