From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [7/7] Remove incorrect BKL comments in ext4
Date: Mon, 28 Jan 2008 11:16:16 +0100 (CET)
Message-ID: <20080128101616.C23F3152DF@wotan.suse.de>
References: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:33333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYA1KQR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:17 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id E78B826F2E
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:16 +0100 (CET)
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext4/dir.c   |    2 +-
 fs/ext4/inode.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux/fs/ext4/dir.c
===================================================================
--- linux.orig/fs/ext4/dir.c
+++ linux/fs/ext4/dir.c
@@ -46,7 +46,7 @@ const struct file_operations ext4_dir_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
-	.fsync		= ext4_sync_file,	/* BKL held */
+	.fsync		= ext4_sync_file,
 	.release	= ext4_release_dir,
 };
 
Index: linux/fs/ext4/inode.c
===================================================================
--- linux.orig/fs/ext4/inode.c
+++ linux/fs/ext4/inode.c
@@ -778,7 +778,6 @@ err_out:
  *
  * `handle' can be NULL if create == 0.
  *
- * The BKL may not be held on entry here.  Be sure to take it early.
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.
