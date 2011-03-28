From: Tao Ma <tm@tao.ma>
Subject: [PATCH v2] ext4: Remove redundant check for first_not_zeroed in ext4_register_li_request.
Date: Mon, 28 Mar 2011 22:05:53 +0800
Message-ID: <1301321153-3171-1-git-send-email-tm@tao.ma>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36213 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754329Ab1C1OGJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 10:06:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

We have checked first_not_zeroed == ngroups already above,
so remove this redundant check.

sbi->s_li_request = NULL above is also removed since
it is NULL already.

Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/super.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2d1378f..c5a48dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2948,15 +2948,8 @@ static int ext4_register_li_request(struct super_block *sb,
 
 	if (first_not_zeroed == ngroups ||
 	    (sb->s_flags & MS_RDONLY) ||
-	    !test_opt(sb, INIT_INODE_TABLE)) {
-		sbi->s_li_request = NULL;
+	    !test_opt(sb, INIT_INODE_TABLE))
 		return 0;
-	}
