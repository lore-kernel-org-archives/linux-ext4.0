From: Tao Ma <tm@tao.ma>
Subject: [PATCH v2] ext3: Adjust trim start with first_data_block.
Date: Fri, 21 Jan 2011 10:52:56 +0800
Message-ID: <1295578376-3914-1-git-send-email-tm@tao.ma>
References: <20110119113921.GA4246@quack.suse.cz>
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51678 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752057Ab1AUCxY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jan 2011 21:53:24 -0500
In-Reply-To: <20110119113921.GA4246@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

As we have make the consense in the e-mail[1], the trim start should
be added with first_data_block. So this patch fulfill it and remove
the check for start < first_data_block.

[1] http://www.spinics.net/lists/linux-ext4/msg22737.html

Cc: Jan Kara <jack@suse.cz>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/balloc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 971e1bd..13bfebe 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -2091,7 +2091,8 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
 	int ret = 0;
 
-	start = range->start >> sb->s_blocksize_bits;
+	start = (range->start >> sb->s_blocksize_bits) +
+		le32_to_cpu(es->s_first_data_block);
 	len = range->len >> sb->s_blocksize_bits;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 	trimmed = 0;
@@ -2100,10 +2101,6 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		return -EINVAL;
 	if (start >= max_blks)
 		goto out;
-	if (start < le32_to_cpu(es->s_first_data_block)) {
-		len -= le32_to_cpu(es->s_first_data_block) - start;
-		start = le32_to_cpu(es->s_first_data_block);
-	}
 	if (start + len > max_blks)
 		len = max_blks - start;
 
-- 
1.6.3.GIT

