From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Initialize list properly
Date: Thu, 12 Feb 2009 12:35:31 +0530
Message-ID: <1234422331-32766-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <a4423d670902100906q36e7f36fo53ba2060f5644303@mail.gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-next@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48715 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZBLHFh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 02:05:37 -0500
In-Reply-To: <a4423d670902100906q36e7f36fo53ba2060f5644303@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to initialize the list_head properly before we add
them to the any list. Otherwise with list debug on we get
list corruption warnings.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/mballoc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index deba54f..0e9155a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3693,6 +3693,8 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	pa->pa_free = pa->pa_len;
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
+	INIT_LIST_HEAD(&pa->pa_inode_list);
+	INIT_LIST_HEAD(&pa->pa_group_list);
 	pa->pa_deleted = 0;
 	pa->pa_linear = 0;
 
@@ -3755,6 +3757,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	atomic_set(&pa->pa_count, 1);
 	spin_lock_init(&pa->pa_lock);
 	INIT_LIST_HEAD(&pa->pa_inode_list);
+	INIT_LIST_HEAD(&pa->pa_group_list);
 	pa->pa_deleted = 0;
 	pa->pa_linear = 1;
 
-- 
tg: (b578f3f..) fix_list_corruption (depends on: master)
