From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 2/5] ext4: unlock group before ext4_error
Date: Sun, 23 Nov 2008 08:37:04 -0500
Message-ID: <20081123133704.GA26473@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37162 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757768AbYKWNhY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 08:37:24 -0500
Content-Disposition: inline
In-Reply-To: <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 10:14:32PM +0530, Aneesh Kumar K.V wrote:
> Otherwise ext4_error will cause BUG because of
> scheduling in atomic context.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When I tried adding this patch to the patch queue, I got the following
rejected chunk:

diff a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c	(rejected hunks)
@@ -3791,8 +3790,9 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 			pa, (unsigned long) pa->pa_lstart,
 			(unsigned long) pa->pa_pstart,
 			(unsigned long) pa->pa_len);
-		ext4_error(sb, __func__, "free %u, pa_free %u\n",
-						free, pa->pa_free);
+		ext4_grp_locked_error(sb, group,
+					__func__, "free %u, pa_free %u\n",
+					free, pa->pa_free);
 		/*
 		 * pa is already deleted so we use the value obtained
 		 * from the bitmap and continue.

This looks like it came from the patch
aneesh-8-fix-double-free-of-blocks which in a message sent roughly at
the same time you told me to drop from the patch queue.  So I'm adding
this to the patch queue without this rejected hunk.

One of the challenges right now with applying your patches is that you
have a large number of patches in the unstable part of the tree, and
when you send me new patches, it's not clear where they apply and
since they are entagled with each other, I may get some of the wrong.

If there are certain patches which we are sure are OK, such as the
sparse fixes, I can move them into the stable part of the tree and
assume they aren't going to change moving forward.  But for patches
which are unstable, I'm going to need some help from you to make sure
they get applied in a sane and stable order....

							- Ted
