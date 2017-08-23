From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH 1/2] ext4: fix incorrect quotaoff if the quota feature is enabled
Date: Wed, 23 Aug 2017 17:13:57 +0800
Message-ID: <1503479638-16977-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4997 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753616AbdHWJJP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Aug 2017 05:09:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current ext4 quota should always "usage enabled" if the
quota feautre is enabled. But in ext4_orphan_cleanup(), it
turn quotas off directly (used for the older journaled
quota), so we cannot turn it on again via "quotaon" unless
umount and remount ext4.

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

This patch add check for journaled quotas to avoid incorrect
quotaoff when ext4 has quota feautre.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d61a70e2..cade5c8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2442,7 +2442,7 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 #ifdef CONFIG_QUOTA
 	/* Needed for iput() to work correctly and not trash data */
 	sb->s_flags |= MS_ACTIVE;
-	/* Turn on quotas so that they are updated correctly */
+	/* Turn on journaled quotas so that they are updated correctly */
 	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
 		if (EXT4_SB(sb)->s_qf_names[i]) {
 			int ret = ext4_quota_on_mount(sb, i);
@@ -2510,9 +2510,9 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
 		       PLURAL(nr_truncates));
 #ifdef CONFIG_QUOTA
-	/* Turn quotas off */
+	/* Turn off journaled quotas if they were enabled for orphan cleanup */
 	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
-		if (sb_dqopt(sb)->files[i])
+		if (EXT4_SB(sb)->s_qf_names[i] && sb_dqopt(sb)->files[i])
 			dquot_quota_off(sb, i);
 	}
 #endif
-- 
2.5.0
