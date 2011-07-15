From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH v2 2/2] ext4: Ignore a stripe width of 1
Date: Fri, 15 Jul 2011 14:41:55 -0700
Message-ID: <1310766115-4164-2-git-send-email-dehrenberg@google.com>
References: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
Cc: Dan Ehrenberg <dehrenberg@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:34309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab1GOVm0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jul 2011 17:42:26 -0400
In-Reply-To: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the stripe width was set to 1, then this patch will ignore
that stripe width and ext4 will act as if the stripe width
were 0 with respect to optimizing allocations.

Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
---
 fs/ext4/super.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..0a3745b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2383,17 +2383,27 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
 	unsigned long stride = le16_to_cpu(sbi->s_es->s_raid_stride);
 	unsigned long stripe_width =
 			le32_to_cpu(sbi->s_es->s_raid_stripe_width);
+	int ret;
 
 	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
-		return sbi->s_stripe;
+		ret = sbi->s_stripe;
 
-	if (stripe_width <= sbi->s_blocks_per_group)
-		return stripe_width;
+	else if (stripe_width <= sbi->s_blocks_per_group)
+		ret = stripe_width;
 
-	if (stride <= sbi->s_blocks_per_group)
-		return stride;
+	else if (stride <= sbi->s_blocks_per_group)
+		ret = stride;
+	else
+		ret = 0;
 
-	return 0;
+	/*
+	 * If the stripe width is 1, this makes no sense and
+	 * we set it to 0 to turn off stripe handling code.
+	 */
+	if (ret <= 1)
+		ret = 0;
+
+	return ret;
 }
 
 /* sysfs supprt */
-- 
1.7.3.1

