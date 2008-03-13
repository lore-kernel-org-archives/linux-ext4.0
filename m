From: Andreas Dilger <adilger@sun.com>
Subject: Re: The e2fsprogs nlinks-dir patch
Date: Thu, 13 Mar 2008 12:01:27 -0700
Message-ID: <20080313190127.GG3217@webber.adilger.int>
References: <E1JZr6d-0004yL-1m@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56431 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbYCMTCH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 15:02:07 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2DJ25wo025775
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 12:02:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXO00G01MZ7SK00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Mar 2008 12:02:05 -0700 (PDT)
In-reply-to: <E1JZr6d-0004yL-1m@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 13, 2008  13:20 -0400, Theodore Ts'o wrote:
> I was just auditing the e2fsprogs nlinks-dir patch, and I think there
> are some problems with it.   First of all, it creates a whole new set of
> icount abstractions so it can count using a 32-bit count.  That's
> strictly not necessary, since all e2fsck cares about is whether the
> count is bigger than EXT2_LINK_MAX, or 65,000.   

One of the reasons for this change is the ability to actually count
nlinks > 65536 - the old code would just blindly wrap if this ever
happened.  It might also be useful in the future if we rejig the
256-byte inode to have a 32-bit i_nlink count.

There was some other bit of code we were working on that needed a 32-bit
icount, but I can't recall what it is right now.  Maybe Girish or Kalpak
will recall?

> The bigger problem is that it fetches the actual number of
> subdirectories (which could be some very large number, like 65538, or
> some number much larger than 2**16):
> 
> 		ext2fs_icount_fetch32(ctx->inode_count, i, &link_counted);
> 
> It then tests to see if the on-disk count is OK, which it does this way:
> 
> 		if (link_counted != link_count &&
> 		    !(ext2fs_test_inode_bitmap(ctx->inode_dir_map, i) &&
> 		      link_count == 1 && link_counted > EXT2_LINK_MAX)) {
> 
> So if it is the actual and on-disk count is different, but the inode in
> question is an inode and the on-disk count is 1, but the actual count is
                 ^^^^^ directory?

> greater than EXT2_LINK_MAX, it's OK.  Otherwise, we need to Take Action.
> 
> OK, but what if the on-disk count is some number less than EXT2_LINK_MAX
> --- say, 64,999?  And what if the actual number of subdiretories is
> somewhat larger and greater than EXT2_LINK_MAX, say, like 65538?   Well,
> then the code blindly assignens the 32-bit link_counted to the 16-bit
> on-disk i_links_count field, and writes it to disk:
> 
> 				inode->i_links_count = link_counted;
> 				e2fsck_write_inode(ctx, i, inode, "pass4");
> 
> The number 65538 will get masked down to 2.  Hilarity then ensues.

Can you expand?  I tested the kernel and a link count of 2 will still
result in the "ext3_is_empty()" function being called prior to doing
the unlink and it will be refused.  If a subdirectory is removed at
that point nlink will go down to 1 again and all is well?

> + * We now use a 32-bit counter field because it doesn't cost us
> + * anything extra for the in-memory data structure, due to alignment
> + * padding.  But there's no point changing the interface if most of
> + * the time we only care if the number is bigger than 65,000 or not.
> + * So use the following translation function to return a 16-bit count.
> + */
> +#define icount_16_xlate(x) (((x) > 65500) ? 65500 : (x))

This hack does make the patch a lot less intrusive...

I don't have any objections.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

