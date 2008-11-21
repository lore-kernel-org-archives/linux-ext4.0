From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4] ext4: Fix lockdep recursive locking warning
Date: Fri, 21 Nov 2008 22:10:46 +0530
Message-ID: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:52501 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbYKUQl2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 11:41:28 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id mALGf0uo001249
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:11:10 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALGeoHc3838084
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:10:50 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id mALGensU015613
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 03:40:49 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Indicate that the group locks can be taken in loop.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7293209..1fa311c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2413,6 +2413,9 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 #define ext4_mb_history_init(sb)
 #endif
 
+#ifdef CONFIG_LOCKDEP
+static struct lock_class_key alloc_sem_key[NR_BG_LOCKS];
+#endif
 
 /* Create and initialize ext4_group_info data for the given group. */
 int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
@@ -2473,8 +2476,14 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	}
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
-	init_rwsem(&meta_group_info[i]->alloc_sem);
+#ifdef CONFIG_LOCKDEP
+	__init_rwsem(&meta_group_info[i]->alloc_sem,
+			"&meta_group_info[i]->alloc_sem",
+			&alloc_sem_key[i]);
 	meta_group_info[i]->bb_free_root.rb_node = NULL;;
+#else
+	init_rwsem(&meta_group_info[i]->alloc_sem);
+#endif
 
 #ifdef DOUBLE_CHECK
 	{
-- 
1.6.0.4.735.gea4f

