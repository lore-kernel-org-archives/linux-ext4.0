From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix reference counting bug on block allocation
 error
Date: Thu, 14 Jul 2016 23:01:55 -0400
Message-ID: <20160715030155.GB26465@thunk.org>
References: <1467813452-26763-1-git-send-email-vegard.nossum@oracle.com>
 <577E3B53.3070502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54804 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbcGODCC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2016 23:02:02 -0400
Content-Disposition: inline
In-Reply-To: <577E3B53.3070502@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2016 at 01:21:55PM +0200, Vegard Nossum wrote:
> 
> The attached new patch just returns on error instead of trying to fix
> the problem.

The issue with your v2 patch is that we end up returning EAGAIN to
userspace, which is confusing.  So I've fixed up your patch by adding
the following changes.

Thanks,

					- Ted

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5399b88..1156216 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2943,7 +2943,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_error(sb, "Allocating blocks %llu-%llu which overlap "
 			   "fs metadata", block, block+len);
 		/* File system mounted not to panic on error
-		 * Fix the bitmap and repeat the block allocation
+		 * Fix the bitmap and return EFSCORRUPTED
 		 * We leak some of the blocks here.
 		 */
 		ext4_lock_group(sb, ac->ac_b_ex.fe_group);
@@ -2952,7 +2952,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
-			err = -EAGAIN;
+			err = -EFSCORRUPTED;
 		goto out_err;
 	}
 
