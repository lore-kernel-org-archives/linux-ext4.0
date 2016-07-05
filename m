From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] Ext4: fix project quota accounting without quota limits enabled.
Date: Tue,  5 Jul 2016 15:58:10 +0900
Message-ID: <1467701890-14687-1-git-send-email-wangshilong1991@gmail.com>
Cc: lixi@ddn.com, sihara@ddn.com, tytso@mit.edu, wshilong@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36855 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbcGEH5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jul 2016 03:57:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id i123so18375093pfg.3
        for <linux-ext4@vger.kernel.org>; Tue, 05 Jul 2016 00:57:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

Steps to reproduce:
  #mkfs.ext4 /dev/sda4 -O quota,project
  #mount /dev/sda4 /mnt/test
  #touch /mnt/test/file
  #chattr -p 123 /mnt/test/file
  #quota -v -P 123

Problems is we should always transfer quota accounting whatver
quota limits enabled.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/ioctl.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 28cc412..b5a39b0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -308,6 +308,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	kprojid_t kprojid;
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
+	struct dquot *transfer_to[MAXQUOTAS] = { };
 
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
@@ -361,17 +362,14 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	if (err)
 		goto out_stop;
 
-	if (sb_has_quota_limits_enabled(sb, PRJQUOTA)) {
-		struct dquot *transfer_to[MAXQUOTAS] = { };
