From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
 FLEX_BG v2
Date: Tue, 25 Mar 2008 17:12:02 -0500
Message-ID: <20080325171202.1dce62a6@gara>
References: <20080213204750.5666a560@gara>
	<20080324134650.GA13621@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45098 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYCYWMG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Mar 2008 18:12:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2PME8t3022622
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 18:14:08 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2PMC5BW223350
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 18:12:05 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2PMC5nU029065
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 18:12:05 -0400
In-Reply-To: <20080324134650.GA13621@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Mar 2008 09:46:50 -0400
Theodore Tso <tytso@MIT.EDU> wrote:
> Just looking at it quickly, it seems like the right thing to do is
> split setup_lazy_bg() into two parts.  The first part sets
> EXT2_BG_BLOCK_UNINIT for all block groups, and then we modify the
> block allocation functions in lib/ext2fs to clear the BLOCK_UNINIT
> flag --- and then later on, we update the bg_free_blocks_count and
> s_free_blocks_count for the lazy_bg case.  

Hi Ted,

As I started looking at implementing this, I noticed that patch in pu
has some chunks that don't belong to the flex_bg patch.  These are the
offending lines at the end on the commit:

+       if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
+               com_err(program_name, 0,
+                       _("Filesystem too large.  No more than 2**31-1 blocks\n"
+                         "\t (8TB using a blocksize of 4k) are currently supported."));
+             exit(1);
+       }
+
+       if ((blocksize > 4096) &&
+           (fs_param.s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+               fprintf(stderr, _("\nWarning: some 2.4 kernels do not support "
+                       "blocksizes greater than 4096\n\tusing ext3.  "
+                       "Use -b 4096 if this is an issue for you.\n\n"));
+

These line probably got damaged during one of the merges.  You probably
want to fix this so that the changes are not lost when rebasing to a
newer flex_bg patch.

-JRS
