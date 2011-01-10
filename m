From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Date: Mon, 10 Jan 2011 12:28:26 +0100
Message-ID: <1294658906-5993-1-git-send-email-lczerner@redhat.com>
References: <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1AJL2b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 06:28:31 -0500
In-Reply-To: <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When determining last group through ext4_get_group_no_and_offset() the
result may be wrong in cases when range->start and range-len are too
big, because it may overflow when summing up those two numbers.

Fix that by checking range->len and limit its value to
ext4_blocks_count(). This commit was tested by myself with expected
result.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b4d4e3..5f3e8a3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4819,6 +4819,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
 	uint64_t start, len, minlen, trimmed;
+	ext4_fsblk_t blocks_count = ext4_blocks_count(EXT4_SB(sb)->s_es);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -4826,6 +4827,11 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	minlen = range->minlen >> sb->s_blocksize_bits;
 	trimmed = 0;
 
+	if (start >= blocks_count)
+		return -EINVAL;
+	if (start + len > blocks_count)
+		len = blocks_count - start;
+
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
 
-- 
1.7.2.3

