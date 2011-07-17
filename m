From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Don't increase s_mb_buddies_generated in ext4_mb_release.
Date: Sun, 17 Jul 2011 23:11:22 +0800
Message-ID: <1310915483-2906-2-git-send-email-tm@tao.ma>
References: <1310915483-2906-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41915 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755027Ab1GQPNd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 11:13:33 -0400
In-Reply-To: <1310915483-2906-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In ext4_mb_release, we use s_mb_buddies_generated++. Although
the output is OK, but I don't think we need this extra ++.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e7749b7..f56a592 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2568,7 +2568,7 @@ int ext4_mb_release(struct super_block *sb)
 				atomic_read(&sbi->s_mb_lost_chunks));
 		printk(KERN_INFO
 		       "EXT4-fs: mballoc: %lu generated and it took %Lu\n",
-				sbi->s_mb_buddies_generated++,
+				sbi->s_mb_buddies_generated,
 				sbi->s_mb_generation_time);
 		printk(KERN_INFO
 		       "EXT4-fs: mballoc: %u preallocated, %u discarded\n",
-- 
1.7.4

