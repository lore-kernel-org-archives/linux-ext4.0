From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2 9/9] ext4: Fix lockdep recursive locking warning
Date: Mon,  3 Nov 2008 23:06:09 +0530
Message-ID: <1225733769-23734-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52881 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYKCRgs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 12:36:48 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA3HZO6F019013
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:35:24 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA3HakiZ283244
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:46 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA3Haj29014094
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:46 +1100
In-Reply-To: <1225733769-23734-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Indicate that the group locks can be taken in loop.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c169256..5a5f9e1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2418,6 +2418,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 #define ext4_mb_history_init(sb)
 #endif
 
+static struct lock_class_key alloc_sem_key[NR_BG_LOCKS];
 
 /* Create and initialize ext4_group_info data for the given group. */
 int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
@@ -2478,7 +2479,9 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
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

