From: Justin Maggard <jmaggard10@gmail.com>
Subject: Broken e2fsck i_blocks repair
Date: Wed, 1 Sep 2010 16:01:22 -0700
Message-ID: <AANLkTinT3O20u-iE4Mu2ikSPa4bdhVsM+a82p6Hoeu8K@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42168 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0IAXB4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Sep 2010 19:01:56 -0400
Received: by yxp4 with SMTP id 4so1542262yxp.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Sep 2010 16:01:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've mentioned this before on here, but I never verified whether or
not it was actually broken.  I have done so today.  I manually
modified the block count of a 3TB file using debugfs, then ran e2fsck
on it.  e2fsck claimed to repair it, but would throw an error on every
subsequent e2fsck run for the same issue.  The reason is
inode->osd2.linux2.l_i_blocks_hi is always set to 0 if e2fsck is told
to fix it.  This is an issue in both stable 1.41.12, and in master.
This patch fixes it for me, but is there anything else that needs to
get checked here?

diff -urp e2fsprogs-1.41.12/e2fsck/pass1.c e2fsprogs-1.41.12-jm/e2fsck/pass1.c
--- e2fsprogs-1.41.12/e2fsck/pass1.c	2010-05-14 14:51:21.000000000 -0700
+++ e2fsprogs-1.41.12-jm/e2fsck/pass1.c	2010-09-01 15:54:42.000000000 -0700
@@ -2044,7 +2044,7 @@ static void check_blocks(e2fsck_t ctx, s
 		pctx->num = pb.num_blocks;
 		if (fix_problem(ctx, PR_1_BAD_I_BLOCKS, pctx)) {
 			inode->i_blocks = pb.num_blocks;
-			inode->osd2.linux2.l_i_blocks_hi = 0;
+			inode->osd2.linux2.l_i_blocks_hi = (pb.num_blocks >> 32);
 			dirty_inode++;
 		}
 		pctx->num = 0;

-Justin
