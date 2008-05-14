From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: printk stack trace on ext4_error, ext4_abort and ext4_warning.
Date: Thu, 15 May 2008 00:17:10 +0530
Message-ID: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36889 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbYENSrQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 14:47:16 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4EIlDCg002516
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:13 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4EIl3OR1298438
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:03 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4EIlCWq023834
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:13 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This helps in better debugging of the problem reported.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cd7cac0..93f4820 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -238,6 +238,7 @@ void ext4_error (struct super_block * sb, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	dump_stack();
 
 	ext4_handle_error(sb);
 }
@@ -320,6 +321,7 @@ void ext4_abort (struct super_block * sb, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	dump_stack();
 
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT4-fs panic from previous error\n");
@@ -345,6 +347,7 @@ void ext4_warning (struct super_block * sb, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	dump_stack();
 }
 
 void ext4_update_dynamic_rev(struct super_block *sb)
-- 
1.5.5.1.211.g65ea3.dirty

