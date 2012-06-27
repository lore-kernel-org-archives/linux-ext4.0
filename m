From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] ext2: cleanup the confused goto label
Date: Thu, 28 Jun 2012 00:49:44 +0800
Message-ID: <1340815784-6028-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <20120627162955.GD5387@quack.suse.cz>
Cc: linux-ext4@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab2F0QuH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 12:50:07 -0400
In-Reply-To: <20120627162955.GD5387@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cleanup the confused goto label, since the big lock has been removed.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/ext2/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b3621cb..c8e4979 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -771,13 +771,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		goto failed_unlock;
+		goto failed;
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		goto failed_unlock;
+		goto failed;
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
@@ -1130,7 +1130,7 @@ failed_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-failed_unlock:
+failed:
 	return ret;
 }
 
-- 
1.7.11.rc0

