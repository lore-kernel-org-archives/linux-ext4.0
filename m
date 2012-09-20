From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Don't calc checksum in update_backups in online resize.
Date: Thu, 20 Sep 2012 14:33:43 +0800
Message-ID: <1348122823-4930-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58164 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751011Ab2ITGdz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2012 02:33:55 -0400
Received: from [42.120.72.160] (port=51344 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TEaKg-0005Mi-Fs
	for linux-ext4@vger.kernel.org; Thu, 20 Sep 2012 00:33:55 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

update_backups is used to backup all the metadata blocks, so we should
not take it for granted that 'data' is pointed to a super block and use
ext4_superblock_csum_set to calculate the checksum there. In case
the data is a group descriptor block, it will corrupt the last group
descriptor. And e2fsck will complain it.

As all the metadata checksum should already be OK when we do the backup,
remove the wrong ext4_superblock_csum_set and it should be just fine.

Reported-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/resize.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 41f6ef6..019d528 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -970,8 +970,6 @@ static void update_backups(struct super_block *sb,
 		goto exit_err;
 	}
 
-	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
