From: Artemiy Volkov <artemiyv@acm.org>
Subject: [PATCH] e2fsck: do not read EA header beyond the end of an inode
Date: Thu, 26 Nov 2015 19:24:28 +0000
Message-ID: <1448565868-14893-1-git-send-email-artemiyv@acm.org>
Cc: Artemiy Volkov <artemiyv@acm.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38664 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbbKZTYp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Nov 2015 14:24:45 -0500
Received: by wmec201 with SMTP id c201so33581450wme.1
        for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2015 11:24:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In check_inode_extra_space(), if we attempt to read an EA header at
the end of the extra space, in a corrupted filesystem it may result in
a read beyond the bounds of the inode. Add a check to prevent this.

Reproduced by running ./test_one --valgrind f_write_ea_toobig_extra_isize.

Signed-off-by: Artemiy Volkov <artemiyv@acm.org>
---
 e2fsck/pass1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 0a8e23e..f1c99ea 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -482,6 +482,10 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
                return;
        }

+        /* check if there is no place for an EA header */
+        if (inode->i_extra_isize >= max - sizeof(__u32))
+                return;
+
        eamagic = (__u32 *) (((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
                        inode->i_extra_isize);
        if (*eamagic == EXT2_EXT_ATTR_MAGIC) {
-- 
2.6.2
