From: Stephan Kulow <coolo@suse.de>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 15:11:59 +0200
Message-ID: <200909101511.59236.coolo@suse.de>
References: <200909101455.38400.coolo@suse.de> <200909101503.18497.coolo@suse.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fsPqKN+3QYQ8tmQ"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZIJNL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 09:11:56 -0400
Received: from relay2.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id A28575362F
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 15:11:59 +0200 (CEST)
In-Reply-To: <200909101503.18497.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Boundary-00=_fsPqKN+3QYQ8tmQ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Donnerstag 10 September 2009 sent Stephan Kulow:
> Donnerstag 10 September 2009 sent Stephan Kulow:
> > The release notes of 1.41.9 talk only about the exact opposite
> > case: "Fix e2fsck's buggy_init_scritps=1 so that the if the last
> > write and/or last mount times are in the future, they are corrected
> > even if buggy_init_scripts is set."
> 
> If I read the code correctly, the problem is that time_fudge is 0 for
> buggy_init_scripts=0 and as such there is no difference between
> PR_0_FUTURE_SB_LAST_MOUNT_FUDGED and PR_0_FUTURE_SB_LAST_MOUNT
> and so openSUSE always falls into the PR_0_FUTURE_SB_LAST_MOUNT
> 
> -> no PR_PREEN_OK
> 
Attached is my try to fix the problem (note that I also noticed another 
problem, it talks about LAST_MOUNT in the wtime case).

Greetings, Stephan

--Boundary-00=_fsPqKN+3QYQ8tmQ
Content-Type: text/x-patch;
  charset="UTF-8";
  name="fix_super.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix_super.diff"

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 2202967..76390af 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -821,9 +821,9 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	if (fs->super->s_mtime > (__u32) ctx->now) {
 		pctx.num = fs->super->s_mtime;
-		problem = PR_0_FUTURE_SB_LAST_MOUNT;
-		if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
-			problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
+		problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
+		if (ctx->time_fudge && fs->super->s_mtime > (__u32) ctx->now + ctx->time_fudge)
+			problem = PR_0_FUTURE_SB_LAST_MOUNT;
 		if (fix_problem(ctx, problem, &pctx)) {
 			fs->super->s_mtime = ctx->now;
 			ext2fs_mark_super_dirty(fs);
@@ -831,9 +831,9 @@ void check_super_block(e2fsck_t ctx)
 	}
 	if (fs->super->s_wtime > (__u32) ctx->now) {
 		pctx.num = fs->super->s_wtime;
-		problem = PR_0_FUTURE_SB_LAST_WRITE;
-		if (fs->super->s_wtime <= (__u32) ctx->now + ctx->time_fudge)
-			problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
+		problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
+		if (ctx->time_fudge && fs->super->s_wtime > (__u32) ctx->now + ctx->time_fudge)
+			problem = PR_0_FUTURE_SB_LAST_WRITE;
 		if (fix_problem(ctx, problem, &pctx)) {
 			fs->super->s_wtime = ctx->now;
 			ext2fs_mark_super_dirty(fs);

--Boundary-00=_fsPqKN+3QYQ8tmQ--
