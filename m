From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: fix possible overflow in ext4_trim_fs()
Date: Tue,  6 Sep 2011 08:42:04 +0200
Message-ID: <1315291324-6864-1-git-send-email-lczerner@redhat.com>
Cc: tm@tao.ma, tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1IFGmL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 02:42:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The overflow can happen when we are calling get_group_no_and_offset()
which stores the result of do_div() in 32 bit long type. However the
result might be bigger than that if big blocknr is passed in. This will
most likely happen when calling FITRIM with the default argument len =
ULLONG_MAX.

Fix it by decrementing the len so that start+len equals to the file system
size in the worst case.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2 - Change commit description to better describe the problem

 fs/ext4/mballoc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..d86dc14 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4952,14 +4952,18 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	uint64_t start, len, minlen, trimmed = 0;
 	ext4_fsblk_t first_data_blk =
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
+	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
 	len = range->len >> sb->s_blocksize_bits;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 
-	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
+	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)) ||
+	    unlikely(start > max_blks))
 		return -EINVAL;
+	if (unlikely(len > max_blks))
+		len = max_blks - start;
 	if (start + len <= first_data_blk)
 		goto out;
 	if (start < first_data_blk) {
-- 
1.7.4.4

