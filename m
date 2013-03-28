From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: register extent status shrinker before init percpu counter
Date: Thu, 28 Mar 2013 22:03:59 +0800
Message-ID: <1364479439-20277-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34078 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3C1NsV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 09:48:21 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz17so2339509pbc.17
        for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2013 06:48:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After applied this commit (621bcca5), when we get an error we will
unregsiter extent status shrinker.  We might run out of memory when we
initialize percpu counters.  If so, we will go to 'failed_mount3', and
unregister extent status shinker.  At that time extent status shrinker
has not yet been registered.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
Hi Ted,

Please fold this patch into the commit (621bcca5).

Thanks,
						- Zheng

 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e3e6a06..febbe0e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3701,6 +3701,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_err_report.function = print_daily_error_info;
 	sbi->s_err_report.data = (unsigned long) sb;
 
+	/* Register extent status tree shrinker */
+	ext4_es_register_shrinker(sb);
+
 	err = percpu_counter_init(&sbi->s_freeclusters_counter,
 			ext4_count_free_clusters(sb));
 	if (!err) {
@@ -3726,9 +3729,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_max_writeback_mb_bump = 128;
 	sbi->s_extent_max_zeroout_kb = 32;
 
-	/* Register extent status tree shrinker */
-	ext4_es_register_shrinker(sb);
