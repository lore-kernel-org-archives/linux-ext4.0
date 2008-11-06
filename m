From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V3 9/9] ext4: Fix lockdep recursive locking warning
Date: Fri,  7 Nov 2008 00:19:34 +0530
Message-ID: <1225997374-10846-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:35726 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYKFS5x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 13:57:53 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6IvTQ64964484
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:57:29 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6IoFgA117754
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:50:15 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6IoEXQ022902
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:50:15 +1100
In-Reply-To: <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Indicate that the group locks can be taken in loop.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f58de20..34b9b7c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2413,6 +2413,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 #define ext4_mb_history_init(sb)
 #endif
 
+static struct lock_class_key alloc_sem_key[NR_BG_LOCKS];
 
 /* Create and initialize ext4_group_info data for the given group. */
 int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
@@ -2473,7 +2474,9 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	}
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
-	init_rwsem(&meta_group_info[i]->alloc_sem);
+	__init_rwsem(&meta_group_info[i]->alloc_sem,
+			"&meta_group_info[i]->alloc_sem",
+			&alloc_sem_key[i]);
 	meta_group_info[i]->bb_free_root.rb_node = NULL;;
 
 #ifdef DOUBLE_CHECK
-- 
1.6.0.3.514.g2f91b

