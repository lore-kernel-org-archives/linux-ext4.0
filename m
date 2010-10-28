From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: do not get s_umount sem on ext4_quota_off
Date: Thu, 28 Oct 2010 12:47:19 +0400
Message-ID: <87tyk6ln54.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40175 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0J1Ir3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Oct 2010 04:47:29 -0400
Received: by eye27 with SMTP id 27so1330439eye.19
        for <linux-ext4@vger.kernel.org>; Thu, 28 Oct 2010 01:47:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


It must be already acquired by caller. Fix lock_dep complain.

Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e59eb37..062d1bc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4107,12 +4107,10 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 
 static int ext4_quota_off(struct super_block *sb, int type)
 {
-	/* Force all delayed allocation blocks to be allocated */
-	if (test_opt(sb, DELALLOC)) {
-		down_read(&sb->s_umount);
+	/* Force all delayed allocation blocks to be allocated.
+	 * Caller already holds s_umount sem */
+	if (test_opt(sb, DELALLOC))
 		sync_filesystem(sb);
-		up_read(&sb->s_umount);
-	}
 
 	return dquot_quota_off(sb, type);
 }
