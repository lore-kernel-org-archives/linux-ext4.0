From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
Date: Thu, 25 Nov 2010 16:53:45 +0100
Message-ID: <1290700425-4094-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0KYPxw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Nov 2010 10:53:52 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAPFrqtB003821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 10:53:52 -0500
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
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b4d4e3..7b05d92 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4819,6 +4819,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
 	uint64_t start, len, minlen, trimmed;
+	ext4_fsblk_t blocks_count = ext4_blocks_count(EXT4_SB(sb)->s_es);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -4826,6 +4827,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	minlen = range->minlen >> sb->s_blocksize_bits;
 	trimmed = 0;
 
+	if (len > blocks_count)
+		len = blocks_count - start;
+
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
 
-- 
1.7.2.3

