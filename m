From: Kit Westneat <kwestneat@ddn.com>
Subject: e2fsck can't handle bad extents w/ bad bitmaps
Date: Tue, 10 Dec 2013 15:39:17 -0500
Message-ID: <52A77BF5.5060204@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:25985 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3LJUjY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 15:39:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

We ran into an issue recently where we had a filesystem that had both 
invalid bitmaps and corrupted extent nodes. The issue was that currently 
the fix for a corrupted extent requires that the bitmaps be read in:
pass1.c +2250, scan_extent_node:
             pctx->blk = extent.e_pblk;
             pctx->blk2 = extent.e_lblk;
             pctx->num = extent.e_len;
             if (fix_problem(ctx, problem, pctx)) {
 >>              e2fsck_read_bitmaps(ctx);
                 pctx->errcode =
                     ext2fs_extent_delete(ehandle, 0);

Which then fails:
e2fsck/util.c +272, e2fsck_read_bitmaps:
     if (ctx->invalid_bitmaps) {
         com_err(ctx->program_name, 0,
             _("e2fsck_read_bitmaps: illegal bitmap block(s) for %s"),

We just ended up adding a patch to ignore the bad extents, but I just 
wanted to let people know that this problem exists.

Thanks,
Kit

-- 
---
Kit Westneat
L3 Lustre Support, DDN
703-659-3869

