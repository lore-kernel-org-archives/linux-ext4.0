From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Valgrind-detected issues in e2fsck on corrupted filesystems
Date: Mon, 27 Oct 2014 10:10:00 -0700
Message-ID: <20141027171000.GA10057@birch.djwong.org>
References: <20141018232320.GA4392@sli.dy.fi>
 <20141020205736.GB13081@birch.djwong.org>
 <20141026104708.GA31873@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35844 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaJ0RKO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 13:10:14 -0400
Content-Disposition: inline
In-Reply-To: <20141026104708.GA31873@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 26, 2014 at 12:47:09PM +0200, Sami Liedes wrote:
> On Mon, Oct 20, 2014 at 01:57:36PM -0700, Darrick J. Wong wrote:
> > Thanks for catching these!  I'll have patches out shortly.
> 
> Great! With your patches applied I could no longer get any valgrind
> errors on ext4 during overnight fuzz testing.
> 
> Here's one more I found which only shows on ext[23], with or without
> your recent patches. It seems that the error message "Unexpected block
> in HTREE directory inode %d (%q)" is printed with uninitialized values
> for both the %d and the %q conversions.

I think the following patch fixes this problem; can you give it a spin?

--D
---
From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] e2fsck: fix reporting of unknown htree block inode number

Sami Liedes reports that e2fsck fails to report the correct directory
inode number during a pass2 check for unexpected HTREE blocks.
Provide the inode number in the problem report.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Sami Liedes <sami.liedes@iki.fi>
---
 e2fsck/pass2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index fa17f20..f645229 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1006,6 +1006,7 @@ inline_read_fail:
 	dx_dir = e2fsck_get_dx_dir_info(ctx, ino);
 	if (dx_dir && dx_dir->numblocks) {
 		if (db->blockcnt >= dx_dir->numblocks) {
+			pctx.dir = ino;
 			if (fix_problem(ctx, PR_2_UNEXPECTED_HTREE_BLOCK,
 					&pctx)) {
 				clear_htree(ctx, ino);
