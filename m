From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-10.diff>
Date: Fri, 9 Feb 2007 18:11:08 -0800
Message-ID: <200702100211.l1A2B8c0006999@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:14899 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXBJCOU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 10: Null Returns

It is possible that e2fsck_get_dir_info() returns a NULL pointer.
We do not want to blow up when dereferencing p.  It seems to be
more sane/safe to call fix_problem(ctx, PR_3_NO_DIRINFO, pctx)
if p is NULL at this point since we do not have any DIRINFO
for pctx->ino.

Index: e2fsprogs+chaos/e2fsck/pass3.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass3.c
+++ e2fsprogs+chaos/e2fsck/pass3.c
@@ -306,6 +306,10 @@ static int check_directory(e2fsck_t ctx,
 					ext2fs_unmark_valid(fs);
 				else {
 					p = e2fsck_get_dir_info(ctx, pctx->ino);
+					if(!p) {
+						fix_problem(ctx, PR_3_NO_DIRINFO, pctx);
+						return 0;
+					}
 					p->parent = ctx->lost_and_found;
 					fix_dotdot(ctx, p, ctx->lost_and_found);
 				}
