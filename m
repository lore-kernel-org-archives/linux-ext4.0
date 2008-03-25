From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH e2fsprogs-next] Fix extent flag validity tests in pass1	on
 big endian boxes.
Date: Mon, 24 Mar 2008 18:32:51 -0600
Message-ID: <20080325003250.GM2691@webber.adilger.int>
References: <47E82796.9050807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46522 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbYCYAdD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 20:33:03 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2P0X1Qo024988
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 17:33:01 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JY900J01G3HIE00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 24 Mar 2008 17:33:01 -0700 (PDT)
In-reply-to: <47E82796.9050807@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 24, 2008  17:13 -0500, Eric Sandeen wrote:
> Extent data is shared with the i_block[] space in the inode,
> but it is always swapped on access, not when the inode is read.
> 
> In e2fsck/pass1.c we must be careful when checking validity
> of the extents flag on the inode.  If the flag was set when
> the inode was read & swapped, then the extents data itself
> (in ->i_block[]) was NOT swapped, so testing for a valid
> extent header requires some swapping first.  Then, if we
> ultimately set the extents flag, all of i_block[] must be
> re/un-swapped.

This seems pretty awkward for any other users of the library.  Having the
i_block[] array NOT be swabbed if it is an extent file means that every
place in the code which is accessing this array also needs to do the
swabbing itself.  This would break the abstraction that the in-memory
inode is in host-endian order, and also forces every application to
understand the difference between extent- and non-extent-mapped inodes,
and the on-disk byte order.  Ugh.

IMHO, it would be better to swab the i_block[] array in
ext2fs_swap_inode_full() if the EXTENTS_FL is set, and in the rare
case of e2fsck needing to clear that flag then it should un-swap (if
needed), clear the flag, and re-swap (if needed).  This will very rarely
happen, I think.  Note that the Lustre extents patches did NOT do the
swap+clear_swap operation when clearing the extents flags because we
don't have any big-endian server systems (our PPC testing is limited to
userspace "make check"), though I think that is the right thing to do.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

