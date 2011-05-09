From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 24/30] ext4: snapshot list support
Date: Mon,  9 May 2011 19:41:42 +0300
Message-ID: <1304959308-11122-25-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1EIQoY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:24 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:24 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Implementation of multiple incremental snapshots.
Snapshot inodes are chained on a list starting at the super block,
both on-disk and in-memory, similar to the orphan inodes.
Unlink and truncate of snapshot inodes on the list is not allowed,
so an inode can never be chained on both orphan and snapshot lists.
We make use of this fact to overload the in-memory inode field
ext4_inode_info.i_orphan for the chaining of snapshots.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 884033f..a7bb8ed 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1207,6 +1207,7 @@ struct ext4_sb_info {
 	struct block_device *journal_bdev;
 	struct mutex s_snapshot_mutex;		/* protects 2 fields below: */
 	struct inode *s_active_snapshot;	/* [ s_snapshot_mutex ] */
+	struct list_head s_snapshot_list;	/* [ s_snapshot_mutex ] */
 #ifdef CONFIG_JBD2_DEBUG
 	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
 	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9f68ed1..461653c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3496,6 +3496,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	mutex_init(&sbi->s_snapshot_mutex);
 	sbi->s_active_snapshot = NULL;
+	INIT_LIST_HEAD(&sbi->s_snapshot_list); /* snapshot files */
 
 	needs_recovery = (es->s_last_orphan != 0 ||
 			  EXT4_HAS_INCOMPAT_FEATURE(sb,
-- 
1.7.0.4

