From: akpm@linux-foundation.org
Subject: [patch 81/83] ext3: fix mount option parsing
Date: Tue, 04 Mar 2008 14:29:43 -0800
Message-ID: <200803042229.m24MThCH032705@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jbacik@redhat.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759002AbYCDWiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 17:38:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

The "resize" option won't be noticed as it comes after the NULL option, so if
you try to mount (or in this case remount) with that option it won't be
recognized.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/super.c~ext3-fix-mount-option-parsing fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-mount-option-parsing
+++ a/fs/ext3/super.c
@@ -806,8 +806,8 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
-	{Opt_err, NULL},
 	{Opt_resize, "resize"},
+	{Opt_err, NULL},
 };
 
 static ext3_fsblk_t get_sb_block(void **data)
_
