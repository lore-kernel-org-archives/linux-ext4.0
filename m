From: Jayson King <dev@jaysonking.com>
Subject: Re: [Bug 9692] New: journal_data mount option causes filesystem
Date: Sun, 06 Jan 2008 19:30:37 -0600
Message-ID: <478180BD.3050204@jaysonking.com>
Reply-To: dev@jaysonking.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060703040802070803020500"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx01.mailboxcop.com ([206.125.223.71]:58707 "EHLO
	mx01.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYAGDJE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jan 2008 22:09:04 -0500
Received: from secure6.apollohosting.com ([206.125.222.106])
	by mx01.mailboxcop.com (8.13.8/8.13.8) with ESMTP id m071X3E9030315
	for <linux-ext4@vger.kernel.org>; Sun, 6 Jan 2008 19:33:03 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060703040802070803020500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
 >On Sat,  5 Jan 2008 09:52:15 -0800 (PST) 
bugme-daemon@bugzilla.kernel.org wrote:
 >> http://bugzilla.kernel.org/show_bug.cgi?id=9692
 >>
 >>            Summary: journal_data mount option causes filesystem 
corruption
 >>                     with blocksize != 4096
 >>            Product: File System
 >>            Version: 2.5
 >>      KernelVersion: 2.6.23.9
 >>           Platform: All
 >>         OS/Version: Linux
 >>               Tree: Mainline
 >>             Status: NEW
 >>           Severity: high
 >>           Priority: P1
 >>          Component: ext3
 >>         AssignedTo: akpm@osdl.org
 >>         ReportedBy: h.judt@gmx.at

This looks to be an off-by-one bug with e2fsck in the function
check_blocks(), and there isn't any actual filesystem corruption
(e2fsck causes the corruption).

Please see the attached patch, which fixes the problem for me.

Jayson King


--------------060703040802070803020500
Content-Type: text/plain;
 name="0001-e2fsck-Fix-off-by-one-error-in-check_blocks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-e2fsck-Fix-off-by-one-error-in-check_blocks.patch"

>From 654f24814e7b80d3b16bec2a67c13c43cb20eb2f Mon Sep 17 00:00:00 2001
From: Jayson R. King <dev@jaysonking.com>
Date: Sun, 6 Jan 2008 18:14:18 -0600
Subject: e2fsck: Fix off-by-one error in check_blocks()

e2fsck allows extra blocks to be allocated to an inode up to the next
multiple of page size iff the block size is not equal to page size. An
off-by-one error in checking for this causes e2fsck to wrongly detect
a bad i_size for such inodes and results in incorrectly adjusting the
i_size to include those blocks.

Signed-off-by: Jayson R. King <dev@jaysonking.com>
---
 e2fsck/pass1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 56218ae..7bf0686 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1593,7 +1593,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		if ((pb.last_block >= 0) &&
 		    /* allow allocated blocks to end of PAGE_SIZE */
 		    (size < (__u64)pb.last_block * fs->blocksize) &&
-		    (pb.last_block / blkpg * blkpg != pb.last_block ||
+		    ((pb.last_block+1) & (blkpg-1) != 0 ||
 		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
 			bad_size = 3;
 		else if (size > ext2_max_sizes[fs->super->s_log_block_size])
-- 
1.5.3.3



--------------060703040802070803020500--
