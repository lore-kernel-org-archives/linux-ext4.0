From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: do not reference pa_inode from group_pa
Date: Sun, 18 Dec 2011 11:49:06 +0800
Message-ID: <1324180146-10036-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1LRHPc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 02:15:32 -0500
Received: by iaeh11 with SMTP id h11so6745247iae.19
        for <linux-ext4@vger.kernel.org>; Sat, 17 Dec 2011 23:15:32 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

pa_inode in group_pa is set NULL in ext4_mb_new_group_pa, so
pa_inode should be not referenced.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c           |    2 +-
 include/trace/events/ext4.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2268edf..d04ca8d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3695,7 +3695,7 @@ ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 
-	trace_ext4_mb_release_group_pa(pa);
+	trace_ext4_mb_release_group_pa(sb, pa);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 748ff7c..319538b 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -573,9 +573,9 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 );
 
 TRACE_EVENT(ext4_mb_release_group_pa,
-	TP_PROTO(struct ext4_prealloc_space *pa),
+	TP_PROTO(struct super_block *sb, struct ext4_prealloc_space *pa),
 
-	TP_ARGS(pa),
+	TP_ARGS(sb, pa),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -585,7 +585,7 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= pa->pa_inode->i_sb->s_dev;
+		__entry->dev		= sb->s_dev;
 		__entry->pa_pstart	= pa->pa_pstart;
 		__entry->pa_len		= pa->pa_len;
 	),
-- 
1.7.5.1

