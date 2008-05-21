From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH] Display bad depth in error message
Date: Wed, 21 May 2008 18:19:59 +0530
Message-ID: <1211374199.7317.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:65430 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYEUMt6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 08:49:58 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m4LCoE46021546
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 12:50:15 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K1700801Y8ZSW00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Wed,
 21 May 2008 20:48:35 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

It would be good to actually print the bad htree depth as part of the error message.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

Index: e2fsprogs-1.40.7/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.40.7.orig/e2fsck/pass2.c
+++ e2fsprogs-1.40.7/e2fsck/pass2.c
@@ -213,6 +213,7 @@ void e2fsck_pass2(e2fsck_t ctx)
                        if (dx_db->type == DX_DIRBLOCK_LEAF) {
                                depth = htree_depth(dx_dir, dx_db);
                                if (depth != dx_dir->depth) {
+                                       pctx.num = dx_dir->depth;
                                        code = PR_2_HTREE_BAD_DEPTH;
                                        fix_problem(ctx, code, &pctx);
                                        bad_dir++;
Index: e2fsprogs-1.40.7/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.7.orig/e2fsck/problem.c
+++ e2fsprogs-1.40.7/e2fsck/problem.c
@@ -1288,7 +1288,7 @@ static struct e2fsck_problem problem_tab

        /* Node in HTREE directory has invalid depth */
        { PR_2_HTREE_BAD_DEPTH,
-         N_("@p @h %d: node (%B) has @n depth\n"),
+         N_("@p @h %d: node (%B) has @n depth (%N)\n"),
          PROMPT_NONE, 0 },

        /* Duplicate directory entry found */

Thanks,
Kalpak

