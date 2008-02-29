From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Fri, 29 Feb 2008 11:59:48 -0800
Message-ID: <20080229195948.GN2997@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
 <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu>
 <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39913 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbYB2T7u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Feb 2008 14:59:50 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1TJxn2K026531
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 11:59:50 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX000L01NGBCV00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 29 Feb 2008 11:59:49 -0800 (PST)
In-reply-to: <20080229154333.GC8968@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 29, 2008  10:43 -0500, Theodore Ts'o wrote:
> * ad/nlinks-dir (Sat Feb 2 01:25:03 2008 -0700) 1 commit
>  - e2fsprogs-nlinks.patch
> 
> 	I'm really not sure about this change in e2fsck/pass4.c:
> 
> -			if (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx)) {
> +			/* i_link_count was previously exceeded, but no longer
> +			 * is, fix this but don't consider it an error */
> +			if ((LINUX_S_ISDIR(inode->i_mode) && link_counted > 1 &&
> +			     (inode->i_flags & EXT2_INDEX_FL) &&
> +			     link_count == 1 && !(ctx->options & E2F_OPT_NO)) ||
> +			     (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx))) {
>  				inode->i_links_count = link_counted;
>  				e2fsck_write_inode(ctx, i, inode, "pass4");
>  			}
> 
> 	Why do we require EXT2_INDEX_FL to be set before deciding that
> 	it's OK if the i_link_count is 1 but we now have less than
> 	EXT2_LINK_MAX links?

The reason that INDEX_FL is important here is because only indexed
directories are allowed to exceed 65000 entries in the kernel.  This is a
"save users from themselves" measure, because of the O(n^2) operations
needed to create/delete entries in unindexed directories.  It also helps
detect the difference between corruption and expected behaviour.

> 	As a result of the "make check" failures which I mentioned at
> 	the beginning of this note, I noticed the following
> 	unfortunate problem in how errors are getting reported in
> 	e2fsck pass 5.  As a sample:
> 
> Block bitmap differences:  +8195Group 3 block(s) in use but group is marked BLO
> CK_UNINIT
> Fix? yes
> 
> 	This mangling is happening because error reporting for
> 	PR_5_INODE_UNINIT is getting intermingled with the
> 	PR_5_INODE_USED/PR_5_INODE_UNUSED reporting, which isn't a
> 	good idea.  The comment around the code says:
> 
> 		/* 
> 		 * We should never hit this, because it means that
> 		 * inodes were marked in use that weren't noticed
> 		 * in pass1 or pass 2. It is easier to fix the problem
> 		 * than to kill e2fsck and leave the user stuck.
> 		 */
> 
> 	So I'm guessing there's something else wrong going on here....

Does this test case have both flexbg and uninit_groups?  Alternately,
maybe some part of the e2fsck fixup code is allocating blocks in the
group, but doesn't know that the UNINIT flag needs to be cleared.

Instead of burning a lot of time on diagnosing this, I'd suggest to
try using the original uninit_groups patchset + Jose's patch on top of
that series to see if that works better?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

