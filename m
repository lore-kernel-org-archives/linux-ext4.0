From: markn@au1.ibm.com
Subject: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS is not set
Date: Tue, 09 Oct 2007 15:50:34 +1000
Message-ID: <20071009061101.666614585@au1.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45378 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXJIGLh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 02:11:37 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l996BVHh000395
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:11:31 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l996BWae2539596
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:11:32 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l996BWm0009558
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:11:32 +1000
Content-Disposition: inline; filename=ext4-add-init_ext4_proc-stub.patch
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

init_ext4_fs() calls init_ext4_proc() so we need a stub init_ext4_proc()
for the case that CONFIG_PROC_FS is not set.
Without the stub we get a build error:

fs/ext4/mballoc.c: In function 'init_ext4_proc':
fs/ext4/mballoc.c:2837: error: 'proc_root_fs' undeclared (first use in this function)
fs/ext4/mballoc.c:2837: error: (Each undeclared identifier is reported only once
fs/ext4/mballoc.c:2837: error: for each function it appears in.)

Add a stub init_ext4_proc() function that does nothing but return 0

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
---
 fs/ext4/mballoc.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: ext4/fs/ext4/mballoc.c
===================================================================
--- ext4.orig/fs/ext4/mballoc.c
+++ ext4/fs/ext4/mballoc.c
@@ -2825,6 +2825,7 @@ static int ext4_mb_destroy_per_dev_proc(
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
 int __init init_ext4_proc(void)
 {
 	ext4_pspace_cachep =
@@ -2840,6 +2841,12 @@ int __init init_ext4_proc(void)
 
 	return 0;
 }
+#else
+int __init init_ext4_proc(void)
+{
+	return 0;
+}
+#endif
 
 void exit_ext4_proc(void)
 {

-- 
