From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
Date: Tue, 22 Jul 2008 18:47:45 +0530
Message-ID: <1216732665-26924-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46609 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYGVNRw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 09:17:52 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6MDHCDQ000501
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 23:17:12 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6MDHonX088858
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 23:17:50 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6MDHnLi000324
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 23:17:49 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

NR_CPUS can be really large. We should be using nr_cpu_ids
instead.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9db0f4d..5b854b7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2541,7 +2541,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
 	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
 
-	i = sizeof(struct ext4_locality_group) * NR_CPUS;
+	i = sizeof(struct ext4_locality_group) * nr_cpu_ids;
 	sbi->s_locality_groups = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_locality_groups == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
@@ -2549,7 +2549,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 		kfree(sbi->s_mb_maxs);
 		return -ENOMEM;
 	}
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		struct ext4_locality_group *lg;
 		lg = &sbi->s_locality_groups[i];
 		mutex_init(&lg->lg_mutex);
-- 
1.5.6.3.439.g1e10.dirty

