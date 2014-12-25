From: Jakub Wilk <jwilk@jwilk.net>
Subject: [PATCH] ext4: remove spurious KERN_INFO from ext4_warning call
Date: Thu, 25 Dec 2014 19:43:14 +0100
Message-ID: <1419532994-5988-1-git-send-email-jwilk@jwilk.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 7.mo69.mail-out.ovh.net ([46.105.50.32]:33626 "EHLO
	7.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaLYTSk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Dec 2014 14:18:40 -0500
Received: from mail417.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo69.mail-out.ovh.net (Postfix) with SMTP id 40144FFB280
	for <linux-ext4@vger.kernel.org>; Thu, 25 Dec 2014 19:43:21 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jakub Wilk <jwilk@jwilk.net>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43c92b1..74c5f53 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3482,7 +3482,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 	    EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		ext4_warning(sb, KERN_INFO "metadata_csum and uninit_bg are "
+		ext4_warning(sb, "metadata_csum and uninit_bg are "
 			     "redundant flags; please run fsck.");
 
 	/* Check for a known checksum algorithm */
-- 
2.1.4

