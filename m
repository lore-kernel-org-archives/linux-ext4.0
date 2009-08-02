From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix device too big bug in mainline?
Date: Sat, 1 Aug 2009 23:49:47 -0400
Message-ID: <20090802034947.GA15828@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58156 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZHBDt4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Aug 2009 23:49:56 -0400
Content-Disposition: inline
In-Reply-To: <20090802022209.GC8680@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 01, 2009 at 10:22:09PM -0400, Theodore Tso wrote:
> temporary checkin; about to do checksum conversion
> 
> From: Valerie Aurora Henson <vaurora@redhat.com>
> 
> Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>

BTW, while I was painstakingly picking apart this patch, separating it
into its constiuent pieces, I found the following bug in it:

diff --git a/e2fsck/super.c b/e2fsck/super.c
index c269b0e..a1fb878 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
	....
 			if (fix_problem(ctx, PR_0_GDT_UNINIT, &pctx)) {
-				gd->bg_flags &= ~(EXT2_BG_BLOCK_UNINIT |
-						  EXT2_BG_INODE_UNINIT);
-				gd->bg_itable_unused = 0;
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
 				should_be = 1;
 			}


This patch hunk (buried deep within the 800+ lines of the "temporary
checkin; about to do checksum conversion" patch) removed this line:

				gd->bg_itable_unused = 0;

... but failed to replace it with this line:

				ext2fs_bg_itable_unused_set(fs, i, 0);

This is *why* I insist on auditable patches, and why I can't just
blindly merge the 64-bit branch.  When multiple semantic changes are
mushed up all together in one gigundo patch, it's really easy to miss
omissions like this, and since we don't have a regression test to test
this specific repair, we would have never noticed.

And no, it's no fun for me to be picking through this patch set at on
a Saturday evening on a Summer evening; I'd rather be in Lenox,
enjoying a concert at Tanglewood.  But someone has got to do it...

	     	      		     	     	     - Ted

