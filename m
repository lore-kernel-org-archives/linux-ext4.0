From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 1/3] e2fsck: Remove unnecessary continue statement
Date: Mon, 06 Jul 2009 17:14:13 +0900
Message-ID: <4A51B255.1090309@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58674 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZGFISx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 04:18:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove the continue statement because it calls at the end of the loop.

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 pass2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index bb3813c..889e39d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -243,8 +243,6 @@ void e2fsck_pass2(e2fsck_t ctx)
 				fix_problem(ctx, code, &pctx);
 				bad_dir++;
 			}
-			if (code == 0)
-				continue;
 		}
 		if (bad_dir && fix_problem(ctx, PR_2_HTREE_CLEAR, &pctx)) {
 			clear_htree(ctx, dx_dir->ino);
