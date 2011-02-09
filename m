From: "Amir G." <amir73il@users.sourceforge.net>
Subject: [PATCH][RFC] ext4: avoid taking down_read(&grp->alloc_sem)
Date: Wed, 9 Feb 2011 12:05:11 +0200
Message-ID: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54739 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1BIKFL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 05:05:11 -0500
Received: by qwa26 with SMTP id 26so4889835qwa.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Feb 2011 02:05:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh,

As you are signed off on most of the recent alloc_sem related code changes,
can you please comment on the patch below, which tries to avoid taking
the read lock most of the times on a 4K block fs.

Can anyone tell what performance impact (if any) will be caused by avoiding
the read lock on most allocations? group spin lock will still be taken, but for
much shorter periods of time (cycles).

Any ideas how this patch can be properly tested?

Thanks,
Amir.

grp->alloc_sem is used to synchronize buddy cache users with buddy cache init
of other groups that use the same buddy cache page and with adding blocks to
group on online resize.

When blocks_per_page <= 2, each group has it's own private buddy cache page
so taking the read lock for every allocation is futile and can be avoided for
every group, but the last one.

The write lock is taken in ext4_mb_init_group() and in ext4_add_groupblocks()
to synchronize the buddy cache init of a group on first time allocation after
mount and after extending the last group.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/mballoc.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1b3256b..22a5251 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1160,7 +1160,15 @@ ext4_mb_load_buddy(struct super_block *sb,
ext4_group_t group,
 	e4b->bd_group = group;
 	e4b->bd_buddy_page = NULL;
 	e4b->bd_bitmap_page = NULL;
-	e4b->alloc_semp = &grp->alloc_sem;
+	/*
+	 * We only need to take the read lock if other groups share the buddy
+	 * page with this group or if blocks may be added to this (last) group
+	 * by ext4_group_extend().
+	 */
+	if (blocks_per_page > 2 || group == sbi->s_groups_count - 1)
+		e4b->alloc_semp = &grp->alloc_sem;
+	else
+		e4b->alloc_semp = NULL;

 	/* Take the read lock on the group alloc
 	 * sem. This would make sure a parallel
@@ -1169,7 +1177,8 @@ ext4_mb_load_buddy(struct super_block *sb,
ext4_group_t group,
 	 * till we are done with allocation
 	 */
 repeat_load_buddy:
-	down_read(e4b->alloc_semp);
+	if (e4b->alloc_semp)
+		down_read(e4b->alloc_semp);

 	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
 		/* we need to check for group need init flag
@@ -1177,7 +1186,8 @@ repeat_load_buddy:
 		 * that new blocks didn't get added to the group
 		 * when we are loading the buddy cache
 		 */
-		up_read(e4b->alloc_semp);
+		if (e4b->alloc_semp)
+			up_read(e4b->alloc_semp);
 		/*
 		 * we need full data about the group
 		 * to make a good selection
@@ -1277,7 +1287,8 @@ err:
 	e4b->bd_bitmap = NULL;

 	/* Done with the buddy cache */
-	up_read(e4b->alloc_semp);
+	if (e4b->alloc_semp)
+		up_read(e4b->alloc_semp);
 	return ret;
 }

-- 
1.7.0.4
