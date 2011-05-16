From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Don't warn about mnt_count after the first mount of a new mkfsed volume.
Date: Mon, 16 May 2011 22:53:23 +0800
Message-ID: <1305557603-4596-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60070 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755619Ab1EPOxn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 10:53:43 -0400
Received: from [221.217.35.127] (helo=taoma-laptop2.localdomain6)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1QLzAy-0004Hq-J5
	for linux-ext4@vger.kernel.org; Mon, 16 May 2011 08:53:42 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Currently, if we mkfs a new ext4 volume and mount it for the first time,
we will get the warning in the message like
warning: maximal mount count reached, running e2fsck is recommended

It is really misleading. So change the check so that it wouldn't warn in that case.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e29535c..92166b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1900,7 +1900,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 		ext4_msg(sb, KERN_WARNING,
 			 "warning: mounting fs with errors, "
 			 "running e2fsck is recommended");
-	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
+	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) > 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
 		ext4_msg(sb, KERN_WARNING,
-- 
1.7.4

