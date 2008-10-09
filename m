From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Do mballoc init before doing filesystem recovery
Date: Thu,  9 Oct 2008 21:02:09 +0530
Message-ID: <1223566329-29434-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223566329-29434-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60976 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYJIPc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 11:32:26 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m99FVkip014442
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 02:31:46 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m99FWOSS3268664
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 02:32:24 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m99FWObV026818
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 02:32:24 +1100
In-Reply-To: <1223566329-29434-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During filesystem recovery we may be doing a truncate
which expects some of the mballoc data structures to
be initialized. So do ext4_mb_init before recovery.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c760818..468ff72 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2452,6 +2452,21 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			"available.\n");
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
+				"requested data journaling mode\n");
+		clear_opt(sbi->s_mount_opt, DELALLOC);
+	} else if (test_opt(sb, DELALLOC))
+		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
+
+	ext4_ext_init(sb);
+	err = ext4_mb_init(sb, needs_recovery);
+	if (err) {
+		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
+		       err);
+		goto failed_mount4;
+	}
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -2471,21 +2486,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 	       "writeback");
 
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
-				"requested data journaling mode\n");
-		clear_opt(sbi->s_mount_opt, DELALLOC);
-	} else if (test_opt(sb, DELALLOC))
-		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
-
-	ext4_ext_init(sb);
-	err = ext4_mb_init(sb, needs_recovery);
-	if (err) {
-		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
-		       err);
-		goto failed_mount4;
-	}
