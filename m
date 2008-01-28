From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [4/7] ext3: Remove incorrect BKL comment
Date: Mon, 28 Jan 2008 11:16:13 +0100 (CET)
Message-ID: <20080128101613.96CD215310@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYA1KQP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:15 -0500
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DDDCE3097B
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:13 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


There is no BKL held on entry in ->fsync nor in the low level ext3_sync_file.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext3/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/ext3/dir.c
===================================================================
--- linux.orig/fs/ext3/dir.c
+++ linux/fs/ext3/dir.c
@@ -46,7 +46,7 @@ const struct file_operations ext3_dir_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.fsync		= ext3_sync_file,	/* BKL held */
+	.fsync		= ext3_sync_file,
 	.release	= ext3_release_dir,
 };
 
