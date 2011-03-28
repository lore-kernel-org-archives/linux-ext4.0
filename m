From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Remove redundant check for first_not_zeroed in ext4_register_li_request.
Date: Mon, 28 Mar 2011 15:50:22 +0800
Message-ID: <1301298622-4014-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:43208 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752860Ab1C1Hui (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 03:50:38 -0400
Received: from [114.251.86.0] (helo=taoma-linux.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Q47Dg-0005Uf-4X
	for linux-ext4@vger.kernel.org; Mon, 28 Mar 2011 01:50:36 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

We have checked first_not_zeroed == ngroups already above,
so remove this redundant check.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2d1378f..37448a7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2953,11 +2953,6 @@ static int ext4_register_li_request(struct super_block *sb,
 		return 0;
 	}
 
-	if (first_not_zeroed == ngroups) {
-		sbi->s_li_request = NULL;
-		return 0;
-	}
