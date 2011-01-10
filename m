From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix trimming starting with block 0 with small blocksize
Date: Mon, 10 Jan 2011 19:00:33 +0100
Message-ID: <1294682433-6775-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Lukas Czerner <lczerner@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1AJSA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 13:00:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When s_first_data_block is not zero (which happens e.g. when block size is 1KB)
and trim ioctl is called to start trimming from block 0, the math in
ext4_get_group_no_and_offset() overflows. The overall result is that ioctl
returns EINVAL which is kind of unexpected and we probably don't want
userspace tools to bother with internal details of filesystem structure.
So just silently increase starting offset (and shorten length) when starting
block is below s_first_data_block.

CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4c4766c..b9c2aad 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4819,6 +4819,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
 	uint64_t start, len, minlen, trimmed;
+	ext4_fsblk_t first_data_blk =
+			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -4828,6 +4830,10 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
+	if (start < first_data_blk) {
+		len -= first_data_blk - start;
+		start = first_data_blk;
+	}
 
 	/* Determine first and last group to examine based on start and len */
 	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) start,
-- 
1.7.1

