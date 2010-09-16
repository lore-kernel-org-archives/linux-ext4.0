From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/6] Add helper function for blkdev_issue_zeroout
Date: Thu, 16 Sep 2010 14:47:26 +0200
Message-ID: <1284641251-24531-2-git-send-email-lczerner@redhat.com>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com, snitzer@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab0IPMrm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 08:47:42 -0400
In-Reply-To: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is done the same way as helper sb_issue_discard for
blkdev_issue_discard.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 include/linux/blkdev.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7ddd6b..e37e82d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -895,6 +895,13 @@ static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 				    nr_blocks << (sb->s_blocksize_bits - 9),
 				    gfp_mask, flags);
 }
+static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
+		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
+{
+	return blkdev_issue_zeroout(sb->s_bdev, block << (sb->s_blocksize_bits - 9),
+				    nr_blocks << (sb->s_blocksize_bits - 9),
+				    gfp_mask, flags);
+}
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
 
-- 
1.7.2.2

