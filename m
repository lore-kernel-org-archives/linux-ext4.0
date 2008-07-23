From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
Date: Wed, 23 Jul 2008 22:40:46 +0530
Message-ID: <1216833047-4959-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1216833047-4959-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1216833047-4959-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:55619 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbYGWRLJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 13:11:09 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6NHB4Q0023907
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:41:04 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6NHB4921765498
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:41:04 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6NHB3co027836
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:41:04 +0530
In-Reply-To: <1216833047-4959-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

