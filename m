From: markn@au1.ibm.com
Subject: [patch 2/2] move init_ext4_proc() last and add cleanup call exit_ext4_proc()
Date: Tue, 09 Oct 2007 15:50:35 +1000
Message-ID: <20071009061102.363619477@au1.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45586 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbXJIGMG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 02:12:06 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l996C3Ku000787
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:12:03 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l996C5LV3465232
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:12:05 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l996Bnqf009815
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:11:49 +1000
Content-Disposition: inline; filename=ext4-move-init_ext4_proc-add-cleanup.patch
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The first problem that is addressed is that the addition of init_ext4_proc()
means that the code doesn't clean up after itself on a failure of
init_ext4_xattr(), and the second is that usually init_*_proc() should be
the last thing called, so we move it to the end and add the cleanup call to
exit_ext4_proc().

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
---
 fs/ext4/super.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: ext4/fs/ext4/super.c
===================================================================
--- ext4.orig/fs/ext4/super.c
+++ ext4/fs/ext4/super.c
@@ -2999,10 +2999,6 @@ static int __init init_ext4_fs(void)
 {
 	int err;
 
-	err = init_ext4_proc();
-	if (err)
-		return err;
-
 	err = init_ext4_xattr();
 	if (err)
 		return err;
@@ -3012,7 +3008,12 @@ static int __init init_ext4_fs(void)
 	err = register_filesystem(&ext4dev_fs_type);
 	if (err)
 		goto out;
+	err = init_ext4_proc();
+	if (err)
+		goto out_proc;
 	return 0;
+out_proc:
+	exit_ext4_proc();
 out:
 	destroy_inodecache();
 out1:

-- 
