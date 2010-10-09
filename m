From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ext4: do not get s_umount sem on ext4_quota_off
Date: Sat, 09 Oct 2010 19:28:39 +0400
Message-ID: <87k4lro060.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:13399 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0JIP2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Oct 2010 11:28:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It must be already acquired by caller. Fix lock_dep complain.

Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>

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
