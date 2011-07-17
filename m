From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Remove unnecessary ext4_get_group_info in ext4_mb_load_buddy.
Date: Sun, 17 Jul 2011 23:11:21 +0800
Message-ID: <1310915483-2906-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44644 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752755Ab1GQPNb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 11:13:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

ext4_mb_load_buddy() calls ext4_get_group_info() for setting both
"grp" and "e4b->bd_info", but it could do "e4b->bd_info = grp".

Reported-by:  Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4e7d055..e7749b7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1125,7 +1125,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	grp = ext4_get_group_info(sb, group);
 
 	e4b->bd_blkbits = sb->s_blocksize_bits;
-	e4b->bd_info = ext4_get_group_info(sb, group);
+	e4b->bd_info = grp;
 	e4b->bd_sb = sb;
 	e4b->bd_group = group;
 	e4b->bd_buddy_page = NULL;
-- 
1.7.4

