From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: GFP_ usage in kmalloc with mballoc
Date: Thu, 24 Jan 2008 21:26:07 +0530
Message-ID: <20080124155607.GE14348@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Y Tso <theotso@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
	Alex Tomas <bzzz@sun.com>,
	Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53069 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752688AbYAXP4i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 10:56:38 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m0OFuWsE019091
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 21:26:32 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0OFuVEb921842
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 21:26:31 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m0OFuZBQ028354
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 15:56:35 GMT
Received: from skywalker ([9.124.216.131])
	by d28av01.in.ibm.com (8.13.1/8.12.11) with ESMTP id m0OFuWfs028277
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 15:56:34 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,


I looked at the GFP flag usage in mballoc.  I think the below change
make sense with respect to mballoc.

First hunk is memory allocation during ext4_mb_init which is called
during mount time. I guess it is ok to convert that to GFP_KERNEL.

Second hunk is during ext4_mb_free_metadata. I guess it should be
GFP_NOFS. This is called during ext4_free_blocks.


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bec699a..a15f18e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2662,7 +2662,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
 
 	i = sizeof(struct ext4_locality_group) * NR_CPUS;
-	sbi->s_locality_groups = kmalloc(i, GFP_NOFS);
+	sbi->s_locality_groups = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_locality_groups == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
 		kfree(sbi->s_mb_offsets);
@@ -4366,7 +4366,7 @@ static int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 
 		if (md == NULL) {
 			ext4_unlock_group(sb, group);
-			md = kmalloc(sizeof(*md), GFP_KERNEL);
+			md = kmalloc(sizeof(*md), GFP_NOFS);
 			if (md == NULL)
 				return -ENOMEM;
 			md->num = 0;
