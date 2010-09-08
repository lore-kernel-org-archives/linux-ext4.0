From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/5] Add helper function for blkdev_issue_zeroout
Date: Wed,  8 Sep 2010 18:59:16 +0200
Message-ID: <1283965160-31597-2-git-send-email-lczerner@redhat.com>
References: <1283965160-31597-1-git-send-email-lczerner@redhat.com>
Cc: rwheeler@redhat.com, sandeen@redhat.com, tytso@mit.edu,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0IHQ7g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Sep 2010 12:59:36 -0400
In-Reply-To: <1283965160-31597-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is done the same way as function sb_issue_discard for
blkdev_issue_discard.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 include/linux/blkdev.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..a22939d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1023,6 +1023,14 @@ static inline int sb_issue_discard(struct super_block *sb,
 	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
 				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
+static inline int sb_issue_zeroout(struct super_block *sb,
+				   sector_t block, sector_t nr_blocks)
+{
+	block <<= (sb->s_blocksize_bits - 9);
+	nr_blocks <<= (sb->s_blocksize_bits - 9);
+	return blkdev_issue_zeroout(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
+				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+}
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
 
-- 
1.7.2.2

