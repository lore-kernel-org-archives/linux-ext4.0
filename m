From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH] ext4: fix incorrect quotaoff if the quota feature is enabled
Date: Tue, 22 Aug 2017 14:41:37 +0800
Message-ID: <1503384097-19206-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <yi.zhang@huawei.com>,
        <miaoxie@huawei.com>, <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4976 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752736AbdHVGg5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Aug 2017 02:36:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current ext4 quota should always "usage enabled" if the
quota feautre is enabled. But in ext4_orphan_cleanup(), it
turn quota off directly (used for the older quota), so
we cannot turn it on again via "quotaon" unless umount and
remount ext4.

Simple reproduce:

  mkfs.ext4 -O project,quota /dev/vdb1
  mount -o prjquota /dev/vdb1 /mnt
  chattr -p 123 /mnt
  chattr +P /mnt
  touch /mnt/aa /mnt/bb
  exec 100<>/mnt/aa
  rm -f /mnt/aa
  sync
  echo c > /proc/sysrq-trigger

  #reboot and mount
  mount -o prjquota /dev/vdb1 /mnt
  #query status
  quotaon -Ppv /dev/vdb1
  #output
  quotaon: Cannot find mountpoint for device /dev/vdb1
  quotaon: No correct mountpoint specified.

This patch avoid incorrect quotaoff when ext4 has quota
feautre. We also take care about the "quota on" part in
ext4_orphan_cleanup(), it is used for journalled quota
and not invoked if quota feature is enabled, so it's not
affected.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d61a70e2..c1b23b1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2510,10 +2510,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
 		       PLURAL(nr_truncates));
 #ifdef CONFIG_QUOTA
-	/* Turn quotas off */
-	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
-		if (sb_dqopt(sb)->files[i])
-			dquot_quota_off(sb, i);
+	if (!ext4_has_feature_quota(sb)) {
+		/* Turn quotas off */
+		for (i = 0; i < EXT4_MAXQUOTAS; i++) {
+			if (sb_dqopt(sb)->files[i])
+				dquot_quota_off(sb, i);
+		}
 	}
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
-- 
2.5.0
