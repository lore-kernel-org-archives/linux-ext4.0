From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Wed, 3 Dec 2008 12:23:09 -0500
Message-ID: <20081203172309.GB30610@mit.edu>
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de> <20081202203315.GA20858@mit.edu> <4935D4C0.7050601@x2a.org> <20081203153441.GD9481@skywalker>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Cc: Jonathan Bastien-Filiatrault <joe@x2a.org>,
	Andres Freund <andres@anarazel.de>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51865 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959AbYLCRXS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 12:23:18 -0500
Content-Disposition: inline
In-Reply-To: <20081203153441.GD9481@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2008 at 09:04:41PM +0530, Aneesh Kumar K.V wrote:
> 
> Can you make sure you have the below patch in the kernel.
> 
> c001077f4003fa75793bb62979baa6241dd8eb19
> 
> commit c001077f4003fa75793bb62979baa6241dd8eb19
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Tue Aug 19 22:19:50 2008 -0400
> 
> ext4: Fix bug where we return ENOSPC even though we have plenty of inodes
> 

Mmmm, good point, thanks.  I had been assuming this was caused by some
failure in the delayed allocation code with block accounting, but we
also had a bug fix that was causing a problem with inode allocation.

That doesn't explain a report of an ENOSPC error with metadata only
changes were failing (i.e., touching a file that already exists),
although I don't think we've gotten a lot of information about that
scenario and it feels a little unconfirmed to me still...

So, yes, this patch may solve the issue for you.

							- Ted

--ReaqsoxgOBHFXBhH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-bug-where-we-return-ENOSPC-even-though-we.patch"

>From c001077f4003fa75793bb62979baa6241dd8eb19 Mon Sep 17 00:00:00 2001
From: Eric Sandeen <sandeen@redhat.com>
Date: Tue, 19 Aug 2008 22:19:50 -0400
Subject: [PATCH] ext4: Fix bug where we return ENOSPC even though we have plenty of inodes

The find_group_flex() function starts with best_flex as the
parent_fbg_group, which happens to have 0 inodes free.  Some of the
flex groups searched have free blocks and free inodes, but the
flex_freeb_ratio is < 10, so they're skipped.  Then when a group is
compared to the current "best" flex group, it does not have more free
blocks than "best", so it is skipped as well.

This continues until no flex group with free inodes is found which has
a proper ratio or which has more free blocks than the "best" group,
and we're left with a "best" group that has 0 inodes free, and we
return -ENOSPC.

We fix this by changing the logic so that if the current "best" flex
group has no inodes free, and the current one does have room, it is
promoted to the next "best."

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 655e760..f344834 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -351,7 +351,7 @@ find_close_to_parent:
 			goto found_flexbg;
 		}
 
-		if (best_flex < 0 ||
+		if (flex_group[best_flex].free_inodes == 0 ||
 		    (flex_group[i].free_blocks >
 		     flex_group[best_flex].free_blocks &&
 		     flex_group[i].free_inodes))
-- 
1.6.0.4.8.g36f27.dirty


--ReaqsoxgOBHFXBhH--
